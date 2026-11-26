local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")

local OutfitDetailsActionBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/ActionBar/OutfitDetailsActionBar")
local useOutfitDetailsActionBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/ActionBar/useOutfitDetailsActionBarProps")

local function OutfitDetailsActionBarContainer(p2)
	local v5 = useOutfitDetailsActionBarProps(p2)
	return React.createElement(OutfitDetailsActionBar, v5)
end

return OutfitDetailsActionBarContainer
