local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Http").Url

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/HttpRequest")

local defineFastString = game:DefineFastString("RobloxPlusAmpFeatureName", "IsRobloxPlusSubscribed")
local defineFastString2 = game:DefineFastString("RobloxPlusAmpNamespace", "subscriptions/PlusSubscription")

local function getAmpFeatureAccess()
	local v5 = url.APIS_URL .. "access-management/v1/feature-access?" .. url:makeQueryString({
		featureNames = defineFastString,
		namespace = defineFastString2
	})

	return HttpRequest.new():get(v5):andThen(function(p2)
		local features = p2 and p2.features

		if type(features) == "table" and #features > 0 then
			return features[1].access
		end

		return nil
	end):catch(function()
		return Promise.resolve(nil)
	end)
end

return getAmpFeatureAccess
