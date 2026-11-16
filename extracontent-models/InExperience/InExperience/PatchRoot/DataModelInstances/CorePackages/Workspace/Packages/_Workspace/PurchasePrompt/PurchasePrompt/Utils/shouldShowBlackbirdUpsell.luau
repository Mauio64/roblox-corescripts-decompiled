local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local IAPExperience = require(parent.IAPExperience)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local DiscountType = IAPExperience.DiscountType

local BlackbirdUpsellRequestTypeGating = require(script.Parent.Parent.Utils.BlackbirdUpsellRequestTypeGating)
local isRequestTypeHiddenFromBlackbirdUpsell = BlackbirdUpsellRequestTypeGating.isRequestTypeHiddenFromBlackbirdUpsell
local BlackbirdUpsellImpressionTracker = require(script.Parent.BlackbirdUpsellImpressionTracker)

local SharedFlags = require(parent.SharedFlags)
require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResaleAndTimedOption)
local FFlagBlackbirdUpsellGateTimedOption = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateTimedOption)
local FFlagBlackbirdUpsellGateResale = require(PurchasePrompt.Flags.FFlagBlackbirdUpsellGateResale)

local FFlagEnableBlackbirdUpsellImpressionGating = SharedFlags.FFlagEnableBlackbirdUpsellImpressionGating
local FFlagBlackbirdUpsellGateResalePurchaseType = SharedFlags.FFlagBlackbirdUpsellGateResalePurchaseType
local FFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function shouldShowBlackbirdUpsell(p, p2, flag: boolean, data, flag2: boolean?): boolean
	if flag then
		return false
	end

	if FFlagBlackbirdUpsellGateTimedOption and data then
		local timedOptionDays = data.timedOptionDays

		if timedOptionDays and timedOptionDays ~= 0 then
			return false
		end
	end

	if FFlagBlackbirdUpsellGateResalePurchaseType and data and data.isPurchaseFromResale == true then
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
		or p2 and isRequestTypeHiddenFromBlackbirdUpsell(p2)
	then
		return false
	end

	if p then
		local basePriceInRobux = p.basePriceInRobux
		local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = FIntBlackbirdUpsellMaxPriceForDiscountInclusive

		if
			basePriceInRobux <= FIntBlackbirdUpsellMinPriceForDiscountInclusive
			or fIntBlackbirdUpsellMaxPriceForDiscountInclusive ~= 0
			and fIntBlackbirdUpsellMaxPriceForDiscountInclusive <= basePriceInRobux
		then
			return false
		end
	end

	if p then
		local discounts = p.discounts

		if discounts then
			for _, discount in discounts do
				if
					discount.type == DiscountType.BlackbirdSubscription
					or discount.type == DiscountType.RobloxPlusSubscription
				then
					return false
				end
			end
		end
	end

	if
		FFlagEnableRobuxUpsellPlusButtonExperiment and flag2
		or not (FFlagEnableBlackbirdUpsellImpressionGating and BlackbirdUpsellImpressionTracker.hasReachedMaxImpressions())
	then
		return true
	end

	return false
end

return shouldShowBlackbirdUpsell
