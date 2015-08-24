unit SSPHelper;

interface uses
  {$ifdef unix}
    DynLibs,
  {$else}
    Windows,
  {$endif}
  Types, SysUtils, Classes,
  SSPTypes;

const

//SIMPLE SERIALIZATION PROTOCOL
                             //
  SSP_TYPE_OBJECT     = 0; // objectType       intType COUNT (stringType FIELD_NAME valueType FIELD_VALUE)*
  SSP_TYPE_ARRAY      = 1; // arrayType        intType COUNT (                      valueType FIELD_VALUE)*
  SSP_TYPE_STRING     = 2; // stringType       intType COUNT (                                 BYTE_VALUE)*
  SSP_TYPE_DECIMAL    = 4; // decimalType      intType COUNT (                                 BYTE_VALUE)*
  SSP_TYPE_INT_8      =10; // int8Type         BYTE_VALUE
  SSP_TYPE_INT_16     =11; // int16Type        BYTE_VALUES hi-lo 2
  SSP_TYPE_INT_32     =12; // int32Type        BYTE_VALUE0 hi-lo 4
  SSP_TYPE_INT_64     =13; // int64Type        BYTE_VALUE0 hi-lo 8
  SSP_TYPE_FLOAT_32   =15; // floatSingleType  BYTE_VALUE0 hi-lo 4
  SSP_TYPE_FLOAT_64   =16; // floatDoubleType  BYTE_VALUE0 hi-lo 8
  SSP_TYPE_BYTE_ARRAY =20; // byteArrayType    intType COUNT (                                 BYTE_VALUE)*

type

  ESSPInvalidData = class(Exception)
  end;

  TSSPHelper = class
  public
    class function  getTypeOf(value: int64 ): shortint; overload;
    class function  getTypeOf(value: double): shortint; overload;

    class procedure writeType         (dest: TStream; value: shortint  );

    class procedure writeByteArray(dest: TStream; size: integer; buffer: pointer); overload;
    class procedure writeByteArray(dest: TStream; const buffer: TByteArray); overload;

    class procedure writeObject(dest: TStream; fieldCount: integer   );
    class procedure writeField (dest: TStream; fieldName : WideString);
    class procedure writeArray (dest: TStream; itemCount : integer   );

    class procedure writeUTF8String   (dest: TStream; value: AnsiString);
    class procedure writeString       (dest: TStream; value: WideString);
    class procedure writeInt          (dest: TStream; value: int64     );
    class procedure writeInt8         (dest: TStream; value: shortint  );
    class procedure writeInt16        (dest: TStream; value: smallint  );
    class procedure writeInt32        (dest: TStream; value: longint   );
    class procedure writeInt64        (dest: TStream; value: int64     );
    class procedure writeFloat        (dest: TStream; value: double    );
    class procedure writeFloat32      (dest: TStream; value: single    );
    class procedure writeFloat64      (dest: TStream; value: double    );
    class procedure writeDecimalString(dest: TStream; value: AnsiString);

    class function checkType       (actual, required: shortint): shortint;

    class function readType         (src: TStream): shortint;

    class function readByteArrayData    (src: TStream; type_: shortint): TByteDynArray;
    class function readUTF8StringData   (src: TStream; type_: shortint): AnsiString   ;
    class function readStringData       (src: TStream; type_: shortint): WideString   ;
    class function readIntData          (src: TStream; type_: shortint): int64        ;
    class function readInt8Data         (src: TStream; type_: shortint): shortint     ;
    class function readInt16Data        (src: TStream; type_: shortint): smallint     ;
    class function readInt32Data        (src: TStream; type_: shortint): longint      ;
    class function readInt64Data        (src: TStream; type_: shortint): int64        ;
    class function readFloatData        (src: TStream; type_: shortint): double       ;
    class function readFloat32Data      (src: TStream; type_: shortint): single       ;
    class function readFloat64Data      (src: TStream; type_: shortint): double       ;
    class function readDecimalStringData(src: TStream; type_: shortint): AnsiString   ;

    class function readAnyData          (src: TStream; type_: shortint): ISSPAny      ;
    class function readObjectData       (src: TStream; type_: shortint): ISSPAny   ;
    class function readArrayData        (src: TStream; type_: shortint): ISSPAny   ;

    class function readByteArray    (src: TStream): TByteDynArray;
    class function readUTF8String   (src: TStream): AnsiString   ;
    class function readString       (src: TStream): WideString   ;
    class function readInt          (src: TStream): int64        ;
    class function readInt8         (src: TStream): shortint     ;
    class function readInt16        (src: TStream): smallint     ;
    class function readInt32        (src: TStream): longint      ;
    class function readInt64        (src: TStream): int64        ;
    class function readFloat        (src: TStream): double       ;
    class function readFloat32      (src: TStream): single       ;
    class function readFloat64      (src: TStream): double       ;
    class function readDecimalString(src: TStream): AnsiString   ;

    class function readAny          (src: TStream): ISSPAny      ;
    class function readObject       (src: TStream): ISSPAny      ;
    class function readArray        (src: TStream): ISSPAny      ;
  end;
{
  TSSPWriter = class
  protected
    _origin: TStream;
    _owned : boolean;
  public
    constructor create(origin: TStream; owned: boolean);
    destructor destroy; override;

    procedure beginObject(fieldCount: integer);
    procedure endObject();

    procedure beginField(fieldName: WideString);
    procedure endField();

    procedure beginArray(itemCount: integer);
    procedure endArray();

    procedure writeByteArray(size: integer; buffer: pointer);

    procedure writeObject(fieldCount: integer   );
    procedure writeField (fieldName : WideString);
    procedure writeArray (itemCount : integer   );

    procedure writeUTF8String   (value: AnsiString);
    procedure writeString       (value: WideString);
    procedure writeInt          (value: int64     );
    procedure writeInt8         (value: shortint  );
    procedure writeInt16        (value: smallint  );
    procedure writeInt32        (value: longint   );
    procedure writeInt64        (value: int64     );
    procedure writeFloat        (value: double    );
    procedure writeSingle       (value: single    );
    procedure writeDouble       (value: double    );
    procedure writeDecimal      (value: double    );
    procedure writeDecimalString(value: AnsiString);
  end;

  TSSPReader = class
  protected
    _origin: TStream;
    _owned : boolean;
  public
    constructor create(origin: TStream; owned: boolean);
    destructor destroy; override;

    function readType         (): shortint  ;
    function readUTF8String   (): AnsiString;
    function readString       (): WideString;
    function readInt          (): int64     ;
    function readInt8         (): shortint  ;
    function readInt16        (): smallint  ;
    function readInt32        (): longint   ;
    function readInt64        (): int64     ;
    function readFloat        (): double    ;
    function readSingle       (): single    ;
    function readDouble       (): double    ;
    function readDecimal      (): double    ;
    function readDecimalString(): AnsiString;

    function readAny          (): ISSPAny;
  end;
}

