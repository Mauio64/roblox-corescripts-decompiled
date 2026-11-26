local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local apiFetchThumbnails = require("@game/CorePackages/Workspace/Packages/Http").Utils.ApiFetchThumbnails

local module = require("@luauforge/bundled/gCE")
local module2 = require("@luauforge/bundled/dBB")

return function(p2, items)
	return function(object)
		local subscriptionProductsThumbnails = object:getState().SubscriptionProductsThumbnails

		local v5 = {}

		if subscriptionProductsThumbnails then
			for k, item in items do
				if subscriptionProductsThumbnails[tostring(item)] == nil then
					table.insert(v5, item)
				end
			end
		else
			v5 = items
		end

		if #v5 == 0 then
			return Promise.resolve()
		end

		return apiFetchThumbnails.Fetch(p2, v5, "150x150", "SubscriptionProducts", module, module2, object)
	end
end
