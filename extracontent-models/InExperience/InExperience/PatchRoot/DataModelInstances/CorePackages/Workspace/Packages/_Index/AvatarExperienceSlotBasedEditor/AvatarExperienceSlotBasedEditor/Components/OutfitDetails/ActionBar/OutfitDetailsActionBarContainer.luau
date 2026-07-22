local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local OutfitDetailsActionBar = require(script.Parent.OutfitDetailsActionBar)
local useOutfitDetailsActionBarProps = require(script.Parent.useOutfitDetailsActionBarProps)

local function OutfitDetailsActionBarContainer(p1) -- line: 9
	-- upvalues: useOutfitDetailsActionBarProps (copy), React (copy), OutfitDetailsActionBar (copy)
	local v7 = useOutfitDetailsActionBarProps(p1)

	return React.createElement(OutfitDetailsActionBar, v7)
end

return OutfitDetailsActionBarContainer
