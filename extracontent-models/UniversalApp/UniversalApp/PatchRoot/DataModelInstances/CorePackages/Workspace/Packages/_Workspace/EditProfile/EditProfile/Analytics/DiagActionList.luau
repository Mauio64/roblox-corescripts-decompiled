local Parent = script:FindFirstAncestor("EditProfile").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local EventNames = require(script.Parent.Enums.EventNames)

return {
	[EventNames.EditProfileOpened] = {
		name = game:DefineFastString("EditProfileOpened", "EditProfileOpened")
	},
	[EventNames.DisplayNameSaved] = {
		name = game:DefineFastString("DisplayNameSaved", "DisplayNameSaved")
	},
	[EventNames.DisplayNameModalOpened] = {
		name = game:DefineFastString("DisplayNameModalOpened", "DisplayNameModalOpened")
	},
	[EventNames.DisplayNameModalLoaded] = {
		name = game:DefineFastString("DisplayNameModalLoaded", "DisplayNameModalLoaded")
	},
	[EventNames.EditUsernameOpened] = {
		name = game:DefineFastString("EditUsernameOpened", "EditUsernameOpened")
	},
	[EventNames.UsernameSaved] = {
		name = game:DefineFastString("UsernameSaved", "UsernameSaved")
	},
	[EventNames.FilteredDisplayName] = {
		name = game:DefineFastString("FilteredDisplayName", "FilteredDisplayName")
	},
	[EventNames.DisplayNameTooShort] = {
		name = game:DefineFastString("DisplayNameTooShort", "DisplayNameTooShort")
	},
	[EventNames.DescriptionPINBlocked] = {
		name = game:DefineFastString("DescriptionPINBlocked", "DescriptionPINBlocked")
	},
	[EventNames.OpenAvatarMarketplace] = {
		name = "OpenAvatarMarketplace",
		platformSpecificity = SocialLuaAnalytics.Analytics.Enums.PlatformSpecificity.BucketsOnly
	}
}
