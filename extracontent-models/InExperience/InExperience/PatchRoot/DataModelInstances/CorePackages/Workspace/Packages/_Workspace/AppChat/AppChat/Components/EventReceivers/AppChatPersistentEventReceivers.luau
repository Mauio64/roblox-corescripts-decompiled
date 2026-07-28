local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local AppChatAccountSettingsEventReceiver = require(script.Parent.AppChatAccountSettingsEventReceiver)
local AppChatInterventionEventReceiver = require(script.Parent.AppChatInterventionEventReceiver)
local AppChatThirdPartySettingsEventReceiver = require(script.Parent.AppChatThirdPartySettingsEventReceiver)
local AppChatNotificationEventReceiver = require(script.Parent.AppChatNotificationEventReceiver)
local AppChatRemoveThirdPartyRestriction = require(script.Parent.AppChatRemoveThirdPartyRestriction)
local FFlagEnableShareSheet = require(Parent.SharedFlags).FFlagEnableShareSheet
local v9 = if not FFlagEnableShareSheet then nil else require(script.Parent.ExternalChatMessageSenderRegistration)
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")

local function AppChatPersistentEventReceivers(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), AppChatAccountSettingsEventReceiver (copy), AppChatInterventionEventReceiver (copy), ThirdPartyUserService (copy), AppChatThirdPartySettingsEventReceiver (copy), AppChatRemoveThirdPartyRestriction (copy), AppChatNotificationEventReceiver (copy), FFlagEnableShareSheet (copy), v9 (copy)
	return React.createElement(React.Fragment, nil, {
		accountSettings = React.createElement(AppChatAccountSettingsEventReceiver, {
			isInExperience = t1.isInExperience
		}),
		intervention = React.createElement(AppChatInterventionEventReceiver, {}),
		thirdPartySettings = React.createElement(if ThirdPartyUserService == nil or not ThirdPartyUserService:IsChatRestrictionSupported() then AppChatRemoveThirdPartyRestriction else AppChatThirdPartySettingsEventReceiver),
		notification = React.createElement(AppChatNotificationEventReceiver, {
			isInExperience = t1.isInExperience
		}),
		externalChatMessageSenderRegistration = if not FFlagEnableShareSheet then nil else React.createElement(v9, {
			isInExperience = t1.isInExperience
		})
	})
end

return AppChatPersistentEventReceivers
