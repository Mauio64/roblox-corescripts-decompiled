local WhatsNew = script:FindFirstAncestor("WhatsNew")
local registry = WhatsNew.registry

require(WhatsNew.Types)

local createMockScopeActions = require(script.Parent.createMockScopeActions)
local createPilotScopeActions = require(registry.testHelpers.createPilotScopeActions)
local CreatePreStorageDeps = require(registry.testHelpers.CreatePreStorageDeps)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local LoadWhatsNewRegistry = require(registry.LoadWhatsNewRegistry)
local MakeRegistry = require(registry.testHelpers.MakeRegistry)

require(registry.ScopeActions)

local function createTestStore(t1: {[any]: any}?) -- line: 25
	-- upvalues: CreatePreStorageDeps (copy), MakeRegistry (copy), createMockScopeActions (copy), createPilotScopeActions (copy), LoadWhatsNewRegistry (copy), GetWhatsNewStore (copy)
	local v11 = t1 or {}
	local registryOrOptions = v11.registryOrOptions
	local v13 = CreatePreStorageDeps.createPreStorageDeps()
	local v14 = if registryOrOptions ~= nil then if registryOrOptions.constants == nil then MakeRegistry.makeRegistry(registryOrOptions) else registryOrOptions else MakeRegistry.inExperienceNested()
	local spies = nil
	local scopeActions

	if v11.useMockScopeActions then
		local v16 = createMockScopeActions()

		scopeActions = v16.scopeActions
		spies = v16.spies
	else
		scopeActions = createPilotScopeActions()
	end

	local v18 = LoadWhatsNewRegistry.loadWhatsNewRegistry(v14, v13, {
		scopeActions = scopeActions
	})
	local v19 = GetWhatsNewStore(false)

	v19.resetForTests()
	v19.initialize({
		rootTourMap = v18,
		scopeActions = scopeActions
	})

	return {
		store = v19,
		rootTourMap = v18,
		scopeActions = scopeActions,
		spies = spies
	}
end

return createTestStore