function getNormalFormatSettings(): TFormatSettings;

function normalFloatToStr   (const format: String; value: extended): String;
function normalStrToFloat   (const value: String): extended;
function normalStrToFloatDef(const value: String; defaultValue: extended): extended;

implementation uses Math,
  SFPHelper;

type
  TByteArray2 = packed array[0..(2-1)] of byte;
  TByteArray4 = packed array[0..(4-1)] of byte;
  TByteArray8 = packed array[0..(8-1)] of byte;

class function  TSSPHelper.getTypeOf(value: int64): shortint;
  begin
         if value <  low (longint ) then result:= SSP_TYPE_INT_64
    else if value <  low (smallint) then result:= SSP_TYPE_INT_32
    else if value <  low (shortint) then result:= SSP_TYPE_INT_16
    else if value <= high(shortint) then result:= SSP_TYPE_INT_8
    else if value <= high(smallint) then result:= SSP_TYPE_INT_16
    else if value <= high(longint ) then result:= SSP_TYPE_INT_32
    else                                 result:= SSP_TYPE_INT_64;
  end;

class function  TSSPHelper.getTypeOf(value: double): shortint;
  var tempSingle: single;
  begin
    tempSingle:= value;
    if isNAN(tempSingle) or (tempSingle = value) then
      result:= SSP_TYPE_FLOAT_32 else
      result:= SSP_TYPE_FLOAT_64;
  end;

class procedure TSSPHelper.writeType         (dest: TStream; value: shortint  );
  begin
    TSFPHelper.internalWrite(dest, 1, @value);
  end;

