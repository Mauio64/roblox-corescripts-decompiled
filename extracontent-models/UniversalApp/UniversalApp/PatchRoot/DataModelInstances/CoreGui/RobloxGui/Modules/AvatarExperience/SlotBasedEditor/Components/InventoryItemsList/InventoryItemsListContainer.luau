local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local InventoryItemsList = require(script.Parent.InventoryItemsList)
local useInventoryItemsListProps = require(script.Parent.useInventoryItemsListProps)
local FFlagAXAddInventoryItemsListProps = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAddInventoryItemsListProps

local function InventoryItemsListContainer(p1) -- line: 15
	-- upvalues: FFlagAXAddInventoryItemsListProps (copy), useInventoryItemsListProps (copy), React (copy), InventoryItemsList (copy)
	local v8 = if not FFlagAXAddInventoryItemsListProps then useInventoryItemsListProps() else useInventoryItemsListProps(p1)

	return React.createElement(InventoryItemsList, v8)
end

return React.memo(InventoryItemsListContainer)
