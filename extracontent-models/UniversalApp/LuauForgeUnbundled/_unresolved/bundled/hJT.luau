local module = require("@luauforge/bundled/gra")
require("@luauforge/bundled/gdC")
local module2 = require("@luauforge/bundled/gdE")

return function(p2, data)
	local v5 = p2 == nil and {} or p2

	if data.type == module2.name then
		return {
			nativeProductId = data.nativeProductId,
			purchaseStatus = data.purchaseStatus,
			productType = data.productType,
			checkoutSessionId = data.checkoutSessionId
		}
	end

	if data.type == module.name then
		return {}
	end

	return v5
end
