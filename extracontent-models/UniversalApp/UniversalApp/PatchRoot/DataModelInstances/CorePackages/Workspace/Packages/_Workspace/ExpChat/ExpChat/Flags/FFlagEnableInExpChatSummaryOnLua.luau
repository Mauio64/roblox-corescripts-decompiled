local Parent = script:FindFirstAncestor("ExpChat").Parent
local FFlagEnableClientSummarySystemMessageOnLua = require(Parent.SharedFlags).FFlagEnableClientSummarySystemMessageOnLua
local EngineFeature = game:GetEngineFeature("EnableInExpChatSummary2")
local v4 = game:DefineFastFlag("EnableInExpChatSummaryOnLua4", false)

return EngineFeature and (v4 or FFlagEnableClientSummarySystemMessageOnLua)
