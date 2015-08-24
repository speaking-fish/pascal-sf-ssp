unit SSPTypes;

interface uses SysUtils, Types, Classes;

type
  ISSPAny = interface ['{E2D2281E-4B43-49D3-A059-02382B614F9B}']
    function getType        (): shortint     ;
    function toString       (): WideString   ;
    function asUTF8String   (): AnsiString   ;
    function asString       (): WideString   ;
    function asInt          (): int64        ;
    function asInt8         (): shortint     ;
    function asInt16        (): smallint     ;
    function asInt32        (): longint      ;
    function asInt64        (): int64        ;
    function asFloat        (): double       ;
    function asFloat32      (): single       ;
    function asFloat64      (): double       ;
    function asDecimal      (): double       ;
    function asDecimalString(): AnsiString   ;

    function asByteArray    (): TByteDynArray;

    function size           (): integer      ;

    function insert (     index: integer   ; value: ISSPAny): integer   ; overload;
    function add    (                        value: ISSPAny): integer   ; overload;
    function add    (const name: WideString; value: ISSPAny): integer   ; overload;
    function update (     index: integer   ; value: ISSPAny): ISSPAny   ; overload;
    function update (const name: WideString; value: ISSPAny): ISSPAny   ; overload;
    function remove (     index: integer                   ): ISSPAny   ; overload;
    function remove (const name: WideString                ): ISSPAny   ; overload;
    function indexOf(const name: WideString                ): integer   ; overload;
    function nameOf (     index: integer                   ): WideString; overload;
    function item   (     index: integer                   ): ISSPAny   ; overload;
    function item   (const name: WideString                ): ISSPAny   ; overload;

    procedure writeTo(dest: TStream); overload;
    function equals (obj: IInterface): boolean; overload;
  end;

  ISSPAnyEntry = interface ['{1D0F32BD-2E60-4C2E-8534-65786547799E}']
    function key  (): WideString;
    function value(): ISSPAny   ;
  end;

  TSSPAbstractAny = class(TInterfacedObject, ISSPAny)
  protected
    function newAbstractError(): EAbstractError;
  public
    function getType        (): shortint     ; virtual; //abstract;
    function toString       (): WideString   ; virtual; //abstract;
    function asUTF8String   (): AnsiString   ; virtual; //abstract;
    function asString       (): WideString   ; virtual; //abstract;
    function asInt          (): int64        ; virtual; //abstract;
    function asInt8         (): shortint     ; virtual; //abstract;
    function asInt16        (): smallint     ; virtual; //abstract;
    function asInt32        (): longint      ; virtual; //abstract;
    function asInt64        (): int64        ; virtual; //abstract;
    function asFloat        (): double       ; virtual; //abstract;
    function asFloat32      (): single       ; virtual; //abstract;
    function asFloat64      (): double       ; virtual; //abstract;
    function asDecimal      (): double       ; virtual; //abstract;
    function asDecimalString(): AnsiString   ; virtual; //abstract;

    function asByteArray    (): TByteDynArray; virtual; //abstract;

    function size           (): integer      ; virtual; //abstract;

    function insert (     index: integer   ; value: ISSPAny): integer   ; overload; virtual; //abstract;
    function add    (                        value: ISSPAny): integer   ; overload; virtual; //abstract;
    function add    (const name: WideString; value: ISSPAny): integer   ; overload; virtual; //abstract;
    function update (     index: integer   ; value: ISSPAny): ISSPAny   ; overload; virtual; //abstract;
    function update (const name: WideString; value: ISSPAny): ISSPAny   ; overload; virtual; //abstract;
    function remove (     index: integer                   ): ISSPAny   ; overload; virtual; //abstract;
    function remove (const name: WideString                ): ISSPAny   ; overload; virtual; //abstract;
    function indexOf(const name: WideString                ): integer   ; overload; virtual; //abstract;
    function nameOf (     index: integer                   ): WideString; overload; virtual; //abstract;
    function item   (     index: integer                   ): ISSPAny   ; overload; virtual; //abstract;
    function item   (const name: WideString                ): ISSPAny   ; overload; virtual; //abstract;

    procedure writeTo(dest: TStream); overload; virtual; //abstract;
    function equals (obj: IInterface): boolean; overload; virtual; //abstract;
  end;

  TSSPString = class(TSSPAbstractAny)
  protected
    _value: WideString;
  public
    constructor create(const value: WideString);
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function asUTF8String   (): AnsiString   ; override;
    function asString       (): WideString   ; override;
    function size           (): integer      ; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPInt = class(TSSPAbstractAny)
  protected
    _type : shortint;
    _value: int64   ;
  public
    constructor create(value: int64); overload;
    constructor create(type_: shortint; value: int64); overload;
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function asInt          (): int64        ; override;
    function asInt8         (): shortint     ; override;
    function asInt16        (): smallint     ; override;
    function asInt32        (): longint      ; override;
    function asInt64        (): int64        ; override;
    function asString       (): WideString   ; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPFloat = class(TSSPAbstractAny)
  protected
    _type : shortint;
    _value: double  ;
  public
    constructor create(value: double); overload;
    constructor create(type_: shortint; value: double); overload;
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function asFloat        (): double       ; override;
    function asFloat32      (): single       ; override;
    function asFloat64      (): double       ; override;
    function asString       (): WideString   ; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPDecimal = class(TSSPAbstractAny)
  protected
    _value: AnsiString;
  public
    constructor create(const value: AnsiString);
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function asDecimal      (): double       ; override;
    function asDecimalString(): AnsiString   ; override;
    function asString       (): WideString   ; override;
    function asUTF8String   (): AnsiString   ; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPByteArray = class(TSSPAbstractAny)
  protected
    _value: TByteDynArray;
  public
    constructor create(const value: TByteDynArray);
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function asByteArray    (): TByteDynArray; override;
    function asUTF8String   (): AnsiString   ; override;
    function size           (): integer      ; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPArray = class(TSSPAbstractAny)
  protected
    _value: IInterfaceList;
  public
    constructor create(); overload;
    constructor create(const value: IInterfaceList); overload;
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function size           (): integer      ; override;

    function insert (     index: integer   ; value: ISSPAny): integer   ; overload; override;
    function add    (                        value: ISSPAny): integer   ; overload; override;
    function update (     index: integer   ; value: ISSPAny): ISSPAny   ; overload; override;
    function remove (     index: integer                   ): ISSPAny   ; overload; override;
    function item   (     index: integer                   ): ISSPAny   ; overload; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPObject = class(TSSPAbstractAny)
  protected
    _names : TStrings;
    _values: IInterfaceList     ;
  public
    constructor create();
    destructor destroy; override;
    function getType        (): shortint     ; override;
    function toString       (): WideString   ; override;
    function size           (): integer      ; override;

    function add    (const name: WideString; value: ISSPAny): integer   ; overload; override;
    function update (     index: integer   ; value: ISSPAny): ISSPAny   ; overload; override;
    function update (const name: WideString; value: ISSPAny): ISSPAny   ; overload; override;
    function remove (     index: integer                   ): ISSPAny   ; overload; override;
    function remove (const name: WideString                ): ISSPAny   ; overload; override;
    function indexOf(const name: WideString                ): integer   ; overload; override;
    function nameOf (     index: integer                   ): WideString; overload; override;
    function item   (     index: integer                   ): ISSPAny   ; overload; override;
    function item   (const name: WideString                ): ISSPAny   ; overload; override;

    procedure writeTo(dest: TStream); override;
    function equals (obj: IInterface): boolean; overload; override;
  end;

  TSSPAnyEntry = class(TInterfacedObject, ISSPAnyEntry)
  protected
    _key  : WideString;
    _value: ISSPAny   ;
  public
    constructor create(const key_: WideString; value_: ISSPAny);
    function key  (): WideString;
    function value(): ISSPAny   ;
  end;

