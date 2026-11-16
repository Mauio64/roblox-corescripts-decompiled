local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")

local OutfitDetailsTopBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/TopBar/OutfitDetailsTopBar")
local useOutfitDetailsTopBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/TopBar/useOutfitDetailsTopBarProps")

local function OutfitDetailsTopBarContainer(p2)
	local v5 = useOutfitDetailsTopBarProps(p2)
	return React.createElement(OutfitDetailsTopBar, v5)
end

return OutfitDetailsTopBarContainer
