local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local AppChatAccountSettingsEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatAccountSettingsEventReceiver")
local AppChatInterventionEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatInterventionEventReceiver")
local AppChatThirdPartySettingsEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatThirdPartySettingsEventReceiver")
local AppChatNotificationEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatNotificationEventReceiver")
local AppChatRemoveThirdPartyRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatRemoveThirdPartyRestriction")

local FFlagAppChatFriendsTabIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFriendsTabIxpEnabled")

local friendsChatExperimentExposureEventReceiver = nil
local function getFriendsChatExperimentExposureEventReceiver()
	if friendsChatExperimentExposureEventReceiver == nil then
		friendsChatExperimentExposureEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/FriendsChatExperimentExposureEventReceiver")
	end

	return friendsChatExperimentExposureEventReceiver
end

local fFlagEnableShareSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableShareSheet

local v5 = if fFlagEnableShareSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/ExternalChatMessageSenderRegistration") else nil

local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatPersistentEventReceivers(p2)
	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		accountSettings = React.createElement(AppChatAccountSettingsEventReceiver, {
			isInExperience = p2.isInExperience
		}),
		intervention = React.createElement(AppChatInterventionEventReceiver, {}),
		thirdPartySettings = 0,
		notification = 0,
		friendsChatExperimentExposure = 0,
		externalChatMessageSenderRegistration = 0
	}
	local createElement2 = React.createElement
	local v7

	if ThirdPartyUserService == nil or not ThirdPartyUserService:IsChatRestrictionSupported() then
		v7 = AppChatRemoveThirdPartyRestriction
	else
		v7 = AppChatThirdPartySettingsEventReceiver
	end

	children.thirdPartySettings = createElement2(v7)

	children.notification = React.createElement(AppChatNotificationEventReceiver, {
		isInExperience = p2.isInExperience
	})
	local v8

	if FFlagAppChatFriendsTabIxpEnabled and p2.isInExperience then
		local createElement3 = React.createElement

		if friendsChatExperimentExposureEventReceiver == nil then
			friendsChatExperimentExposureEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/FriendsChatExperimentExposureEventReceiver")
		end

		v8 = createElement3(friendsChatExperimentExposureEventReceiver)
	end

	children.friendsChatExperimentExposure = v8

	local v9 = if fFlagEnableShareSheet then React.createElement(v5, {
		isInExperience = p2.isInExperience
	}) else nil
	children.externalChatMessageSenderRegistration = v9
	return createElement(fragment, nil, children)
end

return AppChatPersistentEventReceivers
