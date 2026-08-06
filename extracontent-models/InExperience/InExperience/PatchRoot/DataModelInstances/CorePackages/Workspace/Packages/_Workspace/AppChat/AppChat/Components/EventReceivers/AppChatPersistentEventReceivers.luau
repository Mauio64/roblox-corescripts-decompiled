local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local AppChatAccountSettingsEventReceiver = require(script.Parent.AppChatAccountSettingsEventReceiver)
local AppChatInterventionEventReceiver = require(script.Parent.AppChatInterventionEventReceiver)
local AppChatThirdPartySettingsEventReceiver = require(script.Parent.AppChatThirdPartySettingsEventReceiver)
local AppChatNotificationEventReceiver = require(script.Parent.AppChatNotificationEventReceiver)
local AppChatRemoveThirdPartyRestriction = require(script.Parent.AppChatRemoveThirdPartyRestriction)
local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local FriendsChatExperimentExposureEventReceiver = nil

local function getFriendsChatExperimentExposureEventReceiver() -- line: 15
	-- upvalues: FriendsChatExperimentExposureEventReceiver (ref)
	if FriendsChatExperimentExposureEventReceiver == nil then
		FriendsChatExperimentExposureEventReceiver = require(script.Parent.FriendsChatExperimentExposureEventReceiver)
	end

	return FriendsChatExperimentExposureEventReceiver
end

local FFlagEnableShareSheet = require(AppChatParent.SharedFlags).FFlagEnableShareSheet
local v13 = if not FFlagEnableShareSheet then nil else require(script.Parent.ExternalChatMessageSenderRegistration)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatPersistentEventReceivers(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), AppChatAccountSettingsEventReceiver (copy), AppChatInterventionEventReceiver (copy), ThirdPartyUserService (copy), AppChatThirdPartySettingsEventReceiver (copy), AppChatRemoveThirdPartyRestriction (copy), AppChatNotificationEventReceiver (copy), FFlagAppChatFriendsTabIxpEnabled (copy), FriendsChatExperimentExposureEventReceiver (ref), FFlagEnableShareSheet (copy), v13 (copy)
	local createElement = React.createElement
	local Fragment = React.Fragment
	local t2 = {
		accountSettings = React.createElement(AppChatAccountSettingsEventReceiver, {
			isInExperience = t1.isInExperience
		}),
		intervention = React.createElement(AppChatInterventionEventReceiver, {}),
		thirdPartySettings = React.createElement(if ThirdPartyUserService == nil or not ThirdPartyUserService:IsChatRestrictionSupported() then AppChatRemoveThirdPartyRestriction else AppChatThirdPartySettingsEventReceiver),
		notification = React.createElement(AppChatNotificationEventReceiver, {
			isInExperience = t1.isInExperience
		})
	}
	local v21

	if FFlagAppChatFriendsTabIxpEnabled and t1.isInExperience then
		local createElement2 = React.createElement

		if FriendsChatExperimentExposureEventReceiver == nil then
			FriendsChatExperimentExposureEventReceiver = require(script.Parent.FriendsChatExperimentExposureEventReceiver)
		end

		v21 = createElement2(FriendsChatExperimentExposureEventReceiver)
	else
		v21 = nil
	end

	t2.friendsChatExperimentExposure = v21
	t2.externalChatMessageSenderRegistration = if not FFlagEnableShareSheet then nil else React.createElement(v13, {
		isInExperience = t1.isInExperience
	})

	return createElement(Fragment, nil, t2)
end

return AppChatPersistentEventReceivers
