local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)

local OutfitsGrid = require(AvatarSwitcher.Components.OutfitsGrid.OutfitsGrid)
local useOutfitsGridProps = require(AvatarSwitcher.Components.OutfitsGrid.useOutfitsGridProps)

local function OutfitsGridContainer()
	local v = useOutfitsGridProps()
	return React.createElement(OutfitsGrid, v)
end

return OutfitsGridContainer