function newInt      (      value: int64        ): ISSPAny;
function newFloat    (      value: double       ): ISSPAny;
function newString   (const value: WideString   ): ISSPAny;
function newDecimal  (const value: AnsiString   ): ISSPAny;
function newByteArray(const value: TByteDynArray): ISSPAny;

function newEntry    (const key  : WideString   ;
                      const value: ISSPAny      ): ISSPAnyEntry;

function newArray    (const values: array of ISSPAny     ): ISSPAny;
function newObject   (const values: array of ISSPAnyEntry): ISSPAny;

implementation uses SSPHelper;

function newAbstractError(): EAbstractError;
  begin
    result:= EAbstractError.create('Unsupported function');
  end;

function TSSPAbstractAny.newAbstractError(): EAbstractError;
  begin
    result:= EAbstractError.create('Unsupported function in class: ' + className);
  end;

function TSSPAbstractAny.getType        (): shortint     ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.toString       (): WideString   ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asUTF8String   (): AnsiString   ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asString       (): WideString   ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asInt          (): int64        ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asInt8         (): shortint     ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asInt16        (): smallint     ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asInt32        (): longint      ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asInt64        (): int64        ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asFloat        (): double       ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asFloat32      (): single       ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asFloat64      (): double       ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asDecimal      (): double       ;
                                                           begin raise newAbstractError(); end;
