local FFlagTCUpsellModalEnabled_DEV = require(script.Parent.FFlagTCUpsellModalEnabled_DEV)

return FFlagTCUpsellModalEnabled_DEV and game:DefineFastFlag("DebugEnableTCDoubleOptIn_DEV", false)
