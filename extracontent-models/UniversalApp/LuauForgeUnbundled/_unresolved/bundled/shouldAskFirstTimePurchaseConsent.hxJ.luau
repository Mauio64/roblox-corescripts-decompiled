require("@luauforge/bundled/hxA")
local module = require("@luauforge/bundled/hxC")

local module2 = require("@luauforge/bundled/hxK")
local module3 = require("@luauforge/bundled/hxN")

local function shouldAskFirstTimePurchaseConsent(p2, p3)
	if p2 == nil or module2.hasAcknowledged(p2) then
		return module.resolve(false)
	end

	return module3(p2, p3)
end

return shouldAskFirstTimePurchaseConsent