function TSSPAbstractAny.asDecimalString(): AnsiString   ;
                                                           begin raise newAbstractError(); end;

function TSSPAbstractAny.asByteArray    (): TByteDynArray; begin raise newAbstractError(); end;

function TSSPAbstractAny.size           (): integer      ; begin raise newAbstractError(); end;

function TSSPAbstractAny.insert (     index: integer   ; value: ISSPAny): integer   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.add    (                        value: ISSPAny): integer   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.add    (const name: WideString; value: ISSPAny): integer   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.update (     index: integer   ; value: ISSPAny): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.update (const name: WideString; value: ISSPAny): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.remove (     index: integer                   ): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.remove (const name: WideString                ): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.indexOf(const name: WideString                ): integer   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.nameOf (     index: integer                   ): WideString;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.item   (     index: integer                   ): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.item   (const name: WideString                ): ISSPAny   ;
                                                                                      begin raise newAbstractError(); end;

procedure TSSPAbstractAny.writeTo(dest: TStream);
                                                                                      begin raise newAbstractError(); end;
function TSSPAbstractAny.equals (obj: IInterface): boolean;
                                                                                      begin raise newAbstractError(); end;

constructor TSSPString.create(const value: WideString);
  begin
    inherited create;
    _value:= value;
  end;

function TSSPString.toString       (): WideString   ;
                                                      begin result:= '"' + _value + '"'; end;

procedure TSSPString.writeTo(dest: TStream);
                                                      begin TSSPHelper.writeString(dest, _value); end;

function TSSPString.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if getType() <> other.getType() then
      exit;

    result:= _value = other.asString();
  end;

constructor TSSPInt.create(type_: shortint; value: int64);
  begin
    inherited create;
    _type := type_;
    _value:= value;
  end;

constructor TSSPInt.create(value: int64);
  begin
    create(TSSPHelper.getTypeOf(value), value);
  end;

procedure TSSPInt.writeTo(dest: TStream);
                                          begin TSSPHelper.writeInt(dest, _value); end;

function TSSPInt.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if not(other.getType() in [SSP_TYPE_INT_8, SSP_TYPE_INT_16, SSP_TYPE_INT_32, SSP_TYPE_INT_64] ) then
      exit;

    result:= _value = other.asInt();
  end;

constructor TSSPFloat.create(type_: shortint; value: double);
  begin
    inherited create;
    _type := type_;
    _value:= value;
  end;

