local AppStorageService = game:GetService("AppStorageService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Promise = require(PurchasePrompt.Promise)
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local FFlagShipUnifiedPurchaseInExperience = require(PurchasePromptParent.SharedFlags).FFlagShipUnifiedPurchaseInExperience

local function getUnifiedPurchaseFlowIsUserEligibleFromStorage() -- line: 14
	-- upvalues: AppStorageService (copy)
	return AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"
end
local function getUnifiedPurchaseFlowExpirationTimeSecondsUTCFromStorage() -- line: 19
	-- upvalues: AppStorageService (copy)
	return tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1
end
local function persistUnifiedPurchaseFlowMetadata(b1: boolean, n1: number) -- line: 24
	-- upvalues: AppStorageService (copy)
	if b1 then
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
	else
		AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
	end

	AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(n1)))
	AppStorageService:Flush()
end
local function getUnifiedPurchaseFlowEligibility(p1, p2) -- line: 36
	-- upvalues: ProductTypeEnum (copy), Promise (copy), FFlagShipUnifiedPurchaseInExperience (copy), AppStorageService (copy)
	if p2 == ProductTypeEnum.DeveloperSubscription then
		return Promise.resolve(true)
	end

	if FFlagShipUnifiedPurchaseInExperience then
		return Promise.resolve(true)
	end

	local timestamp = os.time(os.date("!*t"))
	local v16 = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

	if v16 ~= -1 and timestamp < v16 then
		local v17 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

		return Promise.resolve(v17)
	end

	return p1.getUnifiedPurchaseFlowUserEligibility():andThen(function(p3) -- line: 54
		-- upvalues: Promise (copy), timestamp (copy), AppStorageService (copy)
		if not p3 then
			return Promise.reject(false)
		end

		local unifiedPurchaseFlowMetadata = p3.unifiedPurchaseFlowMetadata
		local isUserEligibleForUnifiedPurchaseFlow = unifiedPurchaseFlowMetadata.isUserEligibleForUnifiedPurchaseFlow
		local v21 = unifiedPurchaseFlowMetadata.expiresInSeconds or 0
		local v22 = timestamp + v21

		if isUserEligibleForUnifiedPurchaseFlow then
			AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "true")
		else
			AppStorageService:SetItem("UnifiedPurchaseFlowIsUserEligible", "false")
		end

		AppStorageService:SetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC", (tostring(v22)))
		AppStorageService:Flush()

		return Promise.resolve(isUserEligibleForUnifiedPurchaseFlow)
	end, function(_) -- line: 67
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end):catch(function(_) -- line: 71
		-- upvalues: Promise (copy)
		return Promise.resolve(false)
	end)
end

return getUnifiedPurchaseFlowEligibility
