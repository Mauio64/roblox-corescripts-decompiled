local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")

local createInventoryPageStore = require(AvatarWorkshop.Stores.Creators.createInventoryPageStore)
require(AvatarWorkshop.Constants.InventoryPagesData)

local v = {}

local function getInventoryPageStore(p)
	if v[p] then
		return v[p]
	end

	v[p] = createInventoryPageStore(p)
	return v[p]
end

return getInventoryPageStore
