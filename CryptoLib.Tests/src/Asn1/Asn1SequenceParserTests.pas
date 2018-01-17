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

unit Asn1SequenceParserTests;

interface

uses
  Classes,
  SysUtils,
{$IFDEF FPC}
  fpcunit,
  testregistry,
{$ELSE}
  TestFramework,
{$ENDIF FPC}
  ClpBigInteger,
  ClpHex,
  ClpCryptoLibTypes,
  ClpArrayUtils,
  ClpDerInteger,
  ClpIDerInteger,
  ClpIAsn1Null,
  ClpIAsn1StreamParser,
  ClpAsn1StreamParser,
  ClpIBerSequenceGenerator,
  ClpBerSequenceGenerator,
  ClpDerSequenceGenerator,
  ClpIDerSequenceGenerator,
  ClpIAsn1SequenceParser,
  ClpDerObjectIdentifier,
  ClpIDerObjectIdentifier;

type

  TCryptoLibTestCase = class abstract(TTestCase)

  end;

type

  TTestAsn1SequenceParser = class(TCryptoLibTestCase)
  private

  var
    FseqData, FnestedSeqData, FexpTagSeqData, FimplTagSeqData,
      FnestedSeqExpTagData, FnestedSeqImpTagData, FberSeqData,
      FberDerNestedSeqData, FberNestedSeqData, FberExpTagSeqData,
      FberSeqWithDERNullData: TCryptoLibByteArray;

    procedure doTestNestedReading(data: TCryptoLibByteArray);
    procedure doTestParseWithNull(data: TCryptoLibByteArray);

  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDerWriting;
    procedure TestNestedDerWriting;
    procedure TestDerExplicitTaggedSequenceWriting;
    procedure TestDerImplicitTaggedSequenceWriting;
    procedure TestNestedExplicitTagDerWriting;
    procedure TestNestedImplicitTagDerWriting;
    procedure TestBerWriting;
    procedure TestNestedBerDerWriting;
    procedure TestNestedBerWriting;
    procedure TestDerReading;
    procedure TestNestedDerReading;
    procedure TestBerReading;
    procedure TestNestedBerDerReading;
    procedure TestNestedBerReading;
    procedure TestBerExplicitTaggedSequenceWriting;
    procedure TestSequenceWithDerNullReading;

  end;

implementation

{ TTestAsn1SequenceParser }

procedure TTestAsn1SequenceParser.doTestNestedReading
  (data: TCryptoLibByteArray);
var
  aIn: IAsn1StreamParser;
  seq, s: IAsn1SequenceParser;
  o: IInterface;
  count: Int32;
begin
  aIn := TAsn1StreamParser.Create(data);
  seq := aIn.ReadObject() as IAsn1SequenceParser;

  count := 0;

  CheckNotNull(seq, 'null sequence returned');

  o := seq.ReadObject();
  while (o <> Nil) do
  begin
    case count of

      0:
        begin
          CheckTrue(Supports(o, IDerInteger));
        end;
      1:
        begin
          CheckTrue(Supports(o, IDerObjectIdentifier));
        end;
      2:
        begin
          CheckTrue(Supports(o, IAsn1SequenceParser));

          s := o as IAsn1SequenceParser;

          // NB: Must exhaust the nested parser
          while (s.ReadObject() <> Nil) do
          begin
            // Ignore
          end;

        end;
    end;

    System.Inc(count);
    o := seq.ReadObject();
  end;

  CheckEquals(3, count, 'wrong number of objects in sequence');
end;

procedure TTestAsn1SequenceParser.doTestParseWithNull
  (data: TCryptoLibByteArray);
var
  aIn: IAsn1StreamParser;
  seq: IAsn1SequenceParser;
  o: IInterface;
  count: Int32;
begin
  aIn := TAsn1StreamParser.Create(data);
  seq := aIn.ReadObject() as IAsn1SequenceParser;

  count := 0;

  CheckNotNull(seq, 'null sequence returned');

  o := seq.ReadObject();
  while (o <> Nil) do
  begin
    case count of

      0:
        begin
          CheckTrue(Supports(o, IAsn1Null));
        end;
      1:
        begin
          CheckTrue(Supports(o, IDerInteger));
        end;
      2:
        begin
          CheckTrue(Supports(o, IDerObjectIdentifier));
        end;
    end;

    System.Inc(count);
    o := seq.ReadObject();
  end;

  CheckEquals(3, count, 'wrong number of objects in sequence');
