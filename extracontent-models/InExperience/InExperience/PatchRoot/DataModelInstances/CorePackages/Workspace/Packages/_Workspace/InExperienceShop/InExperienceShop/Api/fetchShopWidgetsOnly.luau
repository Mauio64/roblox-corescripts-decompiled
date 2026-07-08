local HttpService = game:GetService("HttpService")
local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent

require(InExperienceShopParent.Promise)
require(InExperienceShop.Types)

local fetchShopItemIds = require(script.Parent.fetchShopItemIds)
local buildShopDataFromWidgets = require(script.Parent.buildShopDataFromWidgets)

local function fetchShopWidgetsOnly() -- line: 30
	-- upvalues: HttpService (copy), fetchShopItemIds (copy), buildShopDataFromWidgets (copy)
	local guid = HttpService:GenerateGUID(false)

	return fetchShopItemIds(guid):andThen(function(p1) -- line: 35
		-- upvalues: buildShopDataFromWidgets (copy)
		return buildShopDataFromWidgets(p1, nil)
	end)
end

return fetchShopWidgetsOnly
