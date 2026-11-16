local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local SharedFlags = require(parent.SharedFlags)
local IAPExperience = require(parent.IAPExperience)
local UnifiedPurchaseModalTypeEnum = IAPExperience.Enums.UnifiedPurchaseModalTypeEnum
local isMultiItemPurchase = require(PurchasePrompt.Utils.isMultiItemPurchase)
local RequestType = require(PurchasePrompt.Enums.RequestType)

local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags2.FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local function getUnifiedPurchaseModalType(p)
	if p == RequestType.Experience then
		return UnifiedPurchaseModalTypeEnum.Experience
	end

	if FFlagAXMISWithBlackbird and p == RequestType.RobuxUpsell or isMultiItemPurchase(p) then
		return UnifiedPurchaseModalTypeEnum.MultiItem
	end

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and p == RequestType.DeveloperSubscription then
		return UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	end

	if FFlagLuaAppsEnablePromptVIPServerPurchase and p == RequestType.VIPServer then
		return UnifiedPurchaseModalTypeEnum.VIPServer
	end

	return UnifiedPurchaseModalTypeEnum.SingleItem
end

return getUnifiedPurchaseModalType
