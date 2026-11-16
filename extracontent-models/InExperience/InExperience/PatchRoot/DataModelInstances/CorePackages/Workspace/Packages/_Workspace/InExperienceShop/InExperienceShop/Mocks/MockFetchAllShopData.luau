local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

require(parent.Promise)
local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local buildShopDataFromWidgets = require(InExperienceShop.Api.buildShopDataFromWidgets)
local fetchRobuxWidgetsAfterPurchase = require(InExperienceShop.Api.fetchRobuxWidgetsAfterPurchase)
local multiGetProductInfo = require(InExperienceShop.Api.multiGetProductInfo)
local MockShopItemIds = require(InExperienceShop.Mocks.MockShopItemIds)
local MockMultiGetProductInfo = require(InExperienceShop.Mocks.MockMultiGetProductInfo)
local FFlagShopUseMockMultiGetProductInfo = require(InExperienceShop.Flags.FFlagShopUseMockMultiGetProductInfo)
local MockFetchAllShopData = {}

function MockFetchAllShopData.fetchAllShopData(p: number?)
	local v = p == nil and 0.5 or p
	return MockShopItemIds.getShopItemIds(v):andThen(function(p2)
		return buildShopDataFromWidgets(p2, function(p3)
			if FFlagShopUseMockMultiGetProductInfo then
				return MockMultiGetProductInfo.multiGetProductInfo(p3, v)
			end

			return multiGetProductInfo(p3)
		end)
	end)
end

function MockFetchAllShopData.fetchShopWidgetsOnly(p: number?)
	local v = p == nil and 0.5 or p
	return MockShopItemIds.getShopItemIds(v):andThen(function(p2)
		return buildShopDataFromWidgets(p2, nil)
	end)
end

function MockFetchAllShopData.fetchRobuxWidgetsAfterPurchase(p: number?)
	local v = p == nil and 0.5 or p
	return MockShopItemIds.getShopItemIds(v):andThen(function(p2)
		local category2 = nil

		for _, category in ipairs(p2.categories) do
			if category.name == Constants.ROBUX_CATEGORY_NAME then
				category2 = category
				break
			end
		end

		return fetchRobuxWidgetsAfterPurchase.buildFromWidgetResponse({ category = category2 }, function(p3)
			if FFlagShopUseMockMultiGetProductInfo then
				return MockMultiGetProductInfo.multiGetProductInfo(p3, v)
			end

			return multiGetProductInfo(p3)
		end)
	end)
end

return MockFetchAllShopData
