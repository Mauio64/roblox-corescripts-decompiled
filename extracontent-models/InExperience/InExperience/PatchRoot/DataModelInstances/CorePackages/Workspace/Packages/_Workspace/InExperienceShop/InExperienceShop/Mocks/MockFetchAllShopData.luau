local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent

require(InExperienceShopParent.Promise)
require(InExperienceShop.Types)

local buildShopDataFromWidgets = require(InExperienceShop.Api.buildShopDataFromWidgets)
local multiGetProductInfo = require(InExperienceShop.Api.multiGetProductInfo)
local MockShopItemIds = require(InExperienceShop.Mocks.MockShopItemIds)
local MockMultiGetProductInfo = require(InExperienceShop.Mocks.MockMultiGetProductInfo)
local FFlagShopUseMockMultiGetProductInfo = require(InExperienceShop.Flags.FFlagShopUseMockMultiGetProductInfo)

return {
	fetchAllShopData = function(n1: number?) -- line: 34
		-- upvalues: MockShopItemIds (copy), buildShopDataFromWidgets (copy), FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), multiGetProductInfo (copy)
		local v9 = n1 == nil and 0.5 or n1

		return MockShopItemIds.getShopItemIds(v9):andThen(function(p1) -- line: 36
			-- upvalues: buildShopDataFromWidgets (copy), FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), v9 (copy), multiGetProductInfo (copy)
			return buildShopDataFromWidgets(p1, function(p2) -- line: 37
				-- upvalues: FFlagShopUseMockMultiGetProductInfo (copy), MockMultiGetProductInfo (copy), v9 (copy), multiGetProductInfo (copy)
				if FFlagShopUseMockMultiGetProductInfo then
					return MockMultiGetProductInfo.multiGetProductInfo(p2, v9)
				end

				return multiGetProductInfo(p2)
			end)
		end)
	end,
	fetchShopWidgetsOnly = function(n2: number?) -- line: 52
		-- upvalues: MockShopItemIds (copy), buildShopDataFromWidgets (copy)
		local v11 = n2 == nil and 0.5 or n2

		return MockShopItemIds.getShopItemIds(v11):andThen(function(p3) -- line: 54
			-- upvalues: buildShopDataFromWidgets (copy)
			return buildShopDataFromWidgets(p3, nil)
		end)
	end
}
