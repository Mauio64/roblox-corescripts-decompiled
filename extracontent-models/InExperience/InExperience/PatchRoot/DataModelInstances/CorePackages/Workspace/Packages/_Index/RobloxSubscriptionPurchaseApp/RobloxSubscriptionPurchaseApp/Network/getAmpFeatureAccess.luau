local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local HttpRequest = require(script.Parent.HttpRequest)

local defineFastString = game:DefineFastString("RobloxPlusAmpFeatureName", "IsRobloxPlusSubscribed")
local defineFastString2 = game:DefineFastString("RobloxPlusAmpNamespace", "subscriptions/PlusSubscription")

local function getAmpFeatureAccess()
	local v = Url.APIS_URL .. "access-management/v1/feature-access?" .. Url:makeQueryString({
		featureNames = defineFastString,
		namespace = defineFastString2
	})

	return HttpRequest.new():get(v):andThen(function(p)
		local features = p and p.features

		if type(features) == "table" and #features > 0 then
			return features[1].access
		end

		return nil
	end):catch(function()
		return Promise.resolve(nil)
	end)
end

return getAmpFeatureAccess
