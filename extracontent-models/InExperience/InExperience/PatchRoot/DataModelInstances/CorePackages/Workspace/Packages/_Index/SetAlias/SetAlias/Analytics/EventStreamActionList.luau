local parent = script.Parent.Parent
local parent2 = parent.Parent

local dependencies = require(parent.dependencies)
local dash = dependencies.Dash
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local Enums = SocialLuaAnalytics.Analytics.Enums
local Contexts = Enums.Contexts
local EventTypes = Enums.EventTypes

local EventNames = require(script.Parent.Enums.EventNames)
local BtnValues = require(script.Parent.Enums.BtnValues)

return {
	[EventNames.CustomizeNameModalOpened] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.PageLoad,
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameClearedInput] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameClearedInput,
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameMaximumCharLimitTyped] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameMaximumCharLimitTyped,
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	},
	[EventNames.CustomizeNameModalClosed] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.CloseCustomizeName },
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameSaved] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.SaveAlias },
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	},
	[EventNames.CustomizeNameSaveAttemptInvalidInput] = {
		context = Contexts.CustomizeName,
		eventType = EventTypes.CustomizeNameSaveAttemptInvalidInput,
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	}
}
