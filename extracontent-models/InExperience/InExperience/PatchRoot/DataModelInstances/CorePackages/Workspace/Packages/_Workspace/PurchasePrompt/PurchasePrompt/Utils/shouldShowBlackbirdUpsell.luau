local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local IAPExperience = require(PurchasePromptParent.IAPExperience)
local getAppFeaturePolicies = require(PurchasePromptParent.UniversalAppPolicy).getAppFeaturePolicies
local DiscountType = IAPExperience.DiscountType
local isRequestTypeHiddenFromBlackbirdUpsell = require(script.Parent.Parent.Utils.BlackbirdUpsellRequestTypeGating).isRequestTypeHiddenFromBlackbirdUpsell
local BlackbirdUpsellImpressionTracker = require(script.Parent.BlackbirdUpsellImpressionTracker)
local SharedFlags = require(PurchasePromptParent.SharedFlags)

require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResaleAndTimedOption)

local FFlagBlackbirdUpsellGateTimedOption = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateTimedOption)
local FFlagBlackbirdUpsellGateResale = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResale)
local FFlagEnableBlackbirdUpsellImpressionGating = SharedFlags.FFlagEnableBlackbirdUpsellImpressionGating
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function shouldShowBlackbirdUpsell(p1, p2, b1: boolean, p3) -- line: 26
	-- upvalues: FFlagBlackbirdUpsellGateTimedOption (copy), FFlagBlackbirdUpsellGateResale (copy), getAppFeaturePolicies (copy), isRequestTypeHiddenFromBlackbirdUpsell (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), DiscountType (copy), FFlagEnableBlackbirdUpsellImpressionGating (copy), BlackbirdUpsellImpressionTracker (copy)
	if b1 then
		return false
	end

	if FFlagBlackbirdUpsellGateTimedOption and p3 then
		local timedOptionDays = p3.timedOptionDays

		if timedOptionDays and timedOptionDays ~= 0 then
			return false
		end
	end

	if FFlagBlackbirdUpsellGateResale and p3 then
		local collectibleItemInstanceId = p3.collectibleItemInstanceId

		if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			return false
		end
	end

	if getAppFeaturePolicies().getDisableBlackbirdEntrypoints() then
		return false
	end

	if p2 and isRequestTypeHiddenFromBlackbirdUpsell(p2) then
		return false
	end

	if p1 then
		local basePriceInRobux = p1.basePriceInRobux
		local v22 = FIntBlackbirdUpsellMaxPriceForDiscountInclusive

		if basePriceInRobux <= FIntBlackbirdUpsellMinPriceForDiscountInclusive or v22 ~= 0 and v22 <= basePriceInRobux then
			return false
		end
	end

	if p1 then
		local discounts = p1.discounts

		if discounts then
			for _, v25 in discounts do
				if v25.type == DiscountType.BlackbirdSubscription or v25.type == DiscountType.RobloxPlusSubscription then
					return false
				end
			end
		end
	end

	if FFlagEnableBlackbirdUpsellImpressionGating and BlackbirdUpsellImpressionTracker.hasReachedMaxImpressions() then
		return false
	end

	return true
end

return shouldShowBlackbirdUpsell
