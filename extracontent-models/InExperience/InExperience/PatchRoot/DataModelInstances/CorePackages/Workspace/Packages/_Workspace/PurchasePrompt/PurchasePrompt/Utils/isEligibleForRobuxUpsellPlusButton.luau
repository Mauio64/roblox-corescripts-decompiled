local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local IAPExperience = require(parent.IAPExperience)
require(parent.RobloxSubscriptionPurchaseApp)

local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local FFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment
local getBlackbirdUpsellBannerProductInfo = require(script.Parent.getBlackbirdUpsellBannerProductInfo)
local shouldShowBlackbirdUpsell = require(script.Parent.shouldShowBlackbirdUpsell)

local set = {
	[productTypeEnum.Asset] = true,
	[productTypeEnum.Bundle] = true,
	[productTypeEnum.Gamepass] = true,
	[productTypeEnum.Product] = true,
	[productTypeEnum.Look] = true
}

local function isEligibleForRobuxUpsellPlusButton(flag: boolean?, list, p, p2, p3): boolean
	if not flag or (type(list) ~= "table" or #list == 0) then
		return false
	end

	local blackbirdUpsellBannerProductInfo = getBlackbirdUpsellBannerProductInfo(list)

	if
		blackbirdUpsellBannerProductInfo == nil
		or type(blackbirdUpsellBannerProductInfo.initialDiscountPercentage) ~= "number"
		or (type(p2) ~= "table" or type(p2.basePriceInRobux) ~= "number")
	then
		return false
	end

	if type(p) ~= "table" then
		return false
	end

	local kind = p.kind

	if type(kind) ~= "string" or not set[kind] then
		return false
	end

	if shouldShowBlackbirdUpsell(p2, p3, false, p, FFlagEnableRobuxUpsellPlusButtonExperiment and true or nil) then
		return true
	end

	return false
end

return isEligibleForRobuxUpsellPlusButton