constructor TSSPFloat.create(value: double);
  begin
    create(TSSPHelper.getTypeOf(value), value);
  end;

procedure TSSPFloat.writeTo(dest: TStream);
                                            begin TSSPHelper.writeFloat(dest, _value); end;

function TSSPFloat.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if not(other.getType() in [SSP_TYPE_FLOAT_32, SSP_TYPE_FLOAT_64]) then
      exit;

    result:= _value = other.asFloat();
  end;

constructor TSSPDecimal.create(const value: AnsiString);
  begin
    inherited create;
    _value:= value;
  end;

procedure TSSPDecimal.writeTo(dest: TStream);
                                              begin TSSPHelper.writeDecimalString(dest, _value); end;

function TSSPDecimal.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if getType() <> other.getType() then
      exit;

    result:= _value = other.asDecimalString();
  end;

constructor TSSPByteArray.create(const value: TByteDynArray);
  begin
    inherited create;
    _value:= value;
  end;

function TSSPByteArray.toString       (): WideString   ;
  var temp: AnsiString;
  begin
    setLength(temp, size() * 2);
    if 0 < size() then
      binToHex(pansichar(@_value[0]), pansichar(temp), size());
    result:= temp;  
    //result:= '<' + temp + '>';
  end;

procedure TSSPByteArray.writeTo(dest: TStream);
  begin
    if 0 = length(_value) then
      TSSPHelper.writeByteArray(dest, length(_value), nil) else
      TSSPHelper.writeByteArray(dest, length(_value), @(_value[0]));
  end;

function TSSPByteArray.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if getType() <> other.getType() then
      exit;

    if size() <> other.size() then
      exit;

    result:= (0 = size()) or compareMem(@_value[0], @((other.asByteArray())[0]), size());
  end;

constructor TSSPArray.create(const value: IInterfaceList);
  begin
    inherited create;
    _value:= value;
  end;

constructor TSSPArray.create();
  begin
    create(TInterfaceList.create());
  end;

function TSSPArray.toString       (): WideString   ;
  var i: integer;
  begin
    result:= '[';
    if 0 < size() then
      begin
        result:= result + item(0).toString();
        for i:= 1 to size() - 1 do
          result:= result + ', ' + item(i).toString();
      end;
    result:= result + ']';
  end;

function TSSPArray.insert (     index: integer   ; value: ISSPAny): integer   ;
  begin
    _value.insert(index, value);
    result:= index;
  end;

function TSSPArray.add    (                        value: ISSPAny): integer   ;
  begin
    result:= _value.add(value);
  end;

function TSSPArray.update (     index: integer   ; value: ISSPAny): ISSPAny   ;
  begin
    result:= _value[index] as ISSPAny;
    _value[index]:= value;
  end;

function TSSPArray.remove (     index: integer                   ): ISSPAny   ;
  begin
    result:= _value[index] as ISSPAny;
    _value.delete(index);
  end;

function TSSPArray.item   (     index: integer                   ): ISSPAny   ;
  begin
    result:= _value[index] as ISSPAny;
  end;

procedure TSSPArray.writeTo(dest: TStream);
  var i: integer;
  begin
    TSSPHelper.writeArray(dest, size());
    for i:= 0 to size() - 1 do
      item(i).writeTo(dest);
  end;

function TSSPArray.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  var i: integer;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if getType() <> other.getType() then
      exit;

    if size() <> other.size() then
      exit;

    for i:= 0 to size() - 1 do
      if not item(i).equals(other.item(i)) then
        exit;

    result:= true;
  end;


constructor TSSPObject.create();
  begin
    inherited create;
    _names := TStringList.create();
    _values:= TInterfaceList.create();
  end;

destructor TSSPObject.destroy;
  begin
    inherited;
    _names.free();
    _names:= nil;
  end;

