local module = require("@luauforge/bundled/gil")

return function(p2, data)
	local v5 = p2 or { Robux = {}, PremiumRobux = {}, Subscriptions = {} }

	assert(v5, "")

	if data.type == module.name then
		return {
			Robux = data.robux,
			PremiumRobux = data.premiumRobux,
			Subscriptions = data.subscriptions
		}
	end

	return v5
end
