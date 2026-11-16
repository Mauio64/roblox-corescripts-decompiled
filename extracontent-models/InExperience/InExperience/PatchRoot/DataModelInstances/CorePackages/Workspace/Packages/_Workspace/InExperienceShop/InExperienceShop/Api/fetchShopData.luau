local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

require(parent.Promise)
local MockShopData = require(InExperienceShop.Mocks.MockShopData)
require(InExperienceShop.Types)

local function fetchShopData()
	return MockShopData.getShopData()
end

return fetchShopData
