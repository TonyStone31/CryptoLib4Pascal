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

unit ClpFixedPointPreCompInfo;

{$I ..\..\..\Include\CryptoLib.inc}

interface

uses
  ClpCryptoLibTypes,
  ClpIECInterface,
  ClpIFixedPointPreCompInfo,
  ClpIPreCompInfo;

type

  /// <summary>
  /// Class holding precomputation data for fixed-point multiplications.
  /// </summary>
  TFixedPointPreCompInfo = class(TInterfacedObject, IPreCompInfo,
    IFixedPointPreCompInfo)

  strict private
    function GetWidth: Int32;
    procedure SetWidth(const Value: Int32);
    function GetPreComp: TCryptoLibGenericArray<IECPoint>;
    procedure SetPreComp(const Value: TCryptoLibGenericArray<IECPoint>);
    function GetOffset: IECPoint;
    procedure SetOffset(const Value: IECPoint);

  strict protected
  var
    Fm_offset: IECPoint;

    /// <summary>
    /// Array holding the precomputed <c>ECPoint</c>s used for a fixed point
    /// multiplication.
    /// </summary>
    Fm_preComp: TCryptoLibGenericArray<IECPoint>;

    /// <summary>
    /// The width used for the precomputation. If a larger width
    /// precomputation is already available this may be larger than was
    /// requested, so calling code should refer to the actual width.
    /// </summary>
    Fm_width: Int32;

  public
    constructor Create();
    property Offset: IECPoint read GetOffset write SetOffset;
    property PreComp: TCryptoLibGenericArray<IECPoint> read GetPreComp
      write SetPreComp;
    property Width: Int32 read GetWidth write SetWidth;

  end;

implementation

{ TFixedPointPreCompInfo }

constructor TFixedPointPreCompInfo.Create;
begin
  inherited Create();
end;

function TFixedPointPreCompInfo.GetOffset: IECPoint;
begin
  Result := Fm_offset;
end;

function TFixedPointPreCompInfo.GetPreComp: TCryptoLibGenericArray<IECPoint>;
begin
  Result := Fm_preComp;
end;

function TFixedPointPreCompInfo.GetWidth: Int32;
begin
  Result := Fm_width;
end;

procedure TFixedPointPreCompInfo.SetOffset(const Value: IECPoint);
begin
  Fm_offset := Value;
end;

procedure TFixedPointPreCompInfo.SetPreComp(const Value
  : TCryptoLibGenericArray<IECPoint>);
begin
  Fm_preComp := Value;
end;

procedure TFixedPointPreCompInfo.SetWidth(const Value: Int32);
begin
  Fm_width := Value;
end;

end.
