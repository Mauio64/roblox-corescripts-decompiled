local Parent = script:FindFirstAncestor("ContactsToast").Parent
local DiagEventTypes = require(Parent.SocialLuaAnalytics).Analytics.Enums.DiagEventTypes
local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.ContactsToastSeen] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ContactsToastSeen", "ContactsToastSeen")
	},
	[EventNames.ContactsToastDismissed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ContactsToastDismissed", "ContactsToastDismissed")
	},
	[EventNames.ContactsToastButtonPressed] = {
		type = DiagEventTypes.Counter,
		name = game:DefineFastString("ContactsToastButtonPressed", "ContactsToastButtonPressed")
	}
}