end;

procedure TTestAsn1SequenceParser.SetUp;
begin
  inherited;
  FseqData := THex.Decode('3006020100060129');
  FnestedSeqData := THex.Decode('300b0201000601293003020101');
  FexpTagSeqData := THex.Decode('a1083006020100060129');
  FimplTagSeqData := THex.Decode('a106020100060129');
  FnestedSeqExpTagData := THex.Decode('300d020100060129a1053003020101');
  FnestedSeqImpTagData := THex.Decode('300b020100060129a103020101');

  FberSeqData := THex.Decode('30800201000601290000');
  FberDerNestedSeqData := THex.Decode('308002010006012930030201010000');
  FberNestedSeqData := THex.Decode('3080020100060129308002010100000000');
  FberExpTagSeqData := THex.Decode('a180308002010006012900000000');
  FberSeqWithDERNullData := THex.Decode('308005000201000601290000');
end;

procedure TTestAsn1SequenceParser.TearDown;
begin
  inherited;

end;

procedure TTestAsn1SequenceParser.TestBerExplicitTaggedSequenceWriting;
var
  bOut: TMemoryStream;
  seqGen: IBerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen := TBerSequenceGenerator.Create(bOut, 1, true);

    seqGen.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);

    CheckTrue(TArrayUtils.AreEqual(FberExpTagSeqData, temp),
      'explicit BER tag writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestBerReading;
var
  aIn: IAsn1StreamParser;
  seq: IAsn1SequenceParser;
  count: Int32;
  o: IInterface;
begin
  aIn := TAsn1StreamParser.Create(FberSeqData);

  seq := aIn.ReadObject() as IAsn1SequenceParser;
  count := 0;

  CheckNotNull(seq, 'null sequence returned');

  o := seq.ReadObject();
  while (o <> Nil) do
  begin
    case count of

      0:
        begin
          CheckTrue(Supports(o, IDerInteger));

        end;
      1:
        begin
          CheckTrue(Supports(o, IDerObjectIdentifier));

        end;
    end;

    System.Inc(count);
    o := seq.ReadObject();
  end;

  CheckEquals(2, count, 'wrong number of objects in sequence');
end;

procedure TTestAsn1SequenceParser.TestBerWriting;
var
  bOut: TMemoryStream;
  seqGen: IBerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen := TBerSequenceGenerator.Create(bOut);

    seqGen.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen.Close();
    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FberSeqData, temp),
      'basic BER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestDerExplicitTaggedSequenceWriting;
var
  bOut: TMemoryStream;
  temp: TCryptoLibByteArray;
  seqGen: IDerSequenceGenerator;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen := TDerSequenceGenerator.Create(bOut, 1, true);

    seqGen.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);

    CheckTrue(TArrayUtils.AreEqual(FexpTagSeqData, temp),
      'explicit tag writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestDerImplicitTaggedSequenceWriting;
var
  bOut: TMemoryStream;
  seqGen: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen := TDerSequenceGenerator.Create(bOut, 1, false);

    seqGen.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);

    CheckTrue(TArrayUtils.AreEqual(FimplTagSeqData, temp),
      'implicit tag writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestDerReading;
var
  aIn: IAsn1StreamParser;
  seq: IAsn1SequenceParser;
  count: Int32;
  o: IInterface;
begin
  aIn := TAsn1StreamParser.Create(FseqData);

  seq := aIn.ReadObject() as IAsn1SequenceParser;
  count := 0;

  CheckNotNull(seq, 'null sequence returned');

  o := seq.ReadObject();
  while (o <> Nil) do
  begin
    case count of

      0:
        begin
          CheckTrue(Supports(o, IDerInteger));

        end;
      1:
        begin
          CheckTrue(Supports(o, IDerObjectIdentifier));

        end;
    end;

    System.Inc(count);
    o := seq.ReadObject();
  end;

  CheckEquals(2, count, 'wrong number of objects in sequence');
end;

procedure TTestAsn1SequenceParser.TestDerWriting;
var
  bOut: TMemoryStream;
  seqGen: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen := TDerSequenceGenerator.Create(bOut);

    seqGen.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen.Close();
    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FseqData, temp),
      'basic DER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestNestedBerDerReading;
