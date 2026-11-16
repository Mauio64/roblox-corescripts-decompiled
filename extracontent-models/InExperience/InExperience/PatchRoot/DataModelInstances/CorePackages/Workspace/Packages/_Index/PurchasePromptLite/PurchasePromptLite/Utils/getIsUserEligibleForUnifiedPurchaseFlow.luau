local AppStorageService = game:GetService("AppStorageService")

local parent = script:FindFirstAncestor("PurchasePromptLite").Parent
local Http = require(parent.Http)
local Url = Http.Url
local Promise = require(parent.Promise)

local function APIGetRobloxSubscriptionMetadata(callback)
	if callback == nil then
		return Promise.reject()
	end

	return callback(string.format("%sroblox-subscriptions/v1/metadata", Url.APIS_URL), "GET"):andThen(function(p)
		return Promise.resolve(p.responseBody)
	end, function(p)
		return Promise.reject(p)
	end)
end

local function getUnifiedPurchaseFlowIsUserEligibleFromStorage(): boolean -- 1 equivalent call inferred from this helper
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end

local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- 1 equivalent call inferred from this helper
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end

local function persistUnifiedPurchaseFlowMetadata(isUserEligibleForUnifiedPurchaseFlow: boolean, p: number) -- 1 equivalent call inferred from this helper
	if isUserEligibleForUnifiedPurchaseFlow then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(p)))

	AppStorageService:Flush()
end

local function getIsUserEligibleForUnifiedPurchaseFlow(p, p2: string?)
	if p2 == "DeveloperSubscription" then
		return Promise.resolve(true)
	end

	local v = os.time(os.date("!*t"))
	local unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage = getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- inferred equivalent call

	if
		unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage == -1
		or not (v < unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage)
	then
		return APIGetRobloxSubscriptionMetadata(p):andThen(function(p3)
			local unifiedPurchaseFlowMetadata = p3.unifiedPurchaseFlowMetadata
			local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
			persistUnifiedPurchaseFlowMetadata( -- inferred equivalent call
				isUserEligibleForUnifiedPurchaseFlow,
				v + (unifiedPurchaseFlowMetadata.expiresInSeconds or 0)
			)

			return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
		end):catch(function(_)
			return Promise.resolve(false)
		end)
	end

	local unifiedPurchaseFlowIsUserEligibleFromStorage = getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- inferred equivalent call
	return Promise.resolve(unifiedPurchaseFlowIsUserEligibleFromStorage)
end

return getIsUserEligibleForUnifiedPurchaseFlow