class procedure TSSPHelper.writeByteArray(dest: TStream; size: integer; buffer: pointer);
  begin
    TSSPHelper.writeType    (dest, SSP_TYPE_BYTE_ARRAY);
    TSSPHelper.writeInt     (dest, size);
    TSFPHelper.internalWrite(dest, size, buffer);
  end;

class procedure TSSPHelper.writeByteArray(dest: TStream; const buffer: TByteArray);
  begin
    TSSPHelper.writeType    (dest, SSP_TYPE_BYTE_ARRAY);
    TSSPHelper.writeInt     (dest, length(buffer));
    if 0 < length(buffer) then
      TSFPHelper.internalWrite(dest, length(buffer), @buffer[0]);
  end;

class procedure TSSPHelper.writeObject(dest: TStream; fieldCount: integer   );
  begin
    TSSPHelper.writeType(dest, SSP_TYPE_OBJECT);
    TSSPHelper.writeInt(dest, fieldCount);
  end;

class procedure TSSPHelper.writeField (dest: TStream; fieldName : WideString);
  begin
    TSSPHelper.writeString(dest, fieldName);
  end;

class procedure TSSPHelper.writeArray (dest: TStream; itemCount : integer   );
  begin
    TSSPHelper.writeType(dest, SSP_TYPE_ARRAY);
    TSSPHelper.writeInt(dest, itemCount);
  end;

class procedure TSSPHelper.writeUTF8String   (dest: TStream; value: AnsiString);
  begin
    TSSPHelper.writeType(dest, SSP_TYPE_STRING);
    TSSPHelper.writeInt     (dest, length(value));
    TSFPHelper.internalWrite(dest, length(value), pansichar(value));
  end;

class procedure TSSPHelper.writeString       (dest: TStream; value: WideString);
  begin
    writeUTF8String(dest, utf8encode(value));
  end;

class procedure TSSPHelper.writeInt          (dest: TStream; value: int64     );
  var type_: shortint;
  begin
    type_:= getTypeOf(value);
    case type_ of
      SSP_TYPE_INT_8 : writeInt8 (dest, value);
      SSP_TYPE_INT_16: writeInt16(dest, value);
      SSP_TYPE_INT_32: writeInt32(dest, value);
    else               writeInt64(dest, value);
    end;
  end;

{
function reverse32(value: integer): integer; overload;
  begin
    result:= swap(value) shl (8 * 2) or (swap(value shr (8 * 2)) and $FFFF);
  end;

function reverse64(value: int64): int64; overload;
  begin
    result:= int64(reverse32(integer(value))) shl (8 * 4) or (reverse32(integer(value shr (8 * 4))) and $FFFFFFFF);
  end;


class procedure TSSPHelper.writeInt8         (dest: TStream; value: shortint  ); begin                           writeType(dest, SSP_TYPE_INT_8 ); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
class procedure TSSPHelper.writeInt16        (dest: TStream; value: smallint  ); begin value:=      swap(value); writeType(dest, SSP_TYPE_INT_16); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
class procedure TSSPHelper.writeInt32        (dest: TStream; value: longint   ); begin value:= reverse32(value); writeType(dest, SSP_TYPE_INT_32); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
class procedure TSSPHelper.writeInt64        (dest: TStream; value: int64     ); begin value:= reverse64(value); writeType(dest, SSP_TYPE_INT_64); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
}

function storeInt16(value: smallint): TByteArray2;
  begin
    result[1]:= value and $ff; value:= value shr 8;
    result[0]:= value and $ff;
  end;

function storeInt32(value: longint ): TByteArray4;
  begin
    result[3]:= value and $ff; value:= value shr 8;
    result[2]:= value and $ff; value:= value shr 8;
    result[1]:= value and $ff; value:= value shr 8;
    result[0]:= value and $ff;
  end;

function storeInt64(value: int64   ): TByteArray8;
  begin
    result[7]:= value and $ff; value:= value shr 8;
    result[6]:= value and $ff; value:= value shr 8;
    result[5]:= value and $ff; value:= value shr 8;
    result[4]:= value and $ff; value:= value shr 8;
    result[3]:= value and $ff; value:= value shr 8;
    result[2]:= value and $ff; value:= value shr 8;
    result[1]:= value and $ff; value:= value shr 8;
    result[0]:= value and $ff;
  end;

function loadInt16(value: TByteArray2): smallint;
  begin
    result:= ((0
      or (value[0] and $ff)) shl 8)
      or (value[1] and $ff);
  end;

