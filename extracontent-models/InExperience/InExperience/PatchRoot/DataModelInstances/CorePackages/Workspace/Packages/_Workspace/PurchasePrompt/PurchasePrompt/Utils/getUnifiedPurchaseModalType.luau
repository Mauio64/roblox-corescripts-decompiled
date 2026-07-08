local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local SharedFlags = require(PurchasePromptParent.SharedFlags)
local UnifiedPurchaseModalTypeEnum = require(PurchasePromptParent.IAPExperience).Enums.UnifiedPurchaseModalTypeEnum
local isMultiItemPurchase = require(PurchasePrompt.Utils.isMultiItemPurchase)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local function getUnifiedPurchaseModalType(p1) -- line: 14
	-- upvalues: RequestType (copy), UnifiedPurchaseModalTypeEnum (copy), FFlagAXMISWithBlackbird (copy), isMultiItemPurchase (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	if p1 == RequestType.Experience then
		return UnifiedPurchaseModalTypeEnum.Experience
	end

	if FFlagAXMISWithBlackbird and p1 == RequestType.RobuxUpsell then
		return UnifiedPurchaseModalTypeEnum.MultiItem
	end

	if isMultiItemPurchase(p1) then
		return UnifiedPurchaseModalTypeEnum.MultiItem
	end

	if FFlagEnableUnifiedPurchaseFlowForDevSubs and p1 == RequestType.DeveloperSubscription then
		return UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	end

	return UnifiedPurchaseModalTypeEnum.SingleItem
end

return getUnifiedPurchaseModalType
