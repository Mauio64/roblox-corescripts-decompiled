local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local OutfitsGrid = require(AvatarSwitcher.Components.OutfitsGrid.OutfitsGrid)
local useOutfitsGridProps = require(AvatarSwitcher.Components.OutfitsGrid.useOutfitsGridProps)

local function OutfitsGridContainer() -- line: 14
	-- upvalues: useOutfitsGridProps (copy), React (copy), OutfitsGrid (copy)
	local v7 = useOutfitsGridProps()

	return React.createElement(OutfitsGrid, v7)
end

return OutfitsGridContainer
