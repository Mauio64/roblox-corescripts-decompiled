local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent

require(InExperienceShopParent.Promise)

local MockShopData = require(InExperienceShop.Mocks.MockShopData)

require(InExperienceShop.Types)

local function fetchShopData() -- line: 12
	-- upvalues: MockShopData (copy)
	return MockShopData.getShopData()
end

return fetchShopData