function TSSPObject.toString       (): WideString   ;
  var i: integer;
  begin
    result:= '{';
    if 0 < size() then
      begin
        result:= result + '"' + nameOf(0) + '": ' + item(0).toString();
        for i:= 1 to size() - 1 do
          result:= result + ', "' + nameOf(i) + '": ' + item(i).toString();
      end;
    result:= result + '}';
  end;

function TSSPObject.add    (const name: WideString; value: ISSPAny): integer   ;
  var index: integer;
  begin
    index:= indexOf(name);
    if 0 <= index then
      begin
        _values[index]:= value;
        result:= index;
      end
    else
      begin
        _names.add(utf8encode(name));
        result:= _values.add(value);
      end;
  end;

function TSSPObject.update (     index: integer   ; value: ISSPAny): ISSPAny   ;
  begin
    result:= _values[index] as ISSPAny;
    _values[index]:= value;
  end;

function TSSPObject.update (const name: WideString; value: ISSPAny): ISSPAny   ;
  begin
    result:= update(indexOf(name), value);
  end;

function TSSPObject.remove (     index: integer                   ): ISSPAny   ;
  begin
    _names.delete(index);
    result:= _values[index] as ISSPAny;
    _values.delete(index);
  end;

function TSSPObject.remove (const name: WideString                ): ISSPAny   ;
  begin
    result:= remove(indexOf(name));
  end;

function TSSPObject.indexOf(const name: WideString                ): integer   ;
  begin
    result:= _names.indexOf(utf8encode(name));
  end;

function TSSPObject.nameOf (     index: integer                   ): WideString;
  begin
    result:= utf8decode(_names[index]);
  end;

function TSSPObject.item   (     index: integer                   ): ISSPAny   ;
  begin
    result:= _values[index] as ISSPAny;
  end;

function TSSPObject.item   (const name: WideString                ): ISSPAny   ;
  var index: integer;
  begin
    index:= indexOf(name);
    if index < 0 then
      result:= nil else
      result:= item(index);
  end;

procedure TSSPObject.writeTo(dest: TStream);
  var i: integer;
  begin
    TSSPHelper.writeObject(dest, size());
    for i:= 0 to size() - 1 do
      begin
        TSSPHelper.writeField(dest, nameOf(i));
        item(i).writeTo(dest);
      end;
  end;

function TSSPObject.equals (obj: IInterface): boolean;
  var other: ISSPAny;
  var i: integer;
  begin
    result:= false;

    if not assigned(obj) then
      exit;

    if not supports(obj, ISSPAny, other) then
      exit;

    if getType() <> other.getType() then
      exit;

    if size() <> other.size() then
      exit;

    for i:= 0 to size() - 1 do
      if not item(i).equals(other.item(nameOf(i))) then
        exit;

    result:= true;
  end;

function TSSPString   .getType        (): shortint     ;
                                                         begin result:= SSP_TYPE_STRING   ; end;
function TSSPString   .asUTF8String   (): AnsiString   ;
                                                         begin result:= utf8encode (_value); end;
function TSSPString   .asString       (): WideString   ;
                                                         begin result:=             _value ; end;
function TSSPString   .size           (): integer      ;
                                                         begin result:= length     (_value); end;

function TSSPInt      .getType        (): shortint     ;
                                                         begin result:=             _type  ; end;
function TSSPInt      .asInt          (): int64        ;
                                                         begin result:=             _value ; end;
function TSSPInt      .asInt8         (): shortint     ;
                                                         begin result:=             _value ; end;
function TSSPInt      .asInt16        (): smallint     ;
                                                         begin result:=             _value ; end;
function TSSPInt      .asInt32        (): longint      ;
                                                         begin result:=             _value ; end;
function TSSPInt      .asInt64        (): int64        ;
                                                         begin result:=             _value ; end;
function TSSPInt      .asString       (): WideString   ;
                                                         begin result:= intToStr   (_value); end;
function TSSPInt      .toString       (): WideString   ;
                                                         begin result:= asString   (      ); end;


