local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

require(parent.React)

local InventoryPagesData = require(AvatarWorkshop.Constants.InventoryPagesData)
require(script.Parent.createPagesNavigator)

local function createInventoryPageRoute(p: string, screen)
	local pageData = InventoryPagesData[p]

	assert(pageData ~= nil, `createInventoryPageRoute: no InventoryPagesData entry for screen "{p}"`)

	return {
		[p] = {
			screen = screen,
			params = { pageData = pageData }
		}
	}
end

return createInventoryPageRoute
