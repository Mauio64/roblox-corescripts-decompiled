local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local Dash = require(EditProfileParent.Dash)
local Enums = require(EditProfileParent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local Constants = require(EditProfile.Common.Constants)
local EventNames = require(script.Parent.Enums.EventNames)
local BtnValues = require(script.Parent.Enums.BtnValues)

return {
	[EventNames.EditProfileOpened] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.PageLoad,
		additionalInfo = {
			page = Constants.EditProfilePage
		}
	},
	[EventNames.DisplayNameSaved] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.SaveDisplayName
		},
		formatRulesForAdditionalInfo = {
			displayName = Dash.identity
		}
	},
	[EventNames.DisplayNameModalOpened] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.OpenEditDisplayName
		}
	},
	[EventNames.DisplayNameModalLoaded] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.PageLoad,
		additionalInfo = {
			page = Constants.EditDisplayNameModal
		}
	},
	[EventNames.EditUsernameOpened] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.OpenEditUsername
		}
	},
	[EventNames.UsernameSaved] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.UsernameSaved
	},
	[EventNames.FilteredDisplayName] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.FilteredDisplayName,
		formatRulesForAdditionalInfo = {
			displayName = Dash.identity
		}
	},
	[EventNames.DisplayNameTooShort] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.DisplayNameTooShort,
		formatRulesForAdditionalInfo = {
			displayName = Dash.identity
		}
	},
	[EventNames.DescriptionPINBlocked] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.DescriptionPINBlocked
	},
	[EventNames.OpenAvatarMarketplace] = {
		context = Contexts.EditProfile,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.OpenAvatarMarketplace
		}
	}
}
