local AppStorageService = game:GetService("AppStorageService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/Http").Url
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/Promise")

local function APIGetRobloxSubscriptionMetadata(callback)
	if callback == nil then
		return Promise.reject()
	end

	return callback(string.format("%sroblox-subscriptions/v1/metadata", url.APIS_URL), "GET"):andThen(
		function(p2)
			return Promise.resolve(p2.responseBody)
		end,
		function(p2)
			return Promise.reject(p2)
		end
	)
end

local function getUnifiedPurchaseFlowIsUserEligibleFromStorage(): boolean
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end

local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage()
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end

local function persistUnifiedPurchaseFlowMetadata(p2, p3)
	if p2 then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(p3)))

	AppStorageService:Flush()
end

local function getIsUserEligibleForUnifiedPurchaseFlow(p2, p3)
	if p3 == "DeveloperSubscription" then
		return Promise.resolve(true)
	end

	local v5 = os.time(os.date("!*t"))
	local item = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

	if item == -1 or not (v5 < item) then
		return APIGetRobloxSubscriptionMetadata(p2):andThen(function(p4)
			local unifiedPurchaseFlowMetadata = p4.unifiedPurchaseFlowMetadata
			local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
			local expiresInSeconds = unifiedPurchaseFlowMetadata.expiresInSeconds or 0

			local v6 = v5 + expiresInSeconds

			if isUserEligibleForUnifiedPurchaseFlow then
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
			else
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
			end

			AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(v6)))

			AppStorageService:Flush()

			return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
		end):catch(function(p4)
			return Promise.resolve(false)
		end)
	end

	local v6 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

	return Promise.resolve(v6)
end

return getIsUserEligibleForUnifiedPurchaseFlow
