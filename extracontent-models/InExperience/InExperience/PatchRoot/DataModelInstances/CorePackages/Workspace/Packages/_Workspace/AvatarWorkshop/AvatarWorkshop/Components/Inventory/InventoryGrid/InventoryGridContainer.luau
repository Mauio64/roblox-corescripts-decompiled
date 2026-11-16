local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)

require(AvatarWorkshop.Constants.InventoryPagesData)
local useNavigation = require(AvatarWorkshop.Hooks.useNavigation)
require(script.Parent.InventoryGridTypes)
local InventoryGridView = require(script.Parent.InventoryGridView)
local useInventoryGridViewModel = require(script.Parent.useInventoryGridViewModel)

local function InventoryGridContainer(_)
	local v = useInventoryGridViewModel({
		pageData = useNavigation().getParam("pageData")
	})
	return React.createElement(InventoryGridView, v)
end

return InventoryGridContainer
