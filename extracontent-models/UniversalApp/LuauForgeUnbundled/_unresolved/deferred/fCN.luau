local module = require("@luauforge/bundled/ehl")
local module2 = require("@luauforge/bundled/ehm")
require("@luauforge/deferred/fCO")

local timeToInteractiveTracker = require("@luauforge/bundled/fCP").TimeToInteractiveTracker
local getTTIEventName = require("@luauforge/deferred/fCQ").getTTIEventName

return function(p2, p3)
	if p3 and p2 and p2.purchaseAnalyticsMetadata and p2.purchaseAnalyticsMetadata.surface then
		local ttiEventName = getTTIEventName(p2.purchaseAnalyticsMetadata.surface)
		timeToInteractiveTracker.trackStart(ttiEventName)
		timeToInteractiveTracker.updateMetadata(ttiEventName, {
			page = p2.purchaseAnalyticsMetadata.surface,
			category = "unified_purchase_modal"
		})
	end

	return function(object)
		object:dispatch(module2(module.UnifiedProductPurchaseModal, p2))
	end
end
