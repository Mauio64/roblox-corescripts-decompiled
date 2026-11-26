local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local unifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").Enums.UnifiedPurchaseModalTypeEnum
local isMultiItemPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isMultiItemPurchase")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local fFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function getUnifiedPurchaseModalType(p2)
	if p2 == RequestType.Experience then
		return unifiedPurchaseModalTypeEnum.Experience
	end

	if fFlagAXMISWithBlackbird and p2 == RequestType.RobuxUpsell or isMultiItemPurchase(p2) then
		return unifiedPurchaseModalTypeEnum.MultiItem
	end

	if fFlagEnableUnifiedPurchaseFlowForDevSubs and p2 == RequestType.DeveloperSubscription then
		return unifiedPurchaseModalTypeEnum.DeveloperSubscription
	end

	if fFlagLuaAppsEnablePromptVIPServerPurchase and p2 == RequestType.VIPServer then
		return unifiedPurchaseModalTypeEnum.VIPServer
	end

	return unifiedPurchaseModalTypeEnum.SingleItem
end

return getUnifiedPurchaseModalType