function loadInt32(value: TByteArray4): longint ;
  begin
    result:= (longint( (longint( (longint(0
      or (value[0] and $ff)) shl 8)
      or (value[1] and $ff)) shl 8)
      or (value[2] and $ff)) shl 8)
      or (value[3] and $ff);
  end;

function loadInt64(value: TByteArray8): int64   ;
  begin
    result:= (( (( (( (( (( (( ((0
      or (value[0] and $ff)) shl 8)
      or (value[1] and $ff)) shl 8)
      or (value[2] and $ff)) shl 8)
      or (value[3] and $ff)) shl 8)
      or (value[4] and $ff)) shl 8)
      or (value[5] and $ff)) shl 8)
      or (value[6] and $ff)) shl 8)
      or (value[7] and $ff);
  end;

class procedure TSSPHelper.writeInt8         (dest: TStream; value: shortint  );
  begin
    writeType(dest, SSP_TYPE_INT_8 );
    TSFPHelper.internalWrite(dest, sizeof(value), @value);
  end;

class procedure TSSPHelper.writeInt16        (dest: TStream; value: smallint  );
  var temp: TByteArray2;
  begin
    temp:= storeInt16(value);
    writeType(dest, SSP_TYPE_INT_16);
    TSFPHelper.internalWrite(dest, sizeof(temp), @temp[0]);
  end;

class procedure TSSPHelper.writeInt32        (dest: TStream; value: longint   );
  var temp: TByteArray4;
  begin
    temp:= storeInt32(value);
    writeType(dest, SSP_TYPE_INT_32);
    TSFPHelper.internalWrite(dest, sizeof(temp), @temp[0]);
  end;

class procedure TSSPHelper.writeInt64        (dest: TStream; value: int64     );
  var temp: TByteArray8;
  begin
    temp:= storeInt64(value);
    writeType(dest, SSP_TYPE_INT_64);
    TSFPHelper.internalWrite(dest, sizeof(temp), @temp[0]);
  end;

class procedure TSSPHelper.writeFloat        (dest: TStream; value: double    );
  var type_: shortint;
  begin
    type_:= getTypeOf(value);
    if type_ = SSP_TYPE_FLOAT_32 then
      writeFloat32(dest, value) else
      writeFloat64(dest, value);
  end;
{
class procedure TSSPHelper.writeFloat32      (dest: TStream; value: single    ); begin pinteger(@value)^:= reverse(pinteger(@value)^); writeType(dest, SSP_TYPE_FLOAT_32); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
class procedure TSSPHelper.writeFloat64      (dest: TStream; value: double    ); begin pint64  (@value)^:= reverse(pint64  (@value)^); writeType(dest, SSP_TYPE_FLOAT_64); TSFPHelper.internalWrite(dest, sizeof(value), @value); end;
}
class procedure TSSPHelper.writeFloat32      (dest: TStream; value: single    );
  var temp: TByteArray4;
  begin
    temp:= storeInt32(plongint(@value)^);
    writeType(dest, SSP_TYPE_FLOAT_32);
    TSFPHelper.internalWrite(dest, sizeof(temp), @temp[0]);
  end;

class procedure TSSPHelper.writeFloat64      (dest: TStream; value: double    );
  var temp: TByteArray8;
  begin
    temp:= storeInt64(pint64(@value)^);
    writeType(dest, SSP_TYPE_FLOAT_64);
    TSFPHelper.internalWrite(dest, sizeof(temp), @temp[0]);
  end;

class procedure TSSPHelper.writeDecimalString(dest: TStream; value: AnsiString);
  begin
    TSSPHelper.writeType    (dest, SSP_TYPE_DECIMAL);
    TSSPHelper.writeInt     (dest, length(value));
    TSFPHelper.internalWrite(dest, length(value), pansichar(value));
  end;

class function TSSPHelper.checkType(actual, required: shortint): shortint;
  begin
    result:= actual;
    if actual <> required then
      raise ESSPInvalidData.create('Illegal type: ' + intToStr(actual) + '. Required type: ' + intToStr(required) + '.');
  end;

class function TSSPHelper.readType(src: TStream): shortint  ;
  var temp: byte;
  begin
    TSFPHelper.internalRead(src, 1, @temp);
    result:= word(temp);
  end;

