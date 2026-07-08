local AppStorageService = game:GetService("AppStorageService")
local PurchasePromptLite = script:FindFirstAncestor("PurchasePromptLite")
local PurchasePromptLiteParent = PurchasePromptLite.Parent
local Url = require(PurchasePromptLiteParent.Http).Url
local Promise = require(PurchasePromptLiteParent.Promise)
local FFlagUnifiedPurchaseFlowShouldCacheExperimentResult = require(PurchasePromptLite.Flags.FFlagUnifiedPurchaseFlowShouldCacheExperimentResult)
local GetFFlagDevSubsEligibleForUnifiedPurchaseFlow = require(PurchasePromptLite.Flags.GetFFlagDevSubsEligibleForUnifiedPurchaseFlow)

local function APIGetRobloxSubscriptionMetadata(p1) -- line: 21
	-- upvalues: Promise (copy), Url (copy)
	if p1 == nil then
		return Promise.reject()
	end

	return p1(string.format("%sroblox-subscriptions/v1/metadata", Url.APIS_URL), "GET"):andThen(function(p2) -- line: 28
		-- upvalues: Promise (copy)
		return Promise.resolve(p2.responseBody)
	end, function(p3) -- line: 30
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
local function getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- line: 35
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end
local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- line: 40
	-- upvalues: AppStorageService (copy)
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end
local function persistUnifiedPurchaseFlowMetadata(b1: boolean, n1: number) -- line: 45
	-- upvalues: AppStorageService (copy)
	if b1 then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(n1)))
	AppStorageService:Flush()
end
local function getIsUserEligibleForUnifiedPurchaseFlow(p4, s1: string?) -- line: 57
	-- upvalues: GetFFlagDevSubsEligibleForUnifiedPurchaseFlow (copy), Promise (copy), FFlagUnifiedPurchaseFlowShouldCacheExperimentResult (copy), AppStorageService (copy), APIGetRobloxSubscriptionMetadata (copy)
	if s1 == "DeveloperSubscription" then
		local v18 = GetFFlagDevSubsEligibleForUnifiedPurchaseFlow()

		return Promise.resolve(v18)
	end

	local timestamp = os.time(os.date("!*t"))

	if FFlagUnifiedPurchaseFlowShouldCacheExperimentResult then
		local v20 = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

		if v20 ~= -1 and timestamp < v20 then
			local v21 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

			return Promise.resolve(v21)
		end
	end

	return APIGetRobloxSubscriptionMetadata(p4):andThen(function(t1: {[any]: any}) -- line: 75
		-- upvalues: FFlagUnifiedPurchaseFlowShouldCacheExperimentResult (copy), timestamp (copy), AppStorageService (copy), Promise (copy)
		local unifiedPurchaseFlowMetadata = t1.unifiedPurchaseFlowMetadata
		local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
		local v27 = unifiedPurchaseFlowMetadata.expiresInSeconds or 0

		if FFlagUnifiedPurchaseFlowShouldCacheExperimentResult then
			local v28 = timestamp + v27

			if isUserEligibleForUnifiedPurchaseFlow then
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
			else
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
			end

			AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(v28)))
			AppStorageService:Flush()
		end

		return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
	end):catch(function(_) -- line: 86
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end

return getIsUserEligibleForUnifiedPurchaseFlow
