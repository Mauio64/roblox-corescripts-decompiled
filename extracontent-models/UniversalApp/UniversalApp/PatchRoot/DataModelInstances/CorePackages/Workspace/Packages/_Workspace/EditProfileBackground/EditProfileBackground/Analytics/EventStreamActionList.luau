local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local Enums = require(Parent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.Enums.EventNames)
local ButtonNames = require(script.Parent.Enums.ButtonNames)

return {
	[EventNames.EditProfileBackgroundOpened] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.PageLoad,
		additionalInfo = {
			btn = ButtonNames.EditProfileBackgroundOpened
		}
	},
	[EventNames.BackgroundSelected] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = ButtonNames.BackgroundSelected
		}
	}
}
