local defineFastFlag = game:DefineFastFlag("ExpChatEnableGlobalChatSummarySystemMessage", false)
local engineFeature = game:GetEngineFeature("EnableGlobalChat3pSummary")
local FFlagEnableInExpChatSummaryOnLua = require(script.Parent.FFlagEnableInExpChatSummaryOnLua)

return engineFeature and defineFastFlag and FFlagEnableInExpChatSummaryOnLua
