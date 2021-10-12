class Payment {
  final String provider;
  final String accountID;
  final String accountName;
  final String providerLogo;

  const Payment({
    required this.provider,
    required this.accountID,
    required this.accountName,
    required this.providerLogo,
  });
}
