local WhatsNew = script:FindFirstAncestor("WhatsNew")

require(WhatsNew.Types)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)
require(WhatsNew.registry.ScopeActions)
local createResolveDeps = require(WhatsNew.storage.createResolveDeps)

local flag = false
local EnsureWhatsNewStoreInitialized = {}

function EnsureWhatsNewStoreInitialized.ensureWhatsNewStoreInitialized(p)
	if flag then
		return
	end

	local deps = p.deps or createResolveDeps.createResolveDeps()

	local bundledRegistry = LoadWhatsNewRegistry.loadBundledRegistry(deps, {
		scopeActions = p.scopeActions
	})

	GetWhatsNewStore().initialize({ rootTourMap = bundledRegistry, scopeActions = p.scopeActions })

	flag = true
end

function EnsureWhatsNewStoreInitialized.resetForTests()
	flag = false
	GetWhatsNewStore().resetForTests()
end

return EnsureWhatsNewStoreInitialized
