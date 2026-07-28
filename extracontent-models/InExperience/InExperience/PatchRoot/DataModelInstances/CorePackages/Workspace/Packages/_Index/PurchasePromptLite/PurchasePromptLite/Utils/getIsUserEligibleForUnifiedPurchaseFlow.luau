local AppStorageService = game:GetService("AppStorageService")
local Parent = script:FindFirstAncestor("PurchasePromptLite").Parent
local Url = require(Parent.Http).Url
local Promise = require(Parent.Promise)

local function APIGetRobloxSubscriptionMetadata(p1) -- line: 18
	-- upvalues: Promise (copy), Url (copy)
	if p1 == nil then
		return Promise.reject()
	end

	return p1(string.format("%sroblox-subscriptions/v1/metadata", Url.APIS_URL), "GET"):andThen(function(p2) -- line: 25
		-- upvalues: Promise (copy)
		return Promise.resolve(p2.responseBody)
	end, function(p3) -- line: 27
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
local function getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- line: 32
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end
local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- line: 37
	-- upvalues: AppStorageService (copy)
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end
local function persistUnifiedPurchaseFlowMetadata(b1: boolean, n1: number) -- line: 42
	-- upvalues: AppStorageService (copy)
	if b1 then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(n1)))
	AppStorageService:Flush()
end
local function getIsUserEligibleForUnifiedPurchaseFlow(p4, s1: string?) -- line: 54
	-- upvalues: Promise (copy), AppStorageService (copy), APIGetRobloxSubscriptionMetadata (copy)
	if s1 == "DeveloperSubscription" then
		return Promise.resolve(true)
	end

	local timestamp = os.time(os.date("!*t"))
	local v16 = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

	if v16 ~= -1 and timestamp < v16 then
		local v17 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

		return Promise.resolve(v17)
	end

	return APIGetRobloxSubscriptionMetadata(p4):andThen(function(t1: {[any]: any}) -- line: 69
		-- upvalues: timestamp (copy), AppStorageService (copy), Promise (copy)
		local unifiedPurchaseFlowMetadata = t1.unifiedPurchaseFlowMetadata
		local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
		local v23 = unifiedPurchaseFlowMetadata.expiresInSeconds or 0
		local v24 = timestamp + v23

		if isUserEligibleForUnifiedPurchaseFlow then
			AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
		else
			AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
		end

		AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(v24)))
		AppStorageService:Flush()

		return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
	end):catch(function(_) -- line: 78
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end

return getIsUserEligibleForUnifiedPurchaseFlow
