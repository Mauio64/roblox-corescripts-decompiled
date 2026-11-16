local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(parent.AXCommon)
require(AvatarExperienceInspectAndBuy.Types)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
require(AvatarExperienceInspectAndBuy.Utils.getPriceLineContent)
local itemDetailsUtils = require(AvatarExperienceInspectAndBuy.Utils.itemDetailsUtils)
local getPriceInRobux = itemDetailsUtils.getPriceInRobux
local getPriceStatusInShop = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop)
local bulkPurchaseUtils = require(AvatarExperienceInspectAndBuy.Utils.bulkPurchaseUtils)
local isPurchasableItem = bulkPurchaseUtils.isPurchasableItem
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXIaBEnableShopContext = AvatarExperienceFlags.FFlagAXIaBEnableShopContext

local SharedFlags = require(parent.SharedFlags)
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive

local SharedFlags2 = require(parent.SharedFlags)
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags2.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local v = { isShopContext = true }

local function getDiscount(itemData, p) -- 1 equivalent call inferred from this helper
	if p ~= PriceStatus.PurchaseFromRoblox then
		return nil
	end

	local discountInformation = itemData.discountInformation

	if
		discountInformation
		and discountInformation.totalDiscountAmount
		and discountInformation.totalDiscountAmount > 0
	then
		return discountInformation
	end

	return nil
end

local function isDiscountEligible(discount): boolean -- 1 equivalent call inferred from this helper
	if discount == nil then
		return false
	end

	local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = FIntBlackbirdUpsellMaxPriceForDiscountInclusive
	return FIntBlackbirdUpsellMinPriceForDiscountInclusive < discount.originalPrice
		and (fIntBlackbirdUpsellMaxPriceForDiscountInclusive == 0 or discount.originalPrice < fIntBlackbirdUpsellMaxPriceForDiscountInclusive)
end

local function classifyPriceStatus(itemData, p) -- 1 equivalent call inferred from this helper
	if FFlagAXIaBEnableShopContext and p.isShopContext then
		return getPriceStatusInShop(itemData)
	end

	return getPriceStatus(itemData, true)
end

local function getTryOnItemsTotalPrice(items, p)
	local v2 = p or v
	local total = 0
	local total2 = 0
	local count = 0
	local v3 = false
	local v4 = false

	for _, item in items do
		if not item.isEquipped then
			continue
		end

		local v5 = classifyPriceStatus(item.itemData, v2) -- inferred equivalent call

		if not isPurchasableItem(v5) then
			continue
		end

		local v6

		if v5 == PriceStatus.Free then
			v6 = getPriceInRobux(item.itemData, v5) or 0
		else
			v6 = getPriceInRobux(item.itemData, v5)

			if v6 == nil then
				continue
			end
		end

		local discount = getDiscount(item.itemData, v5) -- inferred equivalent call

		total += v6

		if discount then
			v6 = discount.originalPrice
		end

		total2 += v6

		if isDiscountEligible(discount) then -- inferred equivalent call
			v3 = true
		else
			v4 = true
		end

		count += 1
	end

	return {
		totalPrice = total,
		originalPrice = total2,
		itemCount = count,
		hasNonDiscountedItems = v3 and v4
	}
end

return getTryOnItemsTotalPrice
