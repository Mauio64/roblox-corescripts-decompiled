local Parent = script:FindFirstAncestor("ContactsToast").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local EventNames = require(script.Parent.EventNames)
local Enums = SocialLuaAnalytics.Analytics.Enums
local BtnValues = require(script.Parent.BtnValues)
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local Dash = require(Parent.Dash)

return {
	[EventNames.ContactsToastSeen] = {
		context = Contexts.ContactsToast,
		eventType = EventTypes.UserSeen,
		formatRulesForAdditionalInfo = {
			variant = Dash.identity
		}
	},
	[EventNames.ContactsToastDismissed] = {
		context = Contexts.ContactsToast,
		eventType = EventTypes.Dismissed,
		formatRulesForAdditionalInfo = {
			variant = Dash.identity
		}
	},
	[EventNames.ContactsToastButtonPressed] = {
		context = Contexts.ContactsToast,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.FindFriendsButton
		},
		formatRulesForAdditionalInfo = {
			variant = Dash.identity
		}
	}
}
