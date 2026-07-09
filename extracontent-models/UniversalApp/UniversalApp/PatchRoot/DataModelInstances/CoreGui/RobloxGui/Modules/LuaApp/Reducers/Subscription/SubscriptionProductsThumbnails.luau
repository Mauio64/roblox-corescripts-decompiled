local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetSubscriptionProductsThumbnails = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionProductsThumbnails)

return function(p1, p2) -- line: 6
	-- upvalues: SetSubscriptionProductsThumbnails (copy), Cryo (copy)
	local v7 = p1 or {}

	if p2.type == SetSubscriptionProductsThumbnails.name then
		v7 = Cryo.Dictionary.join(v7, p2.subscriptionProductsThumbnails)
	end

	return v7
end
