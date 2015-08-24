unit SFPHelper;

interface uses Types, SysUtils, Classes,
  StreamUtil;

const

// SIMPLE FRAMED PROTOCOL
                                                           // 0   1
  SFP_FRAME_BOUND                    = $F0;                // bnd
  SFP_ESCAPE_START                   = $F1;                // esc
  SFP_ESCAPE_COMMAND_MIN             =   0;                // esc 00
  SFP_ESCAPE_COMMAND_ECHO_FRAME_BOUND= $00;                // esc 00
  SFP_ESCAPE_COMMAND_ECHO_ESCAPE     = $01;                // esc 01
  SFP_ESCAPE_COMMAND_MAX             = $0F;                // esc 0F

  DEFAULT_PIPE_BUFFER_SIZE           = 1024;

type

  ESFPInvalidPacket = class(Exception)
  end;

  ESFPEOF = class(Exception)
  end;

  TSFPHelper = class
  public
    class procedure internalWrite(dest: TStream; size: integer; buffer: pointer);
    class procedure internalRead (src : TStream; size: integer; buffer: pointer);
    class function internalReadRawFrame(src: TPushbackReadStream; waitForData: PBoolean = nil): TByteDynArray;

    class procedure writeFrameBound(dest: TStream);
    class procedure writeData      (dest: TStream; size: longint; const buffer: pointer);
    class procedure writeFrame     (dest: TStream; size: longint; const buffer: pointer);

    class function readFrame(src: TPushbackReadStream; waitForData: PBoolean = nil): TByteDynArray; overload;
  end;



implementation uses Math;

class procedure TSFPHelper.internalWrite(dest: TStream; size: integer; buffer: pointer);
  var count: longint;
  var p: pAnsiChar;
  var zeroCounter: integer;
  begin
    if size <= 0 then
      exit;

    zeroCounter:= 0;
    p:= buffer;
    repeat
      count:= dest.write(p^, min(DEFAULT_PIPE_BUFFER_SIZE, size));
      if count = size then
        break;

      if 0 = count then
        begin
          if 0 < zeroCounter then
            begin
              sleep(100);
              zeroCounter:= 0;
            end
          else
            zeroCounter:= zeroCounter + 1;
        end;
      p:= p + count;
      size:= size - count;
    until false;
  end;

class procedure TSFPHelper.internalRead(src: TStream; size: integer; buffer: pointer);
  var count: longint;
  var p: pAnsiChar;
  {
  var zeroCounter: integer;
  }
  begin
    if size <= 0 then
      exit;
    {
    zeroCounter:= 0;
    }
    p:= buffer;
    repeat
      count:= src.read(p^, size);
      if 0 = count then
        begin
          raise ESFPEOF.create('EOF');
          {
          if 0 < zeroCounter then
            begin
              sleep(100);
              zeroCounter:= 0;
            end
          else
            zeroCounter:= zeroCounter + 1;
          }
        end;
      {
      if count <> size then
        sleep(100);
      }
      if count = size then
        break;

      p:= p + count;
      size:= size - count;
    until false;
  end;

class procedure TSFPHelper.writeFrameBound(dest: TStream);
  const data: byte = SFP_FRAME_BOUND;
  begin
    internalWrite(dest, sizeof(data), @data)
  end;

class procedure TSFPHelper.writeData      (dest: TStream; size: longint; const buffer: pointer);
  const ESCAPE_CHAR     : byte = SFP_ESCAPE_START                   ;
  const ECHO_FRAME_BOUND: byte = SFP_ESCAPE_COMMAND_ECHO_FRAME_BOUND;
  const ECHO_ESCAPE_CHAR: byte = SFP_ESCAPE_COMMAND_ECHO_ESCAPE     ;
  var startChunk: pAnsiChar;
  var p         : pAnsiChar;
  var chunkSize : integer;
  var totalLeft : integer;
  begin

    if size <= 0 then
      exit;

    startChunk:= buffer;
    chunkSize := 0;
    totalLeft := size;
    p:= startChunk + chunkSize;
    repeat
      if totalLeft = 0 then
        break;

      if (pbyte(p)^ = SFP_FRAME_BOUND )
      or (pbyte(p)^ = SFP_ESCAPE_START)
      then
        begin
          internalWrite(dest, chunkSize, startChunk);
          internalWrite(dest, 1        , @ESCAPE_CHAR);
          if (pbyte(p)^ = SFP_FRAME_BOUND) then
            internalWrite(dest, 1        , @ECHO_FRAME_BOUND) else
            internalWrite(dest, 1        , @ECHO_ESCAPE_CHAR);
        //totalLeft:= totalLeft - chunkSize;
          startChunk:= p + 1;
          chunkSize:= 0;
        end
      else
        chunkSize:= chunkSize + 1;


      totalLeft:= totalLeft - 1;

      p:= p + 1;
    until false;
    if chunkSize > 0 then
      begin
        internalWrite(dest, chunkSize, startChunk);
      end;
  end;

