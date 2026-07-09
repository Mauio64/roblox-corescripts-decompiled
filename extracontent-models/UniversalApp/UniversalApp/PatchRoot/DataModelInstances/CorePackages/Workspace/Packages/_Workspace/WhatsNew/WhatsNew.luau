local Constants = require(script.Constants)
local Enums = require(script.Enums)
local TourTipCtaAccess = require(script.TourTipCtaAccess)
local LoadWhatsNewRegistry = require(script.registry.LoadWhatsNewRegistry)
local ScopeActions = require(script.registry.ScopeActions)
local validateRegistry = require(script.registry.validateRegistry)
local GetWhatsNewStore = require(script.store.GetWhatsNewStore)
local useWhatsNewRuntimeState = require(script.hooks.useWhatsNewRuntimeState)

return {
	["jest.config"] = script["jest.config"],
	Constants = Constants,
	Enums = Enums,
	TourTipCtaAccess = TourTipCtaAccess,
	scopeActions = ScopeActions,
	Loader = {
		validateRegistry = validateRegistry,
		loadWhatsNewRegistry = LoadWhatsNewRegistry.loadWhatsNewRegistry,
		loadBundledRegistry = LoadWhatsNewRegistry.loadBundledRegistry
	},
	GetWhatsNewStore = GetWhatsNewStore,
	useWhatsNewRuntimeState = useWhatsNewRuntimeState
}
