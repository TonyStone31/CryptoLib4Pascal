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

unit ClpDerGeneralString;

{$I ..\Include\CryptoLib.inc}

interface

uses
  SysUtils,
  ClpDerStringBase,
  ClpAsn1Tags,
  ClpAsn1OctetString,
  ClpAsn1Object,
  ClpIProxiedInterface,
  ClpCryptoLibTypes,
  ClpIAsn1TaggedObject,
  ClpIDerGeneralString;

resourcestring
  SIllegalObject = 'Illegal Object in GetInstance: %s';
  SStrNil = '"str"';

type

  TDerGeneralString = class(TDerStringBase, IDerGeneralString)

  strict private
  var
    FStr: String;

    function GetStr: String; inline;

    property Str: String read GetStr;

  strict protected
    function Asn1Equals(asn1Object: IAsn1Object): Boolean; override;
  public

    constructor Create(Str: TCryptoLibByteArray); overload;

    constructor Create(const Str: String); overload;

    function GetString(): String; override;

    function GetOctets(): TCryptoLibByteArray; inline;

    procedure Encode(derOut: IDerOutputStream); override;

    class function GetInstance(obj: TObject): IDerGeneralString; overload;
      static; inline;

    class function GetInstance(obj: IAsn1TaggedObject; isExplicit: Boolean)
      : IDerGeneralString; overload; static; inline;

  end;

implementation

{ TDerGeneralString }

function TDerGeneralString.GetOctets: TCryptoLibByteArray;
begin
{$IFDEF FPC}
  result := TEncoding.ASCII.GetBytes(UnicodeString(Str));
{$ELSE}
  result := TEncoding.ASCII.GetBytes(Str);
{$ENDIF FPC}
end;

function TDerGeneralString.Asn1Equals(asn1Object: IAsn1Object): Boolean;
var
  other: IDerGeneralString;
begin

  if (not Supports(asn1Object, IDerGeneralString, other)) then
  begin
    result := false;
    Exit;
  end;

  result := Str = other.Str;
end;

constructor TDerGeneralString.Create(Str: TCryptoLibByteArray);
begin
{$IFDEF FPC}
  Create(String(TEncoding.ASCII.GetString(Str)));
{$ELSE}
  Create(TEncoding.ASCII.GetString(Str));
{$ENDIF FPC}
end;

constructor TDerGeneralString.Create(const Str: String);
begin
  Inherited Create();
  if (Str = '') then
  begin
    raise EArgumentNilCryptoLibException.CreateRes(@SStrNil);
  end;

  FStr := Str;
end;

procedure TDerGeneralString.Encode(derOut: IDerOutputStream);
begin
  derOut.WriteEncoded(TAsn1Tags.GeneralString, GetOctets());
end;

class function TDerGeneralString.GetInstance(obj: IAsn1TaggedObject;
  isExplicit: Boolean): IDerGeneralString;
var
  o: IAsn1Object;
begin
  o := obj.GetObject();

  if ((isExplicit) or (Supports(o, IDerGeneralString))) then
  begin
    result := GetInstance(o as TAsn1Object);
    Exit;
  end;

  result := TDerGeneralString.Create
    (TAsn1OctetString.GetInstance(o as TAsn1Object).GetOctets());
end;

class function TDerGeneralString.GetInstance(obj: TObject): IDerGeneralString;
begin
  if ((obj = Nil) or (obj is TDerGeneralString)) then
  begin
    result := obj as TDerGeneralString;
    Exit;
  end;

  raise EArgumentCryptoLibException.CreateResFmt(@SIllegalObject,
    [obj.ClassName]);
end;

function TDerGeneralString.GetStr: String;
begin
  result := FStr;
end;

function TDerGeneralString.GetString: String;
begin
  result := Str;
end;

end.
