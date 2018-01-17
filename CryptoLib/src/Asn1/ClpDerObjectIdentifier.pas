{ *********************************************************************************** }
{ *                              CryptoLib Library                                  * }
{ *                    Copyright (c) 2018 Ugochukwu Mmaduekwe                       * }
{ *                 Github Repository <https://github.com/Xor-el>                   * }

{ *  Distributed under the MIT software license, see the accompanying file LICENSE  * }
{ *          or visit http://www.opensource.org/licenses/mit-license.php.           * }

{ *                              Acknowledgements:                                  * }
{ *                                                                                 * }
{ *        Thanks to Sphere 10 Software (http://sphere10.com) for sponsoring        * }
{ *                        the development of this library                          * }

{ * ******************************************************************************* * }

(* &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& *)

unit ClpDerObjectIdentifier;

{$I ..\Include\CryptoLib.inc}

interface

uses
  Classes,
  SysUtils,
  StrUtils,
  SyncObjs,
  ClpBits,
  ClpArrayUtils,
  ClpStringHelper,
  ClpStreamHelper,
  ClpBigInteger,
  ClpCryptoLibTypes,
  ClpAsn1Tags,
  ClpOidTokenizer,
  ClpIOidTokenizer,
  ClpAsn1Object,
  ClpAsn1OctetString,
  ClpIAsn1TaggedObject,
  ClpIProxiedInterface,
  ClpIDerObjectIdentifier;

resourcestring
  SIllegalObject = 'Illegal Object in GetInstance: %s';
  SIdentifierNil = 'Identifier Cannot be Empty';
  SInvalidOID = '"String " %s is " not an OID"';
  SInvalidBranchId = '"String " %s " not a valid OID branch", "branchID"';

type
  TDerObjectIdentifier = class(TAsn1Object, IDerObjectIdentifier)

  strict private

  const
    LONG_LIMIT = Int64((Int64($7FFFFFFFFFFFFFFF) shr 7) - $7F);

  class var

    FLock: TCriticalSection;
    Fcache: TCryptoLibGenericArray<IDerObjectIdentifier>;

  var
    Fidentifier: String;
    Fbody: TCryptoLibByteArray;

    class constructor CreateDerObjectIdentifier();
    class destructor DestroyDerObjectIdentifier();

    constructor Create(oid: IDerObjectIdentifier;
      const branchID: String); overload;
    constructor Create(bytes: TCryptoLibByteArray); overload;

    function GetID: String; inline;

    procedure WriteField(outputStream: TStream; fieldValue: Int64); overload;
    procedure WriteField(outputStream: TStream;
      fieldValue: TBigInteger); overload;
    procedure DoOutput(bOut: TMemoryStream); overload;
    function GetBody(): TCryptoLibByteArray;
    class function IsValidBranchID(const branchID: String; start: Int32)
      : Boolean; static;
    class function IsValidIdentifier(const identifier: String): Boolean; static;
    class function MakeOidStringFromBytes(bytes: TCryptoLibByteArray)
      : String; static;

  strict protected
    function Asn1GetHashCode(): Int32; override;
    function Asn1Equals(asn1Object: IAsn1Object): Boolean; override;

  public
    // /**
    // * return an Oid from the passed in object
    // *
    // * @exception ArgumentException if the object cannot be converted.
    // */
    class function GetInstance(obj: TObject): IDerObjectIdentifier;
      overload; static;

    // /**
    // * return an Oid from the passed in byte array
    // */
    class function GetInstance(obj: TCryptoLibByteArray): IDerObjectIdentifier;
      overload; static; inline;

    // /**
    // * return an object Identifier from a tagged object.
    // *
    // * @param obj the tagged object holding the object we want
    // * @param explicitly true if the object is meant to be explicitly
    // *              tagged false otherwise.
    // * @exception ArgumentException if the tagged object cannot
    // *               be converted.
    // */
    class function GetInstance(obj: IAsn1TaggedObject; explicitly: Boolean)
      : IDerObjectIdentifier; overload; static; inline;

    class function FromOctetString(enc: TCryptoLibByteArray)
      : IDerObjectIdentifier; static;

    constructor Create(const identifier: String); overload;

    property ID: String read GetID;

    function Branch(const branchID: String): IDerObjectIdentifier; virtual;

    // /**
    // * Return  true if this oid is an extension of the passed in branch, stem.
    // * @param stem the arc or branch that is a possible parent.
    // * @return  true if the branch is on the passed in stem, false otherwise.
    // */

    function &On(stem: IDerObjectIdentifier): Boolean; virtual;

    procedure Encode(derOut: IDerOutputStream); override;

    function ToString(): String; override;

  end;

implementation

{ TDerObjectIdentifier }

function TDerObjectIdentifier.Asn1Equals(asn1Object: IAsn1Object): Boolean;
var
  other: IDerObjectIdentifier;
begin
  if (not Supports(asn1Object, IDerObjectIdentifier, other)) then
  begin
    result := false;
    Exit;
  end;

  result := ID = other.ID;
end;

function TDerObjectIdentifier.Asn1GetHashCode: Int32;
begin
  result := Fidentifier.GetHashCode();
end;

function TDerObjectIdentifier.Branch(const branchID: String)
  : IDerObjectIdentifier;
begin
  result := TDerObjectIdentifier.Create(Self as IDerObjectIdentifier, branchID);
end;

constructor TDerObjectIdentifier.Create(oid: IDerObjectIdentifier;
  const branchID: String);
begin
  Inherited Create();
  if (not(IsValidBranchID(branchID, 1))) then
    raise EArgumentCryptoLibException.CreateResFmt(@SInvalidBranchId,
      [branchID]);

  Fidentifier := oid.ID + '.' + branchID;
end;

constructor TDerObjectIdentifier.Create(const identifier: String);
begin
  Inherited Create();
  if (identifier = '') then
    raise EArgumentNilCryptoLibException.CreateRes(@SIdentifierNil);
  if (not(IsValidIdentifier(identifier))) then
    raise EFormatCryptoLibException.CreateResFmt(@SInvalidOID, [identifier]);

  Fidentifier := identifier;
end;

constructor TDerObjectIdentifier.Create(bytes: TCryptoLibByteArray);
begin
  Inherited Create();
  Fidentifier := MakeOidStringFromBytes(bytes);
  Fbody := System.Copy(bytes);
end;

function TDerObjectIdentifier.&On(stem: IDerObjectIdentifier): Boolean;
var
  LocalId, stemId: String;
begin
  LocalId := ID;
  stemId := stem.ID;
  result := (System.Length(LocalId) > System.Length(stemId)) and
    (LocalId[System.Length(stemId) + 1] = '.') and
    (AnsiStartsStr(stemId, LocalId));
end;

class constructor TDerObjectIdentifier.CreateDerObjectIdentifier;
begin
  FLock := TCriticalSection.Create;
  System.SetLength(Fcache, 1024);
end;

class destructor TDerObjectIdentifier.DestroyDerObjectIdentifier;
begin
  FLock.Free;
end;

procedure TDerObjectIdentifier.DoOutput(bOut: TMemoryStream);
var
  tok: IOidTokenizer;
  token: String;
  first: Int32;
begin
  tok := TOidTokenizer.Create(Fidentifier);
  token := tok.NextToken();
  first := StrToInt(token) * 40;
  token := tok.NextToken();
  if (System.Length(token) <= 18) then
  begin
    WriteField(bOut, Int64(first + StrToInt64(token)));
  end
  else
  begin
    WriteField(bOut, TBigInteger.Create(token).Add(TBigInteger.ValueOf(first)));
  end;

  while (tok.HasMoreTokens) do
  begin
    token := tok.NextToken();
    if (System.Length(token) <= 18) then
    begin
      WriteField(bOut, StrToInt64(token));
    end
    else
    begin

      WriteField(bOut, TBigInteger.Create(token));
    end;
  end;
end;

procedure TDerObjectIdentifier.Encode(derOut: IDerOutputStream);
begin
  derOut.WriteEncoded(TAsn1Tags.ObjectIdentifier, GetBody());
end;

class function TDerObjectIdentifier.FromOctetString(enc: TCryptoLibByteArray)
  : IDerObjectIdentifier;
var
  hashCode, first: Int32;
  entry: IDerObjectIdentifier;
begin

  hashCode := TArrayUtils.GetArrayHashCode(enc);
  first := hashCode and 1023;

  FLock.Acquire;
  try
    entry := Fcache[first];
    if ((entry <> Nil) and (TArrayUtils.AreEqual(enc, entry.GetBody()))) then
    begin
      result := entry;
      Exit;
    end;

    Fcache[first] := TDerObjectIdentifier.Create(enc);
    result := Fcache[first];

  finally
    FLock.Release;
  end;

end;

function TDerObjectIdentifier.GetBody: TCryptoLibByteArray;
var
  bOut: TMemoryStream;
begin
  FLock.Acquire;
  try
    if (Fbody = Nil) then
    begin
      bOut := TMemoryStream.Create();
      try
        DoOutput(bOut);
        System.SetLength(Fbody, bOut.Size);
        bOut.Position := 0;
        bOut.Read(Fbody[0], System.Length(Fbody));
      finally
        bOut.Free;
      end;
    end;

  finally
    FLock.Release;
  end;

  result := Fbody;
end;

function TDerObjectIdentifier.GetID: String;
begin
  result := Fidentifier;
end;

class function TDerObjectIdentifier.GetInstance(obj: IAsn1TaggedObject;
  explicitly: Boolean): IDerObjectIdentifier;
var
  o: IAsn1Object;
begin

  o := obj.GetObject();

  if ((explicitly) or (Supports(o, IDerObjectIdentifier))) then
  begin
    result := GetInstance(o as TAsn1Object);
    Exit;
  end;

  result := FromOctetString(TAsn1OctetString.GetInstance(o as TAsn1Object)
    .GetOctets());
end;

class function TDerObjectIdentifier.GetInstance(obj: TObject)
  : IDerObjectIdentifier;
begin
  if ((obj = Nil) or (obj is TDerObjectIdentifier)) then
  begin
    result := obj as TDerObjectIdentifier;
    Exit;
  end;

  raise EArgumentCryptoLibException.CreateResFmt(@SIllegalObject,
    [obj.ClassName]);
end;

class function TDerObjectIdentifier.GetInstance(obj: TCryptoLibByteArray)
  : IDerObjectIdentifier;
begin
  result := FromOctetString(obj);
end;

class function TDerObjectIdentifier.IsValidBranchID(const branchID: String;
  start: Int32): Boolean;
var
  periodAllowed: Boolean;
  pos: Int32;
  ch: Char;
begin
  periodAllowed := false;

  pos := System.Length(branchID) + 1;
  System.Dec(pos);
  while (pos >= start) do
  begin
    ch := branchID[pos];

    // TODO Leading zeroes?
    // if (('0' <= ch) and (ch <= '9')) then
    // begin
    // periodAllowed := true;
    // continue;
    // end;

    // TODO Leading zeroes?
    if (CharInSet(ch, ['0' .. '9'])) then
    begin
      periodAllowed := true;
      System.Dec(pos);
      continue;
    end;

    if (ch = '.') then
    begin
      if (not(periodAllowed)) then
      begin
        result := false;
        Exit;
      end;

      periodAllowed := false;
      System.Dec(pos);
      continue;
    end;

    result := false;
    Exit;
  end;

  result := periodAllowed;
end;

class function TDerObjectIdentifier.IsValidIdentifier(const identifier
  : String): Boolean;
var
  first: Char;
begin
  if ((System.Length(identifier) < 3) or (identifier[2] <> '.')) then
  begin
    result := false;
    Exit;
  end;

  first := identifier[1];
  // if ((first < '0') or (first > '2')) then
  // begin
  // result := false;
  // Exit;
  // end;
  if (not CharInSet(first, ['0' .. '2'])) then
  begin
    result := false;
    Exit;
  end;

  result := IsValidBranchID(identifier, 3);
end;

class function TDerObjectIdentifier.MakeOidStringFromBytes
  (bytes: TCryptoLibByteArray): String;
var
  objId: TStringList;
  value: Int64;
  bigValue: TBigInteger;
  first: Boolean;
  i, b: Int32;
begin
  value := 0;
  // bigValue := null;
  bigValue := Default (TBigInteger);
  first := true;
  objId := TStringList.Create();
  objId.LineBreak := '';
  try
    i := 0;
    while i <> System.Length(bytes) do
    begin
      b := Int32(bytes[i]);

      if (value <= LONG_LIMIT) then
      begin
        value := value + (b and $7F);
        if ((b and $80) = 0) then // end of number reached
        begin
          if (first) then
          begin
            if (value < 40) then
            begin
              objId.Add('0');
            end
            else if (value < 80) then
            begin
              objId.Add('1');
              value := value - 40;
            end
            else
            begin
              objId.Add('2');
              value := value - 80;
            end;
            first := false;
          end;

          objId.Add('.');
          objId.Add(IntToStr(value));
          value := 0;
        end
        else
        begin
          value := value shl 7;
        end;
      end
      else
      begin
        if (not bigValue.IsInitialized) then
        begin
          bigValue := TBigInteger.ValueOf(value);
        end;
        bigValue := bigValue.&Or(TBigInteger.ValueOf(b and $7F));
        if ((b and $80) = 0) then
        begin
          if (first) then
          begin
            objId.Add('2');
            bigValue := bigValue.Subtract(TBigInteger.ValueOf(80));
            first := false;
          end;

          objId.Add('.');
          objId.Add(bigValue.ToString());
          bigValue := Default (TBigInteger);
          value := 0;
        end
        else
        begin
          bigValue := bigValue.ShiftLeft(7);
        end
      end;

      System.Inc(i);
    end;

    result := objId.Text;

  finally
    objId.Free;
  end;

end;

function TDerObjectIdentifier.ToString: String;
begin
  result := ID;
end;

procedure TDerObjectIdentifier.WriteField(outputStream: TStream;
  fieldValue: TBigInteger);
var
  byteCount, i: Int32;
  tmpValue: TBigInteger;
  tmp: TCryptoLibByteArray;
begin
  byteCount := (fieldValue.BitLength + 6) div 7;
  if (byteCount = 0) then
  begin
    // outputStream.Write(TCryptoLibByteArray.Create(0)[0], 1);
    outputStream.WriteByte(0);
  end
  else
  begin
    tmpValue := fieldValue;
    System.SetLength(tmp, byteCount);

    i := byteCount - 1;

    while i >= 0 do
    begin
      tmp[i] := Byte((tmpValue.Int32Value and $7F) or $80);
      tmpValue := tmpValue.ShiftRight(7);
      System.Dec(i);
    end;

    tmp[byteCount - 1] := tmp[byteCount - 1] and $7F;
    outputStream.Write(tmp[0], System.Length(tmp));
  end;
end;

procedure TDerObjectIdentifier.WriteField(outputStream: TStream;
  fieldValue: Int64);
var
  tempRes: TCryptoLibByteArray;
  pos: Int32;
begin
  System.SetLength(tempRes, 9);
  pos := 8;
  tempRes[pos] := Byte(fieldValue and $7F);
  while (fieldValue >= (Int64(1) shl 7)) do
  begin
    fieldValue := TBits.Asr64(fieldValue, 7);
    System.Dec(pos);
    tempRes[pos] := Byte((fieldValue and $7F) or $80);
  end;
  outputStream.Write(tempRes[pos], 9 - pos);
end;

end.
