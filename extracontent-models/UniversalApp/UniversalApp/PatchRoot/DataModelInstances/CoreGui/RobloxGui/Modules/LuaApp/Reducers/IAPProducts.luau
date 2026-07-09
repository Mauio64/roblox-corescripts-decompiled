local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetIAPProducts = require(Modules.LuaApp.Actions.SetIAPProducts)

return function(t1: {[any]: any}?, p1) -- line: 12
	-- upvalues: SetIAPProducts (copy)
	local v5 = t1 or {
		Robux = {},
		PremiumRobux = {},
		Subscriptions = {}
	}

	assert(v5, "")

	if p1.type == SetIAPProducts.name then
		return {
			Robux = p1.robux,
			PremiumRobux = p1.premiumRobux,
			Subscriptions = p1.subscriptions
		}
	end

	return v5
end