function TSSPFloat    .getType        (): shortint     ;
                                                         begin result:=             _type  ; end;
function TSSPFloat    .asFloat        (): double       ;
                                                         begin result:=             _value ; end;
function TSSPFloat    .asFloat32      (): single       ;
                                                         begin result:=             _value ; end;
function TSSPFloat    .asFloat64      (): double       ;
                                                         begin result:=             _value ; end;
function TSSPFloat    .asString       (): WideString   ;
                                                         begin result:= normalFloatToStr('#0.###', _value); end;
function TSSPFloat    .toString       (): WideString   ;
                                                         begin result:= asString   (      ); end;

function TSSPDecimal  .getType        (): shortint     ;
                                                         begin result:= SSP_TYPE_DECIMAL   ; end;
function TSSPDecimal  .asDecimal      (): double       ;
                                                         begin result:= strToFloat (_value); end;
function TSSPDecimal  .asDecimalString(): AnsiString   ;
                                                         begin result:=             _value ; end;
function TSSPDecimal  .asString       (): WideString   ;
                                                         begin result:= utf8decode (_value); end;

function TSSPDecimal  .asUTF8String   (): AnsiString   ;
                                                         begin result:=             _value ; end;

function TSSPDecimal  .toString       (): WideString   ;
                                                         begin result:= asString   (      ); end;

function TSSPByteArray.getType        (): shortint     ;
                                                         begin result:= SSP_TYPE_BYTE_ARRAY; end;
function TSSPByteArray.asByteArray    (): TByteDynArray;
                                                         begin result:=             _value ; end;
function TSSPByteArray.asUTF8String   (): AnsiString   ;
  begin
    setLength(result, size());
    if 0 < size() then
      move(_value[0], result[1], size());
  end;

function TSSPByteArray.size           (): integer      ;
                                                         begin result:= length(     _value); end;

function TSSPArray    .getType        (): shortint     ;
                                                         begin result:= SSP_TYPE_ARRAY     ; end;
function TSSPArray    .size           (): integer      ;
                                                         begin result:= _value .count      ; end;

function TSSPObject   .getType        (): shortint     ;
                                                         begin result:= SSP_TYPE_OBJECT    ; end;
function TSSPObject   .size           (): integer      ;
                                                         begin result:= _values.count      ; end;


constructor TSSPAnyEntry.create(const key_: WideString; value_: ISSPAny);
  begin
    inherited create();
    _key  := key_  ;
    _value:= value_;
  end;

function TSSPAnyEntry.key  (): WideString;
                                           begin result:= _key  ; end;
function TSSPAnyEntry.value(): ISSPAny   ;
                                           begin result:= _value; end;

function newInt      (      value: int64        ): ISSPAny;
                                                            begin result:= TSSPInt      .create(value); end;
function newFloat    (      value: double       ): ISSPAny;
                                                            begin result:= TSSPFloat    .create(value); end;
function newString   (const value: WideString   ): ISSPAny;
                                                            begin result:= TSSPString   .create(value); end;
function newDecimal  (const value: AnsiString   ): ISSPAny;
                                                            begin result:= TSSPDecimal  .create(value); end;
function newByteArray(const value: TByteDynArray): ISSPAny;
                                                            begin result:= TSSPByteArray.create(value); end;

function newEntry    (const key  : WideString   ;
                      const value: ISSPAny      ): ISSPAnyEntry;
                                                            begin result:= TSSPAnyEntry.create(key, value); end;

function newArray    (const values: array of ISSPAny     ): ISSPAny;
  var i: integer;
  begin
    result:= TSSPArray.create();
    for i:= 0 to length(values) - 1 do
      result.add(values[i]);
  end;

function newObject   (const values: array of ISSPAnyEntry): ISSPAny;
  var i: integer;
  begin
    result:= TSSPObject.create();
    for i:= 0 to length(values) - 1 do
      result.add(values[i].key, values[i].value);
  end;


end.