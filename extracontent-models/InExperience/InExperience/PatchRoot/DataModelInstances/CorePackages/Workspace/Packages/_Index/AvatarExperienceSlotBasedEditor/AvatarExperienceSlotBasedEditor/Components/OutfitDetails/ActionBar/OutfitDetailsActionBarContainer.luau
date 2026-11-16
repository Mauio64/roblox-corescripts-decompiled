local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)

local OutfitDetailsActionBar = require(script.Parent.OutfitDetailsActionBar)
local useOutfitDetailsActionBarProps = require(script.Parent.useOutfitDetailsActionBarProps)

local function OutfitDetailsActionBarContainer(p)
	local v = useOutfitDetailsActionBarProps(p)
	return React.createElement(OutfitDetailsActionBar, v)
end

return OutfitDetailsActionBarContainer
