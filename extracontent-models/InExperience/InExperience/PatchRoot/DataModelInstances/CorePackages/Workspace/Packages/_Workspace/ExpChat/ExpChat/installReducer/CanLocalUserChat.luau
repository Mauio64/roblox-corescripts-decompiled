local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Rodux = require(parent.Rodux)

local Actions = ExpChat.Actions
local ChatPrivacySettingsReceived = require(Actions.ChatPrivacySettingsReceived)
local ChatPrivacySettingsFetchFailed = require(Actions.ChatPrivacySettingsFetchFailed)

return Rodux.createReducer(false, {
	[ChatPrivacySettingsReceived.name] = function(_, p)
		return p.canUserChat
	end,
	[ChatPrivacySettingsFetchFailed.name] = function(_, _): boolean
		return false
	end
})
