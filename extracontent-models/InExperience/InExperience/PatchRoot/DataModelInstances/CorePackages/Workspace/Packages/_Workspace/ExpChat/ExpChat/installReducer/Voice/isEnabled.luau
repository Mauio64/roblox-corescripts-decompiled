local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)

local Actions = ExpChat.Actions
local VoiceEnabledChanged = require(Actions.VoiceEnabledChanged)

return Rodux.createReducer(false, {
	[VoiceEnabledChanged.name] = function(_: boolean, p)
		return p.enabled
	end
})