class function TSSPHelper.readByteArrayData    (src: TStream; type_: shortint): TByteDynArray;
  begin
    checkType(type_, SSP_TYPE_BYTE_ARRAY);
    setLength(result, readInt(src));
    if 0 < length(result) then
      TSFPHelper.internalRead(src, length(result), @result[0]);
  end;

class function TSSPHelper.readUTF8StringData   (src: TStream; type_: shortint): AnsiString;
  begin
    checkType(type_, SSP_TYPE_STRING);
    setLength(result, readInt(src));
    TSFPHelper.internalRead(src, length(result), pansichar(result));
  end;

class function TSSPHelper.readStringData       (src: TStream; type_: shortint): WideString;
  begin
    result:= utf8decode(readUTF8StringData(src, type_));
  end;

class function TSSPHelper.readIntData          (src: TStream; type_: shortint): int64     ;
  begin
    case type_ of
      SSP_TYPE_INT_8 : result:= readInt8Data (src, type_);
      SSP_TYPE_INT_16: result:= readInt16Data(src, type_);
      SSP_TYPE_INT_32: result:= readInt32Data(src, type_);
      SSP_TYPE_INT_64: result:= readInt64Data(src, type_);
    else
      raise ESSPInvalidData.create('Illegal type: ' + intToStr(type_) + '. Required types: ('
        + intToStr(SSP_TYPE_INT_8 ) + ','
        + intToStr(SSP_TYPE_INT_16) + ','
        + intToStr(SSP_TYPE_INT_32) + ','
        + intToStr(SSP_TYPE_INT_64) + ').'
        );
    end;
  end;

class function TSSPHelper.readInt8Data         (src: TStream; type_: shortint): shortint  ;
  begin
    checkType(type_, SSP_TYPE_INT_8 );
    TSFPHelper.internalRead(src, sizeof(result), @result);
  end;

class function TSSPHelper.readInt16Data        (src: TStream; type_: shortint): smallint  ;
  var temp: TByteArray2;
  begin
    checkType(type_, SSP_TYPE_INT_16);
    TSFPHelper.internalRead(src, sizeof(temp), @temp[0]);
    result:= loadInt16(temp);
  end;

class function TSSPHelper.readInt32Data        (src: TStream; type_: shortint): longint   ;
  var temp: TByteArray4;
  begin
    checkType(type_, SSP_TYPE_INT_32);
    TSFPHelper.internalRead(src, sizeof(temp), @temp[0]);
    result:= loadInt32(temp);
  end;

class function TSSPHelper.readInt64Data        (src: TStream; type_: shortint): int64     ;
  var temp: TByteArray8;
  begin
    checkType(type_, SSP_TYPE_INT_64);
    TSFPHelper.internalRead(src, sizeof(temp), @temp[0]);
    result:= loadInt64(temp);
  end;

{
class function TSSPHelper.readInt8Data         (src: TStream; type_: shortint): shortint  ;
  begin
    checkType(type_, SSP_TYPE_INT_8 );
    TSFPHelper.internalRead(src, sizeof(result), @result);
  end;

class function TSSPHelper.readInt16Data        (src: TStream; type_: shortint): smallint  ;
  var temp: TByteArray2;
  begin
    checkType(type_, SSP_TYPE_INT_16);
    TSFPHelper.internalRead(src, sizeof(result), @result); result:= swap(result);
  end;

class function TSSPHelper.readInt32Data        (src: TStream; type_: shortint): longint   ;
  var temp: TByteArray4;
  begin
    checkType(type_, SSP_TYPE_INT_32);
    TSFPHelper.internalRead(src, sizeof(result), @result); result:= reverse32(result);
  end;

class function TSSPHelper.readInt64Data        (src: TStream; type_: shortint): int64     ;
  var temp: TByteArray8;
  begin
    checkType(type_, SSP_TYPE_INT_64); TSFPHelper.internalRead(src, sizeof(result), @result); result:= reverse64(result);
  end;
}

class function TSSPHelper.readFloatData        (src: TStream; type_: shortint): double    ;
  begin
    case type_ of
      SSP_TYPE_FLOAT_32: result:= readFloat32Data(src, type_);
      SSP_TYPE_FLOAT_64: result:= readFloat64Data(src, type_);
    else
      raise ESSPInvalidData.create('Illegal type: ' + intToStr(type_) + '. Required types: ('
        + intToStr(SSP_TYPE_FLOAT_32) + ','
        + intToStr(SSP_TYPE_FLOAT_64) + ').'
        );
    end;
  end;

