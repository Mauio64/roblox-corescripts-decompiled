local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Actions = ExpChat.Actions
local VoiceUIVisibilityChanged = require(Actions.VoiceUIVisibilityChanged)

return Rodux.createReducer(false, {
	[VoiceUIVisibilityChanged.name] = function(_: boolean, p1) -- line: 9
		return p1.visible
	end
})
