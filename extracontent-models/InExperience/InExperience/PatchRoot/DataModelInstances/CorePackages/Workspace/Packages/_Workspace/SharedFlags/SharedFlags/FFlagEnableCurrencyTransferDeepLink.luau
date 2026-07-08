local GetFFlagEnableCurrencyTransferFlow = require(script.Parent.GetFFlagEnableCurrencyTransferFlow)

return game:DefineFastFlag("EnableCurrencyTransferDeepLink", false) and GetFFlagEnableCurrencyTransferFlow()
