local dash = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies").Dash
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialLuaAnalytics").Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/Enums/EventNames")
local BtnValues = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics/Enums/BtnValues")

return {
	[EventNames.CustomizeNameModalOpened] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.PageLoad,
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameClearedInput] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.CustomizeNameClearedInput,
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameMaximumCharLimitTyped] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.CustomizeNameMaximumCharLimitTyped,
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	},
	[EventNames.CustomizeNameModalClosed] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.CloseCustomizeName },
		formatRulesForAdditionalInfo = { origin = dash.identity }
	},
	[EventNames.CustomizeNameSaved] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = BtnValues.SaveAlias },
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	},
	[EventNames.CustomizeNameSaveAttemptInvalidInput] = {
		context = contexts.CustomizeName,
		eventType = eventTypes.CustomizeNameSaveAttemptInvalidInput,
		formatRulesForAdditionalInfo = { alias = dash.identity, origin = dash.identity }
	}
}
