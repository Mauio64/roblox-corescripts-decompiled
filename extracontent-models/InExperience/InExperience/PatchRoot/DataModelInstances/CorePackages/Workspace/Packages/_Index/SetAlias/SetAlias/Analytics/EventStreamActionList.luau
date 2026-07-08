local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Dash = require(ParentParent.dependencies).Dash
local Enums = require(ParentParentParent.SocialLuaAnalytics).Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes
local EventNames = require(script.Parent.Enums.EventNames)
local BtnValues = require(script.Parent.Enums.BtnValues)

return {
	[EventNames.CustomizeNameModalOpened] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = {
			origin = Dash.identity
		}
	},
	[EventNames.CustomizeNameClearedInput] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameClearedInput,
		formatRulesForAdditionalInfo = {
			origin = Dash.identity
		}
	},
	[EventNames.CustomizeNameMaximumCharLimitTyped] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameMaximumCharLimitTyped,
		formatRulesForAdditionalInfo = {
			alias = Dash.identity,
			origin = Dash.identity
		}
	},
	[EventNames.CustomizeNameModalClosed] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.CloseCustomizeName
		},
		formatRulesForAdditionalInfo = {
			origin = Dash.identity
		}
	},
	[EventNames.CustomizeNameSaved] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.ButtonClick,
		additionalInfo = {
			btn = BtnValues.SaveAlias
		},
		formatRulesForAdditionalInfo = {
			alias = Dash.identity,
			origin = Dash.identity
		}
	},
	[EventNames.CustomizeNameSaveAttemptInvalidInput] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameSaveAttemptInvalidInput,
		formatRulesForAdditionalInfo = {
			alias = Dash.identity,
			origin = Dash.identity
		}
	}
}
