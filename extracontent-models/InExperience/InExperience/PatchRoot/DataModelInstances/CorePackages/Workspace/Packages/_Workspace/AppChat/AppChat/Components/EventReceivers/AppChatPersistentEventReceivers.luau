local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)

local AppChatAccountSettingsEventReceiver = require(script.Parent.AppChatAccountSettingsEventReceiver)
local AppChatInterventionEventReceiver = require(script.Parent.AppChatInterventionEventReceiver)
local AppChatThirdPartySettingsEventReceiver = require(script.Parent.AppChatThirdPartySettingsEventReceiver)
local AppChatNotificationEventReceiver = require(script.Parent.AppChatNotificationEventReceiver)
local AppChatRemoveThirdPartyRestriction = require(script.Parent.AppChatRemoveThirdPartyRestriction)

local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)

local friendsChatExperimentExposureEventReceiver = nil
local function getFriendsChatExperimentExposureEventReceiver() -- 1 equivalent call inferred from this helper
	if friendsChatExperimentExposureEventReceiver == nil then
		local FriendsChatExperimentExposureEventReceiver = require(script.Parent.FriendsChatExperimentExposureEventReceiver)
		friendsChatExperimentExposureEventReceiver = FriendsChatExperimentExposureEventReceiver
	end

	return friendsChatExperimentExposureEventReceiver
end

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local ExternalChatMessageSenderRegistration

if FFlagEnableShareSheet then
	ExternalChatMessageSenderRegistration = require(script.Parent.ExternalChatMessageSenderRegistration)
else
	ExternalChatMessageSenderRegistration = nil
end

local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatPersistentEventReceivers(p)
	local createElement = React.createElement
	local fragment = React.Fragment
	local children = {
		accountSettings = React.createElement(AppChatAccountSettingsEventReceiver, {
			isInExperience = p.isInExperience
		}),
		intervention = React.createElement(AppChatInterventionEventReceiver, {}),
		thirdPartySettings = 0,
		notification = 0,
		friendsChatExperimentExposure = 0,
		externalChatMessageSenderRegistration = 0
	}
	local createElement2 = React.createElement
	local v

	if ThirdPartyUserService == nil or not ThirdPartyUserService:IsChatRestrictionSupported() then
		v = AppChatRemoveThirdPartyRestriction
	else
		v = AppChatThirdPartySettingsEventReceiver
	end

	children.thirdPartySettings = createElement2(v)

	children.notification = React.createElement(AppChatNotificationEventReceiver, {
		isInExperience = p.isInExperience
	})
	local friendsChatExperimentExposure

	if FFlagAppChatFriendsTabIxpEnabled and p.isInExperience then
		friendsChatExperimentExposure = React.createElement(getFriendsChatExperimentExposureEventReceiver()) -- inferred equivalent call
	end

	children.friendsChatExperimentExposure = friendsChatExperimentExposure
	local externalChatMessageSenderRegistration

	if FFlagEnableShareSheet then
		externalChatMessageSenderRegistration = React.createElement(ExternalChatMessageSenderRegistration, {
			isInExperience = p.isInExperience
		})
	end

	children.externalChatMessageSenderRegistration = externalChatMessageSenderRegistration
	return createElement(fragment, nil, children)
end

return AppChatPersistentEventReceivers
