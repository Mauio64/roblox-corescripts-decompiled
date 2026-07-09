local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Actions = ExpChat.Actions
local VoiceEnabledChanged = require(Actions.VoiceEnabledChanged)

return Rodux.createReducer(false, {
	[VoiceEnabledChanged.name] = function(_: boolean, p1) -- line: 9
		return p1.enabled
	end
})
