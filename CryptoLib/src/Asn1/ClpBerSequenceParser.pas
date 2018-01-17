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

unit ClpBerSequenceParser;

{$I ..\Include\CryptoLib.inc}

interface

uses
  ClpIAsn1StreamParser,
  ClpIAsn1SequenceParser,
  ClpIProxiedInterface,
  ClpIBerSequenceParser,
  ClpBerSequence;

type
  TBerSequenceParser = class(TInterfacedObject, IAsn1SequenceParser,
    IAsn1Convertible, IBerSequenceParser)

  strict private
  var
    F_parser: IAsn1StreamParser;

  public

    constructor Create(parser: IAsn1StreamParser);
    function ReadObject(): IAsn1Convertible; inline;
    function ToAsn1Object(): IAsn1Object; inline;

  end;

implementation

{ TBerSequenceParser }

constructor TBerSequenceParser.Create(parser: IAsn1StreamParser);
begin
  F_parser := parser;
end;

function TBerSequenceParser.ReadObject: IAsn1Convertible;
begin
  result := F_parser.ReadObject();
end;

function TBerSequenceParser.ToAsn1Object: IAsn1Object;
begin
  result := TBerSequence.Create(F_parser.ReadVector());
end;

end.
