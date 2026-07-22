local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local OutfitDetailsTopBar = require(script.Parent.OutfitDetailsTopBar)
local useOutfitDetailsTopBarProps = require(script.Parent.useOutfitDetailsTopBarProps)

local function OutfitDetailsTopBarContainer(p1) -- line: 9
	-- upvalues: useOutfitDetailsTopBarProps (copy), React (copy), OutfitDetailsTopBar (copy)
	local v7 = useOutfitDetailsTopBarProps(p1)

	return React.createElement(OutfitDetailsTopBar, v7)
end

return OutfitDetailsTopBarContainer
