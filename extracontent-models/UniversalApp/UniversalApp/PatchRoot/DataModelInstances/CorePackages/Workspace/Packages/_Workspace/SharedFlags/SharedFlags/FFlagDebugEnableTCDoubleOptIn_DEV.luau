local FFlagTCUpsellModalEnabled_DEV = require(script.Parent.FFlagTCUpsellModalEnabled_DEV)
local FFlagAppChatEnableDoubleOptIn = require(script.Parent.FFlagAppChatEnableDoubleOptIn)

return FFlagTCUpsellModalEnabled_DEV and (game:DefineFastFlag("DebugEnableTCDoubleOptIn_DEV", false) and FFlagAppChatEnableDoubleOptIn)
