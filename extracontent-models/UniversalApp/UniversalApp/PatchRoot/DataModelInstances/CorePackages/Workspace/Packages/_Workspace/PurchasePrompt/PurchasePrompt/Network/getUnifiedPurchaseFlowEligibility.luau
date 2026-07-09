local AppStorageService = game:GetService("AppStorageService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local FFlagUnifiedPurchaseFlowShouldCacheExperimentResult = require(PurchasePromptParent.PurchasePromptLite).FFlagUnifiedPurchaseFlowShouldCacheExperimentResult
local GetFFlagDevSubsEligibleForUnifiedPurchaseFlow = require(PurchasePromptParent.PurchasePromptLite).GetFFlagDevSubsEligibleForUnifiedPurchaseFlow
local FFlagShipUnifiedPurchaseInExperience = require(PurchasePromptParent.SharedFlags).FFlagShipUnifiedPurchaseInExperience

local function getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- line: 18
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end
local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- line: 23
	-- upvalues: AppStorageService (copy)
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end
local function persistUnifiedPurchaseFlowMetadata(b1: boolean, n1: number) -- line: 28
	-- upvalues: AppStorageService (copy)
	if b1 then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(n1)))
	AppStorageService:Flush()
end
local function getUnifiedPurchaseFlowEligibility(p1, p2) -- line: 40
	-- upvalues: GetFFlagDevSubsEligibleForUnifiedPurchaseFlow (copy), ProductTypeEnum (copy), Promise (copy), FFlagShipUnifiedPurchaseInExperience (copy), FFlagUnifiedPurchaseFlowShouldCacheExperimentResult (copy), AppStorageService (copy)
	if GetFFlagDevSubsEligibleForUnifiedPurchaseFlow() and p2 == ProductTypeEnum.DeveloperSubscription then
		return Promise.resolve(true)
	end

	if FFlagShipUnifiedPurchaseInExperience then
		return Promise.resolve(true)
	end

	local timestamp = os.time(os.date("!*t"))

	if FFlagUnifiedPurchaseFlowShouldCacheExperimentResult then
		local v18 = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

		if v18 ~= -1 and timestamp < v18 then
			local v19 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

			return Promise.resolve(v19)
		end
	end

	return p1.getUnifiedPurchaseFlowUserEligibility():andThen(function(p3) -- line: 60
		-- upvalues: Promise (copy), FFlagUnifiedPurchaseFlowShouldCacheExperimentResult (copy), timestamp (copy), AppStorageService (copy)
		if not p3 then
			return Promise.reject(false)
		end

		local unifiedPurchaseFlowMetadata = p3.unifiedPurchaseFlowMetadata
		local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
		local v23 = unifiedPurchaseFlowMetadata.expiresInSeconds or 0

		if FFlagUnifiedPurchaseFlowShouldCacheExperimentResult then
			local v24 = timestamp + v23

			if isUserEligibleForUnifiedPurchaseFlow then
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
			else
				AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
			end

			AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(v24)))
			AppStorageService:Flush()
		end

		return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
	end, function(_) -- line: 75
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end):catch(function(_) -- line: 79
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end

return getUnifiedPurchaseFlowEligibility