class procedure TSFPHelper.writeFrame     (dest: TStream; size: longint; const buffer: pointer);
  begin
    writeFrameBound(dest);
    writeData      (dest, size, buffer);
    writeFrameBound(dest);
  end;

{
class function TSFPHelper.internalReadRawFrame(src: TPushbackReadStream; waitForData: PBoolean = nil): TByteDynArray;
  var resultSize: integer;
  var test      : byte   ;
  begin
    if assigned(waitForData) then
      waitForData^:= false;

    resultSize:= 0;
    setLength(result, 1024 * 1024);
    repeat
      if 0 = src.read(test, 1) then
        begin
          setLength(result, 0);
          if 0 < resultSize then
            begin
              src.pushback(result, resultSize);
            end;
          if assigned(waitForData) then
            waitForData^:= true;
          exit;
        end;

      if SFP_FRAME_BOUND = test then
        begin
          setLength(result, resultSize); 
          exit;
        end;

      resultSize:= resultSize + 1;

      if length(result) < resultSize then
        setLength(result, length(result) * 2);

      result[resultSize - 1]:= test;

    until false;
  end;
}
class function TSFPHelper.internalReadRawFrame(src: TPushbackReadStream; waitForData: PBoolean = nil): TByteDynArray;
  var temp      : TByteDynArray;
  var resultSize: integer;
  var test      : byte   ;
  var readsize  : integer;
  var i         : integer;
  begin
    setlength(temp, 1024 * 1024);

    if assigned(waitForData) then
      waitForData^:= false;

    resultSize:= 0;
    setLength(result, 1024 * 1024);
    repeat
      //readSize:= src.read(temp[0], length(temp));
      //readSize:= tryReadAvailableBytes(src, temp[0], length(temp));
      readSize:= tryReadAvailableBytesOrLock(src, temp[0], length(temp));
      if 0 = readSize then
        begin
          if 0 < resultSize then
            begin
              src.pushback(result[0], resultSize);
            end;
          if assigned(waitForData) then
            waitForData^:= true;

          setLength(result, 0);
          exit;
        end;

      for i:= 0 to readSize - 1 do
        begin
          test:= temp[i];
          if SFP_FRAME_BOUND = test then
            begin
              setLength(result, resultSize);
              src.pushback(temp[i + 1], readSize - 1 - i);
              exit;
            end;

          resultSize:= resultSize + 1;

          if length(result) < resultSize then
            setLength(result, length(result) * 2);

          result[resultSize - 1]:= test;
        end;
    until false;
  end;


class function TSFPHelper.readFrame(src: TPushbackReadStream; waitForData: PBoolean = nil): TByteDynArray;
  var total     : integer;
  var index     : integer;
//var srcAnchor : integer;
//var destAnchor: integer;
  begin
    result:= internalReadRawFrame(src, waitForData);
    {
    srcAnchor:= 0;
    destAnchor:= 0;
    }
    index:= 0;
    total:= length(result);
    while index < total do
      begin
        if result[index] = SFP_ESCAPE_START then
          begin
            {
            move(result[srcAnchor], result[destAnchor], index - srcAnchor);
            destAnchor:= destAnchor + index - srcAnchor;
            }  
            index:= index + 1;
            if total <= index then
              raise ESFPInvalidPacket.create('Invalid packet: Terminated escape');
            if result[index] = SFP_ESCAPE_COMMAND_ECHO_FRAME_BOUND then
              begin
                result[index - 1]:= SFP_FRAME_BOUND;
                {
                destAnchor:= destAnchor + 1;
                }
              end
            else if result[index] = SFP_ESCAPE_COMMAND_ECHO_ESCAPE then
              begin
                result[index - 1]:= SFP_ESCAPE_START;
                {
                destAnchor:= destAnchor + 1;
                }
              end
            else
              raise ESFPInvalidPacket.create('Invalid packet: Illegal escape echo code');
            {
            srcAnchor:= index + 1;
            }
            if 0 < (total - index - 1) then
              move(result[index + 1], result[index], total - index - 1)
            else
              break;

            total:= total - 1;
          end
        else if result[index] = SFP_FRAME_BOUND then
          raise ESFPInvalidPacket.create('Invalid packet: Internal error: not filtered BND.')
        else
          index:= index + 1;
      end;
    {
    if srcAnchor < index then
      begin
        move(result[srcAnchor], result[destAnchor], index - srcAnchor);
        destAnchor:= destAnchor + index - srcAnchor;
      end;
    }  
    setLength(result, total);
  end;



end.
