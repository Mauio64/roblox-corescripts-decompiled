local FFlagEnableInExpChatSummaryOnLua = require(script.Parent.FFlagEnableInExpChatSummaryOnLua)

local defineFastFlag = game:DefineFastFlag("EnableInExpChatPolishSummaryOnLuaForTranslatedMessageV2", false)

return FFlagEnableInExpChatSummaryOnLua and defineFastFlag