class function TSSPHelper.readFloat32Data      (src: TStream; type_: shortint): single    ;
  begin
    checkType(type_, SSP_TYPE_FLOAT_32); pinteger(@result)^:= readInt32Data(src, SSP_TYPE_INT_32);
  end;

class function TSSPHelper.readFloat64Data      (src: TStream; type_: shortint): double    ;
  begin
    checkType(type_, SSP_TYPE_FLOAT_64); pint64  (@result)^:= readInt64Data(src, SSP_TYPE_INT_64);
  end;

class function TSSPHelper.readDecimalStringData(src: TStream; type_: shortint): AnsiString;
  begin
    checkType(type_, SSP_TYPE_DECIMAL);
    setLength(result, readInt(src));
    TSFPHelper.internalRead(src, length(result), pansichar(result));
  end;

class function TSSPHelper.readAnyData          (src: TStream; type_: shortint): ISSPAny   ;
  begin
    case type_ of
      SSP_TYPE_OBJECT    : result:=                             readObjectData       (src, type_) ;
      SSP_TYPE_ARRAY     : result:=                             readArrayData        (src, type_) ;
      SSP_TYPE_STRING    : result:= TSSPString   .create(       readStringData       (src, type_));
      SSP_TYPE_BYTE_ARRAY: result:= TSSPByteArray.create(       readByteArrayData    (src, type_));
      SSP_TYPE_DECIMAL   : result:= TSSPDecimal  .create(       readDecimalStringData(src, type_));
      SSP_TYPE_INT_8     : result:= TSSPInt      .create(type_, readInt8Data         (src, type_));
      SSP_TYPE_INT_16    : result:= TSSPInt      .create(type_, readInt16Data        (src, type_));
      SSP_TYPE_INT_32    : result:= TSSPInt      .create(type_, readInt32Data        (src, type_));
      SSP_TYPE_INT_64    : result:= TSSPInt      .create(type_, readInt64Data        (src, type_));
      SSP_TYPE_FLOAT_32  : result:= TSSPFloat    .create(type_, readFloat32Data      (src, type_));
      SSP_TYPE_FLOAT_64  : result:= TSSPFloat    .create(type_, readFloat64Data      (src, type_));
    else
      raise ESSPInvalidData.create('Illegal type: ' + intToStr(type_) + '.');
    end;
  end;

class function TSSPHelper.readObjectData       (src: TStream; type_: shortint): ISSPAny   ;
  var size: integer;
  var i: integer;
  var name: WideString;
  begin
    checkType(type_, SSP_TYPE_OBJECT);
    size:= readInt(src);
    result:= TSSPObject.create();
    for i:= 0 to size - 1 do
      begin
        name:= readString(src);
        result.add(name, readAny(src));
      end;
  end;

class function TSSPHelper.readArrayData        (src: TStream; type_: shortint): ISSPAny   ;
  var size: integer;
  var list: IInterfaceList;
  var i: integer;
  begin
    checkType(type_, SSP_TYPE_ARRAY);
    size:= readInt(src);
    list:= TInterfaceList.create();
    list.capacity:= size;
    for i:= 0 to size - 1 do
      list.add(readAny(src));
    result:= TSSPArray.create(list);
  end;



class function TSSPHelper.readByteArray    (src: TStream): TByteDynArray;
                                                                          begin result:= readByteArrayData    (src, readType(src)); end;
class function TSSPHelper.readUTF8String   (src: TStream): AnsiString   ;
                                                                          begin result:= readUTF8StringData   (src, readType(src)); end;
class function TSSPHelper.readString       (src: TStream): WideString   ;
                                                                          begin result:= readStringData       (src, readType(src)); end;
class function TSSPHelper.readInt          (src: TStream): int64        ;
                                                                          begin result:= readIntData          (src, readType(src)); end;
class function TSSPHelper.readInt8         (src: TStream): shortint     ;
                                                                          begin result:= readInt8Data         (src, readType(src)); end;
class function TSSPHelper.readInt16        (src: TStream): smallint     ;
                                                                          begin result:= readInt16Data        (src, readType(src)); end;
class function TSSPHelper.readInt32        (src: TStream): integer      ;
                                                                          begin result:= readInt32Data        (src, readType(src)); end;
