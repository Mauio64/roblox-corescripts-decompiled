local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetSubscriptionStatuses = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionStatuses)

return function(p1, p2) -- line: 6
	-- upvalues: SetSubscriptionStatuses (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetSubscriptionStatuses.name then
		v7 = Cryo.Dictionary.join(v7, p2.subscriptionStatuses)
	end

	return v7
end