begin
  doTestNestedReading(FberDerNestedSeqData);
end;

procedure TTestAsn1SequenceParser.TestNestedBerDerWriting;
var
  bOut: TMemoryStream;
  seqGen1: IBerSequenceGenerator;
  seqGen2: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen1 := TBerSequenceGenerator.Create(bOut);

    seqGen1.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen1.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen2 := TDerSequenceGenerator.Create(seqGen1.GetRawOutputStream());

    seqGen2.AddObject(TDerInteger.Create(TBigInteger.ValueOf(1)));

    seqGen2.Close();

    seqGen1.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FberDerNestedSeqData, temp),
      'nested BER/DER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestNestedBerReading;
begin
  doTestNestedReading(FberNestedSeqData);
end;

procedure TTestAsn1SequenceParser.TestNestedBerWriting;
var
  bOut: TMemoryStream;
  seqGen1, seqGen2: IBerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen1 := TBerSequenceGenerator.Create(bOut);

    seqGen1.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen1.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen2 := TBerSequenceGenerator.Create(seqGen1.GetRawOutputStream());

    seqGen2.AddObject(TDerInteger.Create(TBigInteger.ValueOf(1)));

    seqGen2.Close();

    seqGen1.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FberNestedSeqData, temp),
      'nested BER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestNestedDerReading;
begin
  doTestNestedReading(FnestedSeqData);
end;

procedure TTestAsn1SequenceParser.TestNestedDerWriting;
var
  bOut: TMemoryStream;
  seqGen1, seqGen2: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen1 := TDerSequenceGenerator.Create(bOut);

    seqGen1.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen1.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen2 := TDerSequenceGenerator.Create(seqGen1.GetRawOutputStream());

    seqGen2.AddObject(TDerInteger.Create(TBigInteger.One));

    seqGen2.Close();

    seqGen1.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FnestedSeqData, temp),
      'nested DER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestNestedExplicitTagDerWriting;
var
  bOut: TMemoryStream;
  seqGen1, seqGen2: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen1 := TDerSequenceGenerator.Create(bOut);

    seqGen1.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen1.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen2 := TDerSequenceGenerator.Create
      (seqGen1.GetRawOutputStream(), 1, true);

    seqGen2.AddObject(TDerInteger.Create(TBigInteger.ValueOf(1)));

    seqGen2.Close();

    seqGen1.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FnestedSeqExpTagData, temp),
      'nested explicit tagged DER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestNestedImplicitTagDerWriting;
var
  bOut: TMemoryStream;
  seqGen1, seqGen2: IDerSequenceGenerator;
  temp: TCryptoLibByteArray;
begin
  bOut := TMemoryStream.Create();
  try
    seqGen1 := TDerSequenceGenerator.Create(bOut);

    seqGen1.AddObject(TDerInteger.Create(TBigInteger.Zero));

    seqGen1.AddObject(TDerObjectIdentifier.Create('1.1'));

    seqGen2 := TDerSequenceGenerator.Create(seqGen1.GetRawOutputStream(),
      1, false);

    seqGen2.AddObject(TDerInteger.Create(TBigInteger.ValueOf(1)));

    seqGen2.Close();

    seqGen1.Close();

    bOut.Position := 0;
    System.SetLength(temp, bOut.Size);
    bOut.Read(temp[0], bOut.Size);
    CheckTrue(TArrayUtils.AreEqual(FnestedSeqImpTagData, temp),
      'nested implicit tagged DER writing test failed.');
  finally
    bOut.Free;
  end;
end;

procedure TTestAsn1SequenceParser.TestSequenceWithDerNullReading;
begin
  doTestParseWithNull(FberSeqWithDERNullData);
end;

initialization

// Register any test cases with the test runner

{$IFDEF FPC}
  RegisterTest(TTestAsn1SequenceParser);
{$ELSE}
  RegisterTest(TTestAsn1SequenceParser.Suite);
{$ENDIF FPC}

end.
