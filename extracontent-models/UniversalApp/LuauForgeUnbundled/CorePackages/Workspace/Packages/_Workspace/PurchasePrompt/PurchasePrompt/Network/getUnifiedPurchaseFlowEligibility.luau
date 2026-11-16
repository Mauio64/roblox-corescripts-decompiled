local AppStorageService = game:GetService("AppStorageService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local fFlagShipUnifiedPurchaseInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagShipUnifiedPurchaseInExperience

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

local function getUnifiedPurchaseFlowEligibility(p2, p3)
	if
		p3 == productTypeEnum.DeveloperSubscription
		or p3 == productTypeEnum.VIPServer
		or fFlagShipUnifiedPurchaseInExperience
	then
		return Promise.resolve(true)
	end

	local v5 = os.time(os.date("!*t"))
	local item = tonumber((AppStorageService:GetItem("UnifiedPurchaseFlowExpirationTimeSecondsUTC"))) or -1

	if item == -1 or not (v5 < item) then
		return p2.getUnifiedPurchaseFlowUserEligibility():andThen(function(p4)
			if not p4 then
				return Promise.reject(false)
			end

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
		end, function(p4)
			return Promise.resolve(false)
		end):catch(function(p4)
			return Promise.resolve(false)
		end)
	end

	local v6 = AppStorageService:GetItem("UnifiedPurchaseFlowIsUserEligible") == "true"

	return Promise.resolve(v6)
end

return getUnifiedPurchaseFlowEligibility
