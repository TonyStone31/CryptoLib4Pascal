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

unit ClpIX9FieldID;

{$I ..\Include\CryptoLib.inc}

interface

uses
  ClpIDerObjectIdentifier,
  ClpIProxiedInterface;

type
  IX9FieldID = interface(IAsn1Encodable)

    ['{12A8969E-8050-4BB2-87F7-F4E155A35DCE}']

    function GetIdentifier: IDerObjectIdentifier;
    function GetParameters: IAsn1Object;

    property Identifier: IDerObjectIdentifier read GetIdentifier;

    property Parameters: IAsn1Object read GetParameters;

    /// <summary>
    /// <para>
    /// Produce a Der encoding of the following structure. <br />
    /// &lt;pre&gt;
    /// </para>
    /// <para>
    /// FieldID ::= Sequence { fieldType FIELD-ID.&amp;amp;id({IOSet}),
    /// parameters FIELD-ID.&amp;amp;Type({IOSet}{&amp;#64;fieldType})} <br />
    /// </para>
    /// <para>
    /// &lt;/pre&gt; <br />
    /// </para>
    /// </summary>
    function ToAsn1Object(): IAsn1Object;

  end;

implementation

end.
