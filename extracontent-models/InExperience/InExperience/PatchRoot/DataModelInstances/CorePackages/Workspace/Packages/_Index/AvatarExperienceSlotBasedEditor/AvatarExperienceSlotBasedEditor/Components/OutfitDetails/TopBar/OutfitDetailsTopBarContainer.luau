local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)

local OutfitDetailsTopBar = require(script.Parent.OutfitDetailsTopBar)
local useOutfitDetailsTopBarProps = require(script.Parent.useOutfitDetailsTopBarProps)

local function OutfitDetailsTopBarContainer(p)
	local v = useOutfitDetailsTopBarProps(p)
	return React.createElement(OutfitDetailsTopBar, v)
end

return OutfitDetailsTopBarContainer
