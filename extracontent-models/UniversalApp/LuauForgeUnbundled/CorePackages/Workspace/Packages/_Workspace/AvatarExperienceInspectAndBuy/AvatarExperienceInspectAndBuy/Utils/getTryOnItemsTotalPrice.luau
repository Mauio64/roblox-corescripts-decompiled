require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceLineContent")
local getPriceInRobux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/itemDetailsUtils").getPriceInRobux
local getPriceStatusInShop = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatusInShop")
local isPurchasableItem = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/bulkPurchaseUtils").isPurchasableItem
local fFlagAXIaBEnableShopContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXIaBEnableShopContext

local fIntBlackbirdUpsellMinPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SharedFlags").FIntBlackbirdUpsellMinPriceForDiscountInclusive

local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SharedFlags").FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local v5 = { isShopContext = true }

local function getDiscount(p2, p3)
	if p3 ~= PriceStatus.PurchaseFromRoblox then
		return nil
	end

	local discountInformation = p2.discountInformation

	if
		discountInformation
		and discountInformation.totalDiscountAmount
		and discountInformation.totalDiscountAmount > 0
	then
		return discountInformation
	end

	return nil
end

local function isDiscountEligible(p2): boolean
	if p2 == nil then
		return false
	end

	local v6 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive
	return fIntBlackbirdUpsellMinPriceForDiscountInclusive < p2.originalPrice
		and (v6 == 0 or p2.originalPrice < v6)
end

local function classifyPriceStatus(p2, p3)
	if fFlagAXIaBEnableShopContext and p3.isShopContext then
		return getPriceStatusInShop(p2)
	end

	return getPriceStatus(p2, true)
end

local function getTryOnItemsTotalPrice(items, p2)
	local v6 = p2 or v5
	local total = 0
	local total2 = 0
	local count = 0
	local v7 = false
	local v8 = false

	for k, item in items do
		if not item.isEquipped then
			continue
		end

		local itemData = item.itemData
		local v9

		if fFlagAXIaBEnableShopContext and v6.isShopContext then
			v9 = getPriceStatusInShop(itemData)
		else
			v9 = getPriceStatus(itemData, true)
		end

		if not isPurchasableItem(v9) then
			continue
		end

		local v10

		if v9 == PriceStatus.Free then
			v10 = getPriceInRobux(item.itemData, v9) or 0
		else
			v10 = getPriceInRobux(item.itemData, v9)

			if v10 == nil then
				continue
			end
		end

		local itemData2 = item.itemData
		local discountInformation

		if v9 == PriceStatus.PurchaseFromRoblox then
			discountInformation = itemData2.discountInformation

			if not (discountInformation and discountInformation.totalDiscountAmount and discountInformation.totalDiscountAmount > 0) then
				discountInformation = nil
			end
		end

		total += v10

		if discountInformation then
			v10 = discountInformation.originalPrice
		end

		total2 += v10
		local v11

		if discountInformation == nil then
			v11 = false
		else
			local v12 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive

			if fIntBlackbirdUpsellMinPriceForDiscountInclusive < discountInformation.originalPrice then
				v11 = v12 == 0 or discountInformation.originalPrice < v12
			else
				v11 = false
			end
		end

		if v11 then
			v7 = true
		else
			v8 = true
		end

		count += 1
	end

	return {
		totalPrice = total,
		originalPrice = total2,
		itemCount = count,
		hasNonDiscountedItems = v7 and v8
	}
end

return getTryOnItemsTotalPrice
