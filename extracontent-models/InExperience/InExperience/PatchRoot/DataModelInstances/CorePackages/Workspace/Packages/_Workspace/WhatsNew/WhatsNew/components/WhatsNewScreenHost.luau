local WhatsNew = script:FindFirstAncestor("WhatsNew")
local parent = WhatsNew.Parent

local React = require(parent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local ensureWhatsNewStoreInitialized = require(WhatsNew.store.ensureWhatsNewStoreInitialized)
require(WhatsNew.registry.ScopeActions)
local WhatsNewTourtip = require(script.Parent.WhatsNewTourtip)

local function WhatsNewScreenHost(props)
	local screenScopeId = props.screenScopeId
	local scopeActions = props.scopeActions
	local isEnabled = props.isEnabled == true
	local onReady = props.onReady
	local whatsNewStore = GetWhatsNewStore()

	React.useEffect(function()
		if not isEnabled then
			whatsNewStore.stopTour()
			return
		end

		ensureWhatsNewStoreInitialized.ensureWhatsNewStoreInitialized({
			scopeActions = scopeActions
		})

		if onReady ~= nil then
			onReady()
		end

		whatsNewStore.startEligibleTour(screenScopeId)

		return function()
			whatsNewStore.stopTour()
		end
	end, { isEnabled, onReady, screenScopeId, scopeActions, whatsNewStore })

	return React.createElement(React.Fragment, nil, {
		Children = React.createElement(React.Fragment, nil, props.children),
		Tooltip = React.createElement(WhatsNewTourtip)
	})
end

return React.memo(WhatsNewScreenHost)
