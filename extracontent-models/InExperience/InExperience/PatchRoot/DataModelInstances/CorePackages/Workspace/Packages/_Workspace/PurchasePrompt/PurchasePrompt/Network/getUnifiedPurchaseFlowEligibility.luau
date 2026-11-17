local AppStorageService = game:GetService("AppStorageService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local types = require(PurchasePrompt.types)

local productTypeEnum = types.ProductTypeEnum

local SharedFlags = require(parent.SharedFlags)
local FFlagShipUnifiedPurchaseInExperience = SharedFlags.FFlagShipUnifiedPurchaseInExperience

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

local function getUnifiedPurchaseFlowEligibility(p, p2)
	if
		p2 == productTypeEnum.DeveloperSubscription
		or p2 == productTypeEnum.VIPServer
		or FFlagShipUnifiedPurchaseInExperience
	then
		return Promise.resolve(true)
	end

	local v = os.time(os.date("!*t"))
	local unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage = getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- inferred equivalent call

	if
		unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage == -1
		or not (v < unifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage)
	then
		return p.getUnifiedPurchaseFlowUserEligibility():andThen(function(p3)
			if not p3 then
				return Promise.reject(false)
			end

			local unifiedPurchaseFlowMetadata = p3.unifiedPurchaseFlowMetadata
			local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
			local expiresInSeconds = unifiedPurchaseFlowMetadata.expiresInSeconds or 0

			persistUnifiedPurchaseFlowMetadata(isUserEligibleForUnifiedPurchaseFlow, v + expiresInSeconds) -- inferred equivalent call

			return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
		end, function(_)
			return Promise.resolve(false)
		end):catch(function(_)
			return Promise.resolve(false)
		end)
	end

	local unifiedPurchaseFlowIsUserEligibleFromStorage = getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- inferred equivalent call
	return Promise.resolve(unifiedPurchaseFlowIsUserEligibleFromStorage)
end

return getUnifiedPurchaseFlowEligibility
