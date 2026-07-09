local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local SetGameSubscriptionProducts = require(Modules.LuaApp.Actions.Subscription.SetGameSubscriptionProducts)

return function(p1, p2) -- line: 6
	-- upvalues: SetGameSubscriptionProducts (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetGameSubscriptionProducts.name then
		v7 = Cryo.Dictionary.join(v7, {
			[p2.universeId] = p2.subscriptionProducts
		})
	end

	return v7
end
