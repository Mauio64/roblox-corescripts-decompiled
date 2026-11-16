local module = require("@luauforge/bundled/edO")
local module2 = require("@luauforge/bundled/edP")
require("@luauforge/deferred/fvn")

local timeToInteractiveTracker = require("@luauforge/bundled/fvo").TimeToInteractiveTracker
local getTTIEventName = require("@luauforge/deferred/fvp").getTTIEventName

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
