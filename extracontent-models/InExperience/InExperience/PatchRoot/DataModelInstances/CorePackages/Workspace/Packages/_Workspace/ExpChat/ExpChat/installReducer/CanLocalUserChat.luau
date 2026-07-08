local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Rodux = require(ExpChatParent.Rodux)
local Actions = ExpChat.Actions
local ChatPrivacySettingsReceived = require(Actions.ChatPrivacySettingsReceived)
local ChatPrivacySettingsFetchFailed = require(Actions.ChatPrivacySettingsFetchFailed)

return Rodux.createReducer(false, {
	[ChatPrivacySettingsReceived.name] = function(_, p2) -- line: 10
		return p2.canUserChat
	end,
	[ChatPrivacySettingsFetchFailed.name] = function(_, _) -- line: 14
		return false
	end
})
