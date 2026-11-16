local module = require("@luauforge/bundled/hwC")
local module2 = require("@luauforge/bundled/hwU")

local pageScopeFieldPageVisit = module.PageScopeFieldPageVisit
local pageScopeFieldPurchaseInFlight = module.PageScopeFieldPurchaseInFlight

local function beginPurchase()
	local v5 = module2()
	local v6 = v5.get(pageScopeFieldPageVisit)

	if v6 == nil or v5.get(pageScopeFieldPurchaseInFlight) == v6 then
		return nil
	end

	v5.set(pageScopeFieldPurchaseInFlight, v6)
	return function()
		if v5.get(pageScopeFieldPurchaseInFlight) == v6 then
			v5.set(pageScopeFieldPurchaseInFlight, nil)
		end
	end
end

return beginPurchase
