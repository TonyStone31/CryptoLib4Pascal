program CryptoLib.Tests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$WARN DUPLICATE_CTOR_DTOR OFF}
{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  ClpCryptoProObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\CryptoPro\ClpCryptoProObjectIdentifiers.pas',
  ClpECGost3410NamedCurves
    in '..\..\CryptoLib\src\Asn1\CryptoPro\ClpECGost3410NamedCurves.pas',
  ClpNistObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\Nist\ClpNistObjectIdentifiers.pas',
  ClpOiwObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\Oiw\ClpOiwObjectIdentifiers.pas',
  ClpPkcsObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\Pkcs\ClpPkcsObjectIdentifiers.pas',
  ClpRosstandartObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\RossStandart\ClpRosstandartObjectIdentifiers.pas',
  ClpSecNamedCurves in '..\..\CryptoLib\src\Asn1\Sec\ClpSecNamedCurves.pas',
  ClpSecObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\Sec\ClpSecObjectIdentifiers.pas',
  ClpTeleTrusTObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\TeleTrust\ClpTeleTrusTObjectIdentifiers.pas',
  ClpECNamedCurveTable
    in '..\..\CryptoLib\src\Asn1\X9\ClpECNamedCurveTable.pas',
  ClpX9Curve in '..\..\CryptoLib\src\Asn1\X9\ClpX9Curve.pas',
  ClpX9ECParameters in '..\..\CryptoLib\src\Asn1\X9\ClpX9ECParameters.pas',
  ClpX9ECParametersHolder
    in '..\..\CryptoLib\src\Asn1\X9\ClpX9ECParametersHolder.pas',
  ClpX9ECPoint in '..\..\CryptoLib\src\Asn1\X9\ClpX9ECPoint.pas',
  ClpX9FieldElement in '..\..\CryptoLib\src\Asn1\X9\ClpX9FieldElement.pas',
  ClpX9FieldID in '..\..\CryptoLib\src\Asn1\X9\ClpX9FieldID.pas',
  ClpX9IntegerConverter
    in '..\..\CryptoLib\src\Asn1\X9\ClpX9IntegerConverter.pas',
  ClpX9ObjectIdentifiers
    in '..\..\CryptoLib\src\Asn1\X9\ClpX9ObjectIdentifiers.pas',
  ClpAsn1Encodable in '..\..\CryptoLib\src\Asn1\ClpAsn1Encodable.pas',
  ClpAsn1EncodableVector
    in '..\..\CryptoLib\src\Asn1\ClpAsn1EncodableVector.pas',
  ClpAsn1InputStream in '..\..\CryptoLib\src\Asn1\ClpAsn1InputStream.pas',
  ClpAsn1Null in '..\..\CryptoLib\src\Asn1\ClpAsn1Null.pas',
  ClpAsn1Object in '..\..\CryptoLib\src\Asn1\ClpAsn1Object.pas',
  ClpAsn1OctetString in '..\..\CryptoLib\src\Asn1\ClpAsn1OctetString.pas',
  ClpAsn1OutputStream in '..\..\CryptoLib\src\Asn1\ClpAsn1OutputStream.pas',
  ClpAsn1Sequence in '..\..\CryptoLib\src\Asn1\ClpAsn1Sequence.pas',
  ClpAsn1Set in '..\..\CryptoLib\src\Asn1\ClpAsn1Set.pas',
  ClpAsn1StreamParser in '..\..\CryptoLib\src\Asn1\ClpAsn1StreamParser.pas',
  ClpAsn1TaggedObject in '..\..\CryptoLib\src\Asn1\ClpAsn1TaggedObject.pas',
  ClpAsn1Tags in '..\..\CryptoLib\src\Asn1\ClpAsn1Tags.pas',
  ClpBerApplicationSpecific
    in '..\..\CryptoLib\src\Asn1\ClpBerApplicationSpecific.pas',
  ClpBerApplicationSpecificParser
    in '..\..\CryptoLib\src\Asn1\ClpBerApplicationSpecificParser.pas',
  ClpBerBitString in '..\..\CryptoLib\src\Asn1\ClpBerBitString.pas',
  ClpBerNull in '..\..\CryptoLib\src\Asn1\ClpBerNull.pas',
  ClpBerOctetString in '..\..\CryptoLib\src\Asn1\ClpBerOctetString.pas',
  ClpBerOctetStringParser
    in '..\..\CryptoLib\src\Asn1\ClpBerOctetStringParser.pas',
  ClpBerOutputStream in '..\..\CryptoLib\src\Asn1\ClpBerOutputStream.pas',
  ClpBerSequence in '..\..\CryptoLib\src\Asn1\ClpBerSequence.pas',
  ClpBerSequenceParser in '..\..\CryptoLib\src\Asn1\ClpBerSequenceParser.pas',
  ClpBerSet in '..\..\CryptoLib\src\Asn1\ClpBerSet.pas',
  ClpBerSetParser in '..\..\CryptoLib\src\Asn1\ClpBerSetParser.pas',
  ClpBerTaggedObject in '..\..\CryptoLib\src\Asn1\ClpBerTaggedObject.pas',
  ClpBerTaggedObjectParser
    in '..\..\CryptoLib\src\Asn1\ClpBerTaggedObjectParser.pas',
  ClpConstructedOctetStream
    in '..\..\CryptoLib\src\Asn1\ClpConstructedOctetStream.pas',
  ClpDefiniteLengthInputStream
    in '..\..\CryptoLib\src\Asn1\ClpDefiniteLengthInputStream.pas',
  ClpDerApplicationSpecific
    in '..\..\CryptoLib\src\Asn1\ClpDerApplicationSpecific.pas',
  ClpDerBitString in '..\..\CryptoLib\src\Asn1\ClpDerBitString.pas',
  ClpDerBmpString in '..\..\CryptoLib\src\Asn1\ClpDerBmpString.pas',
  ClpDerBoolean in '..\..\CryptoLib\src\Asn1\ClpDerBoolean.pas',
  ClpDerEnumerated in '..\..\CryptoLib\src\Asn1\ClpDerEnumerated.pas',
  ClpDerExternal in '..\..\CryptoLib\src\Asn1\ClpDerExternal.pas',
  ClpDerExternalParser in '..\..\CryptoLib\src\Asn1\ClpDerExternalParser.pas',
  ClpDerGeneralString in '..\..\CryptoLib\src\Asn1\ClpDerGeneralString.pas',
  ClpDerGraphicString in '..\..\CryptoLib\src\Asn1\ClpDerGraphicString.pas',
  ClpDerIA5String in '..\..\CryptoLib\src\Asn1\ClpDerIA5String.pas',
  ClpDerInteger in '..\..\CryptoLib\src\Asn1\ClpDerInteger.pas',
  ClpDerNull in '..\..\CryptoLib\src\Asn1\ClpDerNull.pas',
  ClpDerNumericString in '..\..\CryptoLib\src\Asn1\ClpDerNumericString.pas',
  ClpDerObjectIdentifier
    in '..\..\CryptoLib\src\Asn1\ClpDerObjectIdentifier.pas',
  ClpDerOctetString in '..\..\CryptoLib\src\Asn1\ClpDerOctetString.pas',
  ClpDerOctetStringParser
    in '..\..\CryptoLib\src\Asn1\ClpDerOctetStringParser.pas',
  ClpDerOutputStream in '..\..\CryptoLib\src\Asn1\ClpDerOutputStream.pas',
  ClpDerPrintableString in '..\..\CryptoLib\src\Asn1\ClpDerPrintableString.pas',
  ClpDerSequence in '..\..\CryptoLib\src\Asn1\ClpDerSequence.pas',
  ClpDerSequenceParser in '..\..\CryptoLib\src\Asn1\ClpDerSequenceParser.pas',
  ClpDerSet in '..\..\CryptoLib\src\Asn1\ClpDerSet.pas',
  ClpDerSetParser in '..\..\CryptoLib\src\Asn1\ClpDerSetParser.pas',
  ClpDerStringBase in '..\..\CryptoLib\src\Asn1\ClpDerStringBase.pas',
  ClpDerT61String in '..\..\CryptoLib\src\Asn1\ClpDerT61String.pas',
  ClpDerTaggedObject in '..\..\CryptoLib\src\Asn1\ClpDerTaggedObject.pas',
  ClpDerUniversalString in '..\..\CryptoLib\src\Asn1\ClpDerUniversalString.pas',
  ClpDerUtf8String in '..\..\CryptoLib\src\Asn1\ClpDerUtf8String.pas',
  ClpDerVideotexString in '..\..\CryptoLib\src\Asn1\ClpDerVideotexString.pas',
  ClpDerVisibleString in '..\..\CryptoLib\src\Asn1\ClpDerVisibleString.pas',
  ClpIndefiniteLengthInputStream
    in '..\..\CryptoLib\src\Asn1\ClpIndefiniteLengthInputStream.pas',
  ClpLimitedInputStream in '..\..\CryptoLib\src\Asn1\ClpLimitedInputStream.pas',
  ClpOidTokenizer in '..\..\CryptoLib\src\Asn1\ClpOidTokenizer.pas',
  ClpECKeyPairGenerator
    in '..\..\CryptoLib\src\Crypto\Generators\ClpECKeyPairGenerator.pas',
  ClpECDomainParameters
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpECDomainParameters.pas',
  ClpECKeyGenerationParameters
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpECKeyGenerationParameters.pas',
  ClpECKeyParameters
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpECKeyParameters.pas',
  ClpECPrivateKeyParameters
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpECPrivateKeyParameters.pas',
  ClpECPublicKeyParameters
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpECPublicKeyParameters.pas',
  ClpCryptoApiRandomGenerator
    in '..\..\CryptoLib\src\Crypto\Prng\ClpCryptoApiRandomGenerator.pas',
  ClpDigestRandomGenerator
    in '..\..\CryptoLib\src\Crypto\Prng\ClpDigestRandomGenerator.pas',
  ClpAsymmetricCipherKeyPair
    in '..\..\CryptoLib\src\Crypto\ClpAsymmetricCipherKeyPair.pas',
  ClpAsymmetricKeyParameter
    in '..\..\CryptoLib\src\Crypto\ClpAsymmetricKeyParameter.pas',
  ClpKeyGenerationParameters
    in '..\..\CryptoLib\src\Crypto\ClpKeyGenerationParameters.pas',
  ClpIAbstractECMultiplier
    in '..\..\CryptoLib\src\Interfaces\ClpIAbstractECMultiplier.pas',
  ClpIAsn1ApplicationSpecificParser
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1ApplicationSpecificParser.pas',
  ClpIAsn1Choice in '..\..\CryptoLib\src\Interfaces\ClpIAsn1Choice.pas',
  ClpIAsn1EncodableVector
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1EncodableVector.pas',
  ClpIAsn1InputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1InputStream.pas',
  ClpIAsn1Null in '..\..\CryptoLib\src\Interfaces\ClpIAsn1Null.pas',
  ClpIAsn1OctetString
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1OctetString.pas',
  ClpIAsn1OctetStringParser
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1OctetStringParser.pas',
  ClpIAsn1OutputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1OutputStream.pas',
  ClpIAsn1Sequence in '..\..\CryptoLib\src\Interfaces\ClpIAsn1Sequence.pas',
  ClpIAsn1SequenceParser
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1SequenceParser.pas',
  ClpIAsn1Set in '..\..\CryptoLib\src\Interfaces\ClpIAsn1Set.pas',
  ClpIAsn1SetParser in '..\..\CryptoLib\src\Interfaces\ClpIAsn1SetParser.pas',
  ClpIAsn1StreamParser
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1StreamParser.pas',
  ClpIAsn1String in '..\..\CryptoLib\src\Interfaces\ClpIAsn1String.pas',
  ClpIAsn1TaggedObject
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1TaggedObject.pas',
  ClpIAsn1TaggedObjectParser
    in '..\..\CryptoLib\src\Interfaces\ClpIAsn1TaggedObjectParser.pas',
  ClpIAsymmetricCipherKeyPair
    in '..\..\CryptoLib\src\Interfaces\ClpIAsymmetricCipherKeyPair.pas',
  ClpIAsymmetricCipherKeyPairGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIAsymmetricCipherKeyPairGenerator.pas',
  ClpIAsymmetricKeyParameter
    in '..\..\CryptoLib\src\Interfaces\ClpIAsymmetricKeyParameter.pas',
  ClpIBaseInputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIBaseInputStream.pas',
  ClpIBerApplicationSpecific
    in '..\..\CryptoLib\src\Interfaces\ClpIBerApplicationSpecific.pas',
  ClpIBerApplicationSpecificParser
    in '..\..\CryptoLib\src\Interfaces\ClpIBerApplicationSpecificParser.pas',
  ClpIBerBitString in '..\..\CryptoLib\src\Interfaces\ClpIBerBitString.pas',
  ClpIBerNull in '..\..\CryptoLib\src\Interfaces\ClpIBerNull.pas',
  ClpIBerOctetString in '..\..\CryptoLib\src\Interfaces\ClpIBerOctetString.pas',
  ClpIBerOctetStringParser
    in '..\..\CryptoLib\src\Interfaces\ClpIBerOctetStringParser.pas',
  ClpIBerOutputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIBerOutputStream.pas',
  ClpIBerSequence in '..\..\CryptoLib\src\Interfaces\ClpIBerSequence.pas',
  ClpIBerSequenceParser
    in '..\..\CryptoLib\src\Interfaces\ClpIBerSequenceParser.pas',
  ClpIBerSet in '..\..\CryptoLib\src\Interfaces\ClpIBerSet.pas',
  ClpIBerSetParser in '..\..\CryptoLib\src\Interfaces\ClpIBerSetParser.pas',
  ClpIBerTaggedObject
    in '..\..\CryptoLib\src\Interfaces\ClpIBerTaggedObject.pas',
  ClpIBerTaggedObjectParser
    in '..\..\CryptoLib\src\Interfaces\ClpIBerTaggedObjectParser.pas',
  ClpICipherParameters
    in '..\..\CryptoLib\src\Interfaces\ClpICipherParameters.pas',
  ClpIConstructedOctetStream
    in '..\..\CryptoLib\src\Interfaces\ClpIConstructedOctetStream.pas',
  ClpICryptoApiRandomGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpICryptoApiRandomGenerator.pas',
  ClpIDefiniteLengthInputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIDefiniteLengthInputStream.pas',
  ClpIDerApplicationSpecific
    in '..\..\CryptoLib\src\Interfaces\ClpIDerApplicationSpecific.pas',
  ClpIDerBitString in '..\..\CryptoLib\src\Interfaces\ClpIDerBitString.pas',
  ClpIDerBmpString in '..\..\CryptoLib\src\Interfaces\ClpIDerBmpString.pas',
  ClpIDerBoolean in '..\..\CryptoLib\src\Interfaces\ClpIDerBoolean.pas',
  ClpIDerEnumerated in '..\..\CryptoLib\src\Interfaces\ClpIDerEnumerated.pas',
  ClpIDerExternal in '..\..\CryptoLib\src\Interfaces\ClpIDerExternal.pas',
  ClpIDerExternalParser
    in '..\..\CryptoLib\src\Interfaces\ClpIDerExternalParser.pas',
  ClpIDerGeneralString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerGeneralString.pas',
  ClpIDerGraphicString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerGraphicString.pas',
  ClpIDerIA5String in '..\..\CryptoLib\src\Interfaces\ClpIDerIA5String.pas',
  ClpIDerInteger in '..\..\CryptoLib\src\Interfaces\ClpIDerInteger.pas',
  ClpIDerNull in '..\..\CryptoLib\src\Interfaces\ClpIDerNull.pas',
  ClpIDerNumericString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerNumericString.pas',
  ClpIDerObjectIdentifier
    in '..\..\CryptoLib\src\Interfaces\ClpIDerObjectIdentifier.pas',
  ClpIDerOctetString in '..\..\CryptoLib\src\Interfaces\ClpIDerOctetString.pas',
  ClpIDerOctetStringParser
    in '..\..\CryptoLib\src\Interfaces\ClpIDerOctetStringParser.pas',
  ClpIDerPrintableString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerPrintableString.pas',
  ClpIDerSequence in '..\..\CryptoLib\src\Interfaces\ClpIDerSequence.pas',
  ClpIDerSequenceParser
    in '..\..\CryptoLib\src\Interfaces\ClpIDerSequenceParser.pas',
  ClpIDerSet in '..\..\CryptoLib\src\Interfaces\ClpIDerSet.pas',
  ClpIDerSetParser in '..\..\CryptoLib\src\Interfaces\ClpIDerSetParser.pas',
  ClpIDerStringBase in '..\..\CryptoLib\src\Interfaces\ClpIDerStringBase.pas',
  ClpIDerT61String in '..\..\CryptoLib\src\Interfaces\ClpIDerT61String.pas',
  ClpIDerTaggedObject
    in '..\..\CryptoLib\src\Interfaces\ClpIDerTaggedObject.pas',
  ClpIDerUniversalString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerUniversalString.pas',
  ClpIDerUtf8String in '..\..\CryptoLib\src\Interfaces\ClpIDerUtf8String.pas',
  ClpIDerVideotexString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerVideotexString.pas',
  ClpIDerVisibleString
    in '..\..\CryptoLib\src\Interfaces\ClpIDerVisibleString.pas',
  ClpIDigestRandomGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIDigestRandomGenerator.pas',
  ClpIECDomainParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIECDomainParameters.pas',
  ClpIECFieldElement in '..\..\CryptoLib\src\Interfaces\ClpIECFieldElement.pas',
  ClpIECInterface in '..\..\CryptoLib\src\Interfaces\ClpIECInterface.pas',
  ClpIECKeyGenerationParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIECKeyGenerationParameters.pas',
  ClpIECKeyPairGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIECKeyPairGenerator.pas',
  ClpIECKeyParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIECKeyParameters.pas',
  ClpIECPrivateKeyParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIECPrivateKeyParameters.pas',
  ClpIECPublicKeyParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIECPublicKeyParameters.pas',
  ClpIExtensionField in '..\..\CryptoLib\src\Interfaces\ClpIExtensionField.pas',
  ClpIFilterStream in '..\..\CryptoLib\src\Interfaces\ClpIFilterStream.pas',
  ClpIFiniteField in '..\..\CryptoLib\src\Interfaces\ClpIFiniteField.pas',
  ClpIFixedPointCombMultiplier
    in '..\..\CryptoLib\src\Interfaces\ClpIFixedPointCombMultiplier.pas',
  ClpIFixedPointPreCompInfo
    in '..\..\CryptoLib\src\Interfaces\ClpIFixedPointPreCompInfo.pas',
  ClpIGlvEndomorphism
    in '..\..\CryptoLib\src\Interfaces\ClpIGlvEndomorphism.pas',
  ClpIGlvTypeBEndomorphism
    in '..\..\CryptoLib\src\Interfaces\ClpIGlvTypeBEndomorphism.pas',
  ClpIGlvTypeBParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIGlvTypeBParameters.pas',
  ClpIIndefiniteLengthInputStream
    in '..\..\CryptoLib\src\Interfaces\ClpIIndefiniteLengthInputStream.pas',
  ClpIKeyGenerationParameters
    in '..\..\CryptoLib\src\Interfaces\ClpIKeyGenerationParameters.pas',
  ClpILimitedInputStream
    in '..\..\CryptoLib\src\Interfaces\ClpILimitedInputStream.pas',
  ClpIOidTokenizer in '..\..\CryptoLib\src\Interfaces\ClpIOidTokenizer.pas',
  ClpIPCGRandomNumberGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIPCGRandomNumberGenerator.pas',
  ClpIPolynomial in '..\..\CryptoLib\src\Interfaces\ClpIPolynomial.pas',
  ClpIPolynomialExtensionField
    in '..\..\CryptoLib\src\Interfaces\ClpIPolynomialExtensionField.pas',
  ClpIPreCompInfo in '..\..\CryptoLib\src\Interfaces\ClpIPreCompInfo.pas',
  ClpIProxiedInterface
    in '..\..\CryptoLib\src\Interfaces\ClpIProxiedInterface.pas',
  ClpIRandom in '..\..\CryptoLib\src\Interfaces\ClpIRandom.pas',
  ClpIRandomGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIRandomGenerator.pas',
  ClpIRandomNumberGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIRandomNumberGenerator.pas',
  ClpIScaleXPointMap in '..\..\CryptoLib\src\Interfaces\ClpIScaleXPointMap.pas',
  ClpISecureRandom in '..\..\CryptoLib\src\Interfaces\ClpISecureRandom.pas',
  ClpIWNafPreCompInfo
    in '..\..\CryptoLib\src\Interfaces\ClpIWNafPreCompInfo.pas',
  ClpIX9Curve in '..\..\CryptoLib\src\Interfaces\ClpIX9Curve.pas',
  ClpIX9ECParameters in '..\..\CryptoLib\src\Interfaces\ClpIX9ECParameters.pas',
  ClpIX9ECParametersHolder
    in '..\..\CryptoLib\src\Interfaces\ClpIX9ECParametersHolder.pas',
  ClpIX9ECPoint in '..\..\CryptoLib\src\Interfaces\ClpIX9ECPoint.pas',
  ClpIX9FieldElement in '..\..\CryptoLib\src\Interfaces\ClpIX9FieldElement.pas',
  ClpIX9FieldID in '..\..\CryptoLib\src\Interfaces\ClpIX9FieldID.pas',
  ClpGlvTypeBEndomorphism
    in '..\..\CryptoLib\src\Math\EC\Endo\ClpGlvTypeBEndomorphism.pas',
  ClpGlvTypeBParameters
    in '..\..\CryptoLib\src\Math\EC\Endo\ClpGlvTypeBParameters.pas',
  ClpAbstractECMultiplier
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpAbstractECMultiplier.pas',
  ClpFixedPointCombMultiplier
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpFixedPointCombMultiplier.pas',
  ClpFixedPointPreCompInfo
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpFixedPointPreCompInfo.pas',
  ClpFixedPointUtilities
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpFixedPointUtilities.pas',
  ClpWNafPreCompInfo
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpWNafPreCompInfo.pas',
  ClpECAlgorithms in '..\..\CryptoLib\src\Math\EC\ClpECAlgorithms.pas',
  ClpECCurve in '..\..\CryptoLib\src\Math\EC\ClpECCurve.pas',
  ClpECFieldElement in '..\..\CryptoLib\src\Math\EC\ClpECFieldElement.pas',
  ClpECPoint in '..\..\CryptoLib\src\Math\EC\ClpECPoint.pas',
  ClpLongArray in '..\..\CryptoLib\src\Math\EC\ClpLongArray.pas',
  ClpScaleXPointMap in '..\..\CryptoLib\src\Math\EC\ClpScaleXPointMap.pas',
  ClpBigInteger in '..\..\CryptoLib\src\Math\ClpBigInteger.pas',
  ClpDigestUtilities in '..\..\CryptoLib\src\Security\ClpDigestUtilities.pas',
  ClpRandom in '..\..\CryptoLib\src\Security\ClpRandom.pas',
  ClpSecureRandom in '..\..\CryptoLib\src\Security\ClpSecureRandom.pas',
  ClpCollectionUtilities
    in '..\..\CryptoLib\src\Utils\Collections\ClpCollectionUtilities.pas',
  ClpBase64 in '..\..\CryptoLib\src\Utils\Encoders\ClpBase64.pas',
  ClpHex in '..\..\CryptoLib\src\Utils\Encoders\ClpHex.pas',
  ClpStreamHelper in '..\..\CryptoLib\src\Utils\Helpers\ClpStreamHelper.pas',
  ClpStringHelper in '..\..\CryptoLib\src\Utils\Helpers\ClpStringHelper.pas',
  ClpBaseInputStream in '..\..\CryptoLib\src\Utils\IO\ClpBaseInputStream.pas',
  ClpFilterStream in '..\..\CryptoLib\src\Utils\IO\ClpFilterStream.pas',
  ClpStreams in '..\..\CryptoLib\src\Utils\IO\ClpStreams.pas',
  ClpPcgRandomMinimal
    in '..\..\CryptoLib\src\Utils\Randoms\ClpPcgRandomMinimal.pas',
  ClpPCGRandomNumberGenerator
    in '..\..\CryptoLib\src\Utils\Rng\ClpPCGRandomNumberGenerator.pas',
  ClpRandomNumberGenerator
    in '..\..\CryptoLib\src\Utils\Rng\ClpRandomNumberGenerator.pas',
  ClpArrayUtils in '..\..\CryptoLib\src\Utils\ClpArrayUtils.pas',
  ClpBitConverter in '..\..\CryptoLib\src\Utils\ClpBitConverter.pas',
  ClpBits in '..\..\CryptoLib\src\Utils\ClpBits.pas',
  ClpConverters in '..\..\CryptoLib\src\Utils\ClpConverters.pas',
  ClpCryptoLibTypes in '..\..\CryptoLib\src\Utils\ClpCryptoLibTypes.pas',
  ClpTimes in '..\..\CryptoLib\src\Utils\ClpTimes.pas',
  OIDTests in '..\src\Asn1\OIDTests.pas',
  ClpWNafUtilities
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpWNafUtilities.pas',
  SecureRandomTests in '..\src\Security\SecureRandomTests.pas',
  ClpBigIntegers in '..\..\CryptoLib\src\Utils\ClpBigIntegers.pas',
  ClpMod in '..\..\CryptoLib\src\Math\Raw\ClpMod.pas',
  ClpNat in '..\..\CryptoLib\src\Math\Raw\ClpNat.pas',
  ClpNumberStyles in '..\..\CryptoLib\src\Math\ClpNumberStyles.pas',
  ClpParametersWithRandom
    in '..\..\CryptoLib\src\Crypto\Parameters\ClpParametersWithRandom.pas',
  ClpIParametersWithRandom
    in '..\..\CryptoLib\src\Interfaces\ClpIParametersWithRandom.pas',
  ClpIDsa in '..\..\CryptoLib\src\Interfaces\ClpIDsa.pas',
  ClpIDsaKCalculator in '..\..\CryptoLib\src\Interfaces\ClpIDsaKCalculator.pas',
  ClpISigner in '..\..\CryptoLib\src\Interfaces\ClpISigner.pas',
  ClpRandomDsaKCalculator
    in '..\..\CryptoLib\src\Crypto\Signers\ClpRandomDsaKCalculator.pas',
  ClpIRandomDsaKCalculator
    in '..\..\CryptoLib\src\Interfaces\ClpIRandomDsaKCalculator.pas',
  ClpECDsaSigner in '..\..\CryptoLib\src\Crypto\Signers\ClpECDsaSigner.pas',
  ClpIECDsaSigner in '..\..\CryptoLib\src\Interfaces\ClpIECDsaSigner.pas',
  ClpDsaDigestSigner
    in '..\..\CryptoLib\src\Crypto\Signers\ClpDsaDigestSigner.pas',
  ClpIDsaDigestSigner
    in '..\..\CryptoLib\src\Interfaces\ClpIDsaDigestSigner.pas',
  ClpSignerUtilities in '..\..\CryptoLib\src\Security\ClpSignerUtilities.pas',
  ClpZTauElement in '..\..\CryptoLib\src\Math\EC\Abc\ClpZTauElement.pas',
  ClpIZTauElement in '..\..\CryptoLib\src\Interfaces\ClpIZTauElement.pas',
  ClpSimpleBigDecimal
    in '..\..\CryptoLib\src\Math\EC\Abc\ClpSimpleBigDecimal.pas',
  ClpTnaf in '..\..\CryptoLib\src\Math\EC\Abc\ClpTnaf.pas',
  ClpGlvMultiplier
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpGlvMultiplier.pas',
  ClpIGlvMultiplier in '..\..\CryptoLib\src\Interfaces\ClpIGlvMultiplier.pas',
  ClpWTauNafMultiplier
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpWTauNafMultiplier.pas',
  ClpIWTauNafMultiplier
    in '..\..\CryptoLib\src\Interfaces\ClpIWTauNafMultiplier.pas',
  ClpWTauNafPreCompInfo
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpWTauNafPreCompInfo.pas',
  ClpIWTauNafPreCompInfo
    in '..\..\CryptoLib\src\Interfaces\ClpIWTauNafPreCompInfo.pas',
  ClpWNafL2RMultiplier
    in '..\..\CryptoLib\src\Math\EC\Multiplier\ClpWNafL2RMultiplier.pas',
  ClpIWNafL2RMultiplier
    in '..\..\CryptoLib\src\Interfaces\ClpIWNafL2RMultiplier.pas',
  ClpGF2Polynomial in '..\..\CryptoLib\src\Math\Field\ClpGF2Polynomial.pas',
  ClpIGF2Polynomial in '..\..\CryptoLib\src\Interfaces\ClpIGF2Polynomial.pas',
  ClpGenericPolynomialExtensionField
    in '..\..\CryptoLib\src\Math\Field\ClpGenericPolynomialExtensionField.pas',
  ClpIGenericPolynomialExtensionField
    in '..\..\CryptoLib\src\Interfaces\ClpIGenericPolynomialExtensionField.pas',
  ClpPrimeField in '..\..\CryptoLib\src\Math\Field\ClpPrimeField.pas',
  ClpIPrimeField in '..\..\CryptoLib\src\Interfaces\ClpIPrimeField.pas',
  ClpFiniteFields in '..\..\CryptoLib\src\Math\Field\ClpFiniteFields.pas',
  EqualsAndHashCodeTests in '..\src\Asn1\EqualsAndHashCodeTests.pas',
  BigIntegerTests in '..\src\Math\BigIntegerTests.pas',
  ECAlgorithmsTests in '..\src\Math\ECAlgorithmsTests.pas',
  ECPointTests in '..\src\Math\ECPointTests.pas',
  ClpOSRandomNumberGenerator
    in '..\..\CryptoLib\src\Utils\Rng\ClpOSRandomNumberGenerator.pas',
  ClpIOSRandomNumberGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIOSRandomNumberGenerator.pas',
  ClpOSRandom in '..\..\CryptoLib\src\Utils\Randoms\ClpOSRandom.pas',
  ClpFixedSecureRandom in '..\src\Utils\ClpFixedSecureRandom.pas',
  ClpIFixedSecureRandom in '..\src\Utils\ClpIFixedSecureRandom.pas',
  ECDsa5Tests in '..\src\Others\ECDsa5Tests.pas',
  NamedCurveTests in '..\src\Others\NamedCurveTests.pas',
  SignerUtilitiesTests in '..\src\Others\SignerUtilitiesTests.pas',
  ClpStreamSorter in '..\..\CryptoLib\src\Utils\ClpStreamSorter.pas',
  DerApplicationSpecificTests in '..\src\Asn1\DerApplicationSpecificTests.pas',
  SecP384R1FieldTests in '..\src\Math\EC\Custom\Sec\SecP384R1FieldTests.pas',
  ECTests in '..\src\Others\ECTests.pas',
  ClpAsn1Generator in '..\..\CryptoLib\src\Asn1\ClpAsn1Generator.pas',
  ClpIAsn1Generator in '..\..\CryptoLib\src\Interfaces\ClpIAsn1Generator.pas',
  ClpDerGenerator in '..\..\CryptoLib\src\Asn1\ClpDerGenerator.pas',
  ClpIDerGenerator in '..\..\CryptoLib\src\Interfaces\ClpIDerGenerator.pas',
  ClpDerSequenceGenerator
    in '..\..\CryptoLib\src\Asn1\ClpDerSequenceGenerator.pas',
  ClpIDerSequenceGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIDerSequenceGenerator.pas',
  Asn1SequenceParserTests in '..\src\Asn1\Asn1SequenceParserTests.pas',
  ClpBerGenerator in '..\..\CryptoLib\src\Asn1\ClpBerGenerator.pas',
  ClpIBerGenerator in '..\..\CryptoLib\src\Interfaces\ClpIBerGenerator.pas',
  ClpIBerSequenceGenerator
    in '..\..\CryptoLib\src\Interfaces\ClpIBerSequenceGenerator.pas',
  ClpBerSequenceGenerator
    in '..\..\CryptoLib\src\Asn1\ClpBerSequenceGenerator.pas',
  ClpSetWeakRef in '..\..\CryptoLib\src\Utils\ClpSetWeakRef.pas';

begin

  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;

end.
