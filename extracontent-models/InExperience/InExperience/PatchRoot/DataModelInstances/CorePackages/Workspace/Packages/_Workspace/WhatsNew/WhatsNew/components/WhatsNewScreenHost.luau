local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local React = require(WhatsNewParent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local ensureWhatsNewStoreInitialized = require(WhatsNew.store.ensureWhatsNewStoreInitialized)

require(WhatsNew.registry.ScopeActions)

local WhatsNewTourtip = require(script.Parent.WhatsNewTourtip)

local function WhatsNewScreenHost(t1: {[any]: any}) -- line: 26
	-- upvalues: GetWhatsNewStore (copy), React (copy), ensureWhatsNewStoreInitialized (copy), WhatsNewTourtip (copy)
	local screenScopeId = t1.screenScopeId
	local scopeActions = t1.scopeActions
	local v11 = t1.isEnabled == true
	local onReady = t1.onReady
	local v13 = GetWhatsNewStore()

	React.useEffect(function() -- line: 33
		-- upvalues: v11 (copy), v13 (copy), ensureWhatsNewStoreInitialized (copy), scopeActions (copy), onReady (copy), screenScopeId (copy)
		if not v11 then
			v13.stopTour()

			return
		end

		ensureWhatsNewStoreInitialized.ensureWhatsNewStoreInitialized({
			scopeActions = scopeActions
		})

		if onReady ~= nil then
			onReady()
		end

		v13.startEligibleTour(screenScopeId)

		return function() -- line: 49
			-- upvalues: v13 (copy)
			v13.stopTour()
		end
	end, {
		v11,
		onReady,
		screenScopeId,
		scopeActions,
		v13
	})

	return React.createElement(React.Fragment, nil, {
		Children = React.createElement(React.Fragment, nil, t1.children),
		Tooltip = React.createElement(WhatsNewTourtip)
	})
end

return React.memo(WhatsNewScreenHost)
