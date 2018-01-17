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

unit ClpIWTauNafPreCompInfo;

{$I ..\Include\CryptoLib.inc}

interface

uses
  ClpIECInterface,
  ClpCryptoLibTypes,
  ClpIPreCompInfo;

type
  IWTauNafPreCompInfo = interface(IPreCompInfo)
    ['{E2E76FDB-8DD6-4DB5-9EC7-58C87DE8AD3D}']

    function GetPreComp: TCryptoLibGenericArray<IAbstractF2mPoint>;
    procedure SetPreComp(const value
      : TCryptoLibGenericArray<IAbstractF2mPoint>);

    property PreComp: TCryptoLibGenericArray<IAbstractF2mPoint> read GetPreComp
      write SetPreComp;

  end;

implementation

end.
