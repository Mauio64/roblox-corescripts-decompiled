local module = require("@luauforge/bundled/hxM")

local function hasRobloxSubscription(p2): boolean
	if p2 == nil or not module.isRobloxSubscriptionReadSupported() then
		return false
	end

	return p2.HasRobloxSubscription == true
end

return hasRobloxSubscription
