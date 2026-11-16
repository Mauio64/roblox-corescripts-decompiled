local HttpService = game:GetService("HttpService")

local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

require(parent.Promise)
require(InExperienceShop.Types)
local fetchShopItemIds = require(script.Parent.fetchShopItemIds)
local buildShopDataFromWidgets = require(script.Parent.buildShopDataFromWidgets)

local function fetchShopWidgetsOnly()
	return fetchShopItemIds((HttpService:GenerateGUID(false))):andThen(function(p)
		return buildShopDataFromWidgets(p, nil)
	end)
end

return fetchShopWidgetsOnly
