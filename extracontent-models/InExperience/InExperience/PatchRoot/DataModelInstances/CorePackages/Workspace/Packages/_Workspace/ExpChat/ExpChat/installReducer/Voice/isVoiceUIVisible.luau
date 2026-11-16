local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)

local Actions = ExpChat.Actions
local VoiceUIVisibilityChanged = require(Actions.VoiceUIVisibilityChanged)

return Rodux.createReducer(false, {
	[VoiceUIVisibilityChanged.name] = function(_: boolean, p)
		return p.visible
	end
})
