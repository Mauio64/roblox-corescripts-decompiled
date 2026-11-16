local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp")

local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local fFlagEnableRobuxUpsellPlusButtonExperiment = IAPExperience.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment
local getBlackbirdUpsellBannerProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/getBlackbirdUpsellBannerProductInfo")
local shouldShowBlackbirdUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/shouldShowBlackbirdUpsell")

local set = {
	[productTypeEnum.Asset] = true,
	[productTypeEnum.Bundle] = true,
	[productTypeEnum.Gamepass] = true,
	[productTypeEnum.Product] = true,
	[productTypeEnum.Look] = true
}

local function isEligibleForRobuxUpsellPlusButton(p2, list, p3, p4, p5): boolean
	if not p2 or (type(list) ~= "table" or #list == 0) then
		return false
	end

	local v5 = getBlackbirdUpsellBannerProductInfo(list)

	if
		v5 == nil
		or type(v5.initialDiscountPercentage) ~= "number"
		or (type(p4) ~= "table" or type(p4.basePriceInRobux) ~= "number")
	then
		return false
	end

	if type(p3) ~= "table" then
		return false
	end

	local kind = p3.kind

	if type(kind) ~= "string" or not set[kind] then
		return false
	end

	if shouldShowBlackbirdUpsell(p4, p5, false, p3, fFlagEnableRobuxUpsellPlusButtonExperiment and true or nil) then
		return true
	end

	return false
end

return isEligibleForRobuxUpsellPlusButton
