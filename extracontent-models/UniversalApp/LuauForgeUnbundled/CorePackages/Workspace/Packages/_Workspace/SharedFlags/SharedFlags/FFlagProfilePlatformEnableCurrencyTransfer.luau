local GetFFlagEnableCurrencyTransferFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableCurrencyTransferFlow")

return game:DefineFastFlag("ProfilePlatformEnableCurrencyTransferV1", false) and GetFFlagEnableCurrencyTransferFlow()
