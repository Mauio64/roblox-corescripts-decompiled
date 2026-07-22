local WhatsNew = script:FindFirstAncestor("WhatsNew")

require(WhatsNew.Types)

local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local LoadWhatsNewRegistry = require(WhatsNew.registry.LoadWhatsNewRegistry)

require(WhatsNew.registry.ScopeActions)

local createResolveDeps = require(WhatsNew.storage.createResolveDeps)
local u5 = false

return {
	ensureWhatsNewStoreInitialized = function(t1: {[any]: any}) -- line: 23
		-- upvalues: u5 (ref), createResolveDeps (copy), LoadWhatsNewRegistry (copy), GetWhatsNewStore (copy)
		if u5 then
			return
		end

		local v7 = t1.deps or createResolveDeps.bootstrapPersistedResolveDeps()
		local v8 = LoadWhatsNewRegistry.loadBundledRegistry(v7, {
			scopeActions = t1.scopeActions
		})

		GetWhatsNewStore().initialize({
			rootTourMap = v8,
			scopeActions = t1.scopeActions
		})
		u5 = true
	end,
	resetForTests = function() -- line: 42
		-- upvalues: u5 (ref), GetWhatsNewStore (copy)
		u5 = false
		GetWhatsNewStore().resetForTests()
	end
}
