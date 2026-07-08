local v1 = game:DefineFastFlag("EnableGlobalChat3pSummaryLuaApps", false)
local EngineFeature = game:GetEngineFeature("EnableGlobalChat3pSummary")
local FFlagEnableInExpChatSummaryOnLua = require(script.Parent.FFlagEnableInExpChatSummaryOnLua)

return EngineFeature and (v1 and FFlagEnableInExpChatSummaryOnLua)