class function TSSPHelper.readInt64        (src: TStream): int64        ;
                                                                          begin result:= readInt64Data        (src, readType(src)); end;
class function TSSPHelper.readFloat        (src: TStream): double       ;
                                                                          begin result:= readFloatData        (src, readType(src)); end;
class function TSSPHelper.readFloat32      (src: TStream): single       ;
                                                                          begin result:= readFloat32Data      (src, readType(src)); end;
class function TSSPHelper.readFloat64      (src: TStream): double       ;
                                                                          begin result:= readFloat64Data      (src, readType(src)); end;
class function TSSPHelper.readDecimalString(src: TStream): AnsiString   ;
                                                                          begin result:= readDecimalStringData(src, readType(src)); end;
class function TSSPHelper.readAny          (src: TStream): ISSPAny      ;
                                                                          begin result:= readAnyData          (src, readType(src)); end;
class function TSSPHelper.readObject       (src: TStream): ISSPAny      ;
                                                                          begin result:= readObjectData       (src, readType(src)); end;
class function TSSPHelper.readArray        (src: TStream): ISSPAny      ;
                                                                          begin result:= readArrayData        (src, readType(src)); end;

{
  TSSPWriter = class
  protected
    _origin: TStream;
    _owned : boolean;
  public
    constructor create(origin: TStream; owned: boolean);
    destructor destroy; override;

    procedure beginObject(fieldCount: integer);
    procedure endObject();

    procedure beginField(fieldName: WideString);
    procedure endField();

    procedure beginArray(itemCount: integer);
    procedure endArray();

    procedure writeByteArray(size: integer; buffer: pointer);

    procedure writeObject(fieldCount: integer   );
    procedure writeField (fieldName : WideString);
    procedure writeArray (itemCount : integer   );

    procedure writeUTF8String   (value: AnsiString);
    procedure writeString       (value: WideString);
    procedure writeInt          (value: int64     );
    procedure writeInt8         (value: shortint  );
    procedure writeInt16        (value: smallint  );
    procedure writeInt32        (value: integer   );
    procedure writeInt64        (value: int64     );
    procedure writeFloat        (value: double    );
    procedure writeSingle       (value: single    );
    procedure writeDouble       (value: double    );
    procedure writeDecimal      (value: double    );
    procedure writeDecimalString(value: AnsiString);
  end;

  TSSPReader = class
  protected
    _origin: TStream;
    _owned : boolean;
  public
    constructor create(origin: TStream; owned: boolean);
    destructor destroy; override;

    function readType         (): shortint  ;
    function readUTF8String   (): AnsiString;
    function readString       (): WideString;
    function readInt          (): int64     ;
    function readInt8         (): shortint  ;
    function readInt16        (): smallint  ;
    function readInt32        (): integer   ;
    function readInt64        (): int64     ;
    function readFloat        (): double    ;
    function readSingle       (): single    ;
    function readDouble       (): double    ;
    function readDecimal      (): double    ;
    function readDecimalString(): AnsiString;

    function readAny          (): ISSPAny;
  end;
}

function normalStrToFloat(const value: String): extended;
  begin
    result:= strToFloat(value, getNormalFormatSettings());
  end;

function normalFloatToStr   (const format: String; value: extended): String;
  begin
    result:= formatFloat(format, value, getNormalFormatSettings());
  end;

function normalStrToFloatDef(const value: String; defaultValue: extended): extended;
  begin
    result:= strToFloatDef(value, defaultValue, getNormalFormatSettings());
  end;

var __normalFormatSettings: TFormatSettings;

function getNormalFormatSettings(): TFormatSettings;
                                                     begin result:= __normalFormatSettings; end;

initialization
  {$ifdef unix}
    __normalFormatSettings:= defaultFormatSettings;
  {$else}
    getLocaleFormatSettings(LOCALE_USER_DEFAULT, __normalFormatSettings);
  {$endif}
  __normalFormatSettings.DecimalSeparator := '.';
  __normalFormatSettings.ThousandSeparator:= #0;
  __normalFormatSettings.DateSeparator:= '-';
  __normalFormatSettings.TimeSeparator:= ':';
  __normalFormatSettings.LongDateFormat:= 'yyyy-mm-dd';
  __normalFormatSettings.ShortDateFormat:= 'yyyy-mm-dd';
  __normalFormatSettings.LongTimeFormat:= 'hh:nn:ss.zzz';

end.