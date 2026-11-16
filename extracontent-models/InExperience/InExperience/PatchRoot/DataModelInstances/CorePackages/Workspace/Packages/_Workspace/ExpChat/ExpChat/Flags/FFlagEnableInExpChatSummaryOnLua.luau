local parent = script:FindFirstAncestor("ExpChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableClientSummarySystemMessageOnLua = SharedFlags.FFlagEnableClientSummarySystemMessageOnLua

local engineFeature = game:GetEngineFeature("EnableInExpChatSummary2")
local defineFastFlag = game:DefineFastFlag("EnableInExpChatSummaryOnLua4", false)

return engineFeature and (defineFastFlag or FFlagEnableClientSummarySystemMessageOnLua)
