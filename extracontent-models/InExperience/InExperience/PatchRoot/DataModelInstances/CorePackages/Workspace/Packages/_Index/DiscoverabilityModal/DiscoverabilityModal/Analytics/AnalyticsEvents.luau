local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local EventNames = require(script.Parent.Enums.EventNames)

local socialLuaAnalytics = dependencies.SocialLuaAnalytics
local dash = dependencies.Dash

local enums = socialLuaAnalytics.Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes
local BtnValues = require(script.Parent.Enums.BtnValues)

return {
	[EventNames.DiscoverabilityModalLoad] = {
		context = contexts.ContactImport,
		eventType = eventTypes.DiscoverabilityModalLoad,
		formatRulesForAdditionalInfo = { version = dash.identity, wordingVersion = dash.identity }
	},
	[EventNames.DiscoverabilityModalContinue] = {
		context = contexts.ContactImport,
		eventType = eventTypes.DiscoverabilityModalClick,
		additionalInfo = { btn = BtnValues.ContactImporter },
		formatRulesForAdditionalInfo = { selected = dash.identity }
	},
	[EventNames.DiscoverabilityModalClose] = {
		context = contexts.ContactImport,
		eventType = eventTypes.DiscoverabilityModalClick,
		additionalInfo = { btn = BtnValues.Close },
		formatRulesForAdditionalInfo = { selected = dash.identity }
	},
	[EventNames.DiscoverabilityModalRadioButtonClick] = {
		context = contexts.ContactImport,
		eventType = eventTypes.DiscoverabilityModalRadioButtonClick,
		formatRulesForAdditionalInfo = { selected = dash.identity }
	}
}
