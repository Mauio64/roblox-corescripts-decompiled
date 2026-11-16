local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies

local discountType = IAPExperience.DiscountType

local isRequestTypeHiddenFromBlackbirdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/BlackbirdUpsellRequestTypeGating").isRequestTypeHiddenFromBlackbirdUpsell
local BlackbirdUpsellImpressionTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/BlackbirdUpsellImpressionTracker")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagBlackbirdUpsellGateResaleAndTimedOption")
local FFlagBlackbirdUpsellGateTimedOption = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagBlackbirdUpsellGateTimedOption")
local FFlagBlackbirdUpsellGateResale = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagBlackbirdUpsellGateResale")

local fFlagEnableBlackbirdUpsellImpressionGating = SharedFlags.FFlagEnableBlackbirdUpsellImpressionGating
local fFlagBlackbirdUpsellGateResalePurchaseType = SharedFlags.FFlagBlackbirdUpsellGateResalePurchaseType
local fFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment
local fIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function shouldShowBlackbirdUpsell(p2, p3, p4, data, p5): boolean
	if p4 then
		return false
	end

	if FFlagBlackbirdUpsellGateTimedOption and data then
		local timedOptionDays = data.timedOptionDays

		if timedOptionDays and timedOptionDays ~= 0 then
			return false
		end
	end

	if fFlagBlackbirdUpsellGateResalePurchaseType and data and data.isPurchaseFromResale == true then
		return false
	end

	if FFlagBlackbirdUpsellGateResale and data then
		local collectibleItemInstanceId = data.collectibleItemInstanceId

		if collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			return false
		end
	end

	if
		getAppFeaturePolicies().getDisableBlackbirdEntrypoints()
		or p3 and isRequestTypeHiddenFromBlackbirdUpsell(p3)
	then
		return false
	end

	if p2 then
		local basePriceInRobux = p2.basePriceInRobux
		local v5 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive

		if
			basePriceInRobux <= fIntBlackbirdUpsellMinPriceForDiscountInclusive
			or v5 ~= 0 and v5 <= basePriceInRobux
		then
			return false
		end
	end

	if p2 then
		local discounts = p2.discounts

		if discounts then
			for k, discount in discounts do
				if
					discount.type == discountType.BlackbirdSubscription
					or discount.type == discountType.RobloxPlusSubscription
				then
					return false
				end
			end
		end
	end

	if
		fFlagEnableRobuxUpsellPlusButtonExperiment and p5
		or not (fFlagEnableBlackbirdUpsellImpressionGating and BlackbirdUpsellImpressionTracker.hasReachedMaxImpressions())
	then
		return true
	end

	return false
end

return shouldShowBlackbirdUpsell
