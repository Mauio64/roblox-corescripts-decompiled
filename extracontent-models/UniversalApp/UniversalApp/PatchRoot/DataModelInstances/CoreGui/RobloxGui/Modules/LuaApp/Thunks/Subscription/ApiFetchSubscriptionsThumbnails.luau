local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local ApiFetchThumbnails = require(CorePackages.Workspace.Packages.Http).Utils.ApiFetchThumbnails
local SubscriptionProductsGetThumbnails = require(Modules.LuaApp.Http.Requests.EconomyAPI.SubscriptionProductsGetThumbnails)
local SetSubscriptionProductsThumbnails = require(Modules.LuaApp.Actions.Subscription.SetSubscriptionProductsThumbnails)

return function(p1, p2) -- line: 12
	-- upvalues: Promise (copy), ApiFetchThumbnails (copy), SubscriptionProductsGetThumbnails (copy), SetSubscriptionProductsThumbnails (copy)
	return function(p3) -- line: 13
		-- upvalues: p2 (copy), Promise (copy), ApiFetchThumbnails (copy), p1 (copy), SubscriptionProductsGetThumbnails (copy), SetSubscriptionProductsThumbnails (copy)
		local SubscriptionProductsThumbnails = p3:getState().SubscriptionProductsThumbnails
		local t1 = {}

		if SubscriptionProductsThumbnails then
			for _, v13 in p2 do
				if SubscriptionProductsThumbnails[tostring(v13)] == nil then
					table.insert(t1, v13)
				end
			end
		else
			t1 = p2
		end

		if #t1 == 0 then
			return Promise.resolve()
		end

		return ApiFetchThumbnails.Fetch(p1, t1, "150x150", "SubscriptionProducts", SubscriptionProductsGetThumbnails, SetSubscriptionProductsThumbnails, p3)
	end
end
