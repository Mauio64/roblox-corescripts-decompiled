local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local HttpRequest = require(script.Parent.HttpRequest)
local v5 = game:DefineFastString("RobloxPlusAmpFeatureName", "IsRobloxPlusSubscribed")
local v6 = game:DefineFastString("RobloxPlusAmpNamespace", "subscriptions/PlusSubscription")

local function getAmpFeatureAccess() -- line: 12
	-- upvalues: Url (copy), v5 (copy), v6 (copy), HttpRequest (copy), Promise (copy)
	local v8 = Url.APIS_URL .. "access-management/v1/feature-access?" .. Url:makeQueryString({
		featureNames = v5,
		namespace = v6
	})

	return HttpRequest.new():get(v8):andThen(function(p1) -- line: 23
		local v10 = p1 and p1.features

		if type(v10) == "table" and #v10 > 0 then
			return v10[1].access
		end

		return nil
	end):catch(function() -- line: 30
		-- upvalues: Promise (copy)
		return Promise.resolve(nil)
	end)
end

return getAmpFeatureAccess
