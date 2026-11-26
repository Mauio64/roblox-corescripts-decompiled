require("@luauforge/bundled/hIN")
local module = require("@luauforge/bundled/hIP")

local module2 = require("@luauforge/bundled/hIX")
local module3 = require("@luauforge/bundled/hJa")

local function shouldAskFirstTimePurchaseConsent(p2, p3)
	if p2 == nil or module2.hasAcknowledged(p2) then
		return module.resolve(false)
	end

	return module3(p2, p3)
end

return shouldAskFirstTimePurchaseConsent
