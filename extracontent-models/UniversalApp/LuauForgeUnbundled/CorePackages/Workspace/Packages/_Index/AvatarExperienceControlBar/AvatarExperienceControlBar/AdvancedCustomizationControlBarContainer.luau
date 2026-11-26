local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")

local useAdvancedCustomizationControlBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/useAdvancedCustomizationControlBarProps")
local BaseControlBarContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/BaseControlBarContainer")

local function AdvancedCustomizationControlBarContainer(p2)
	local v5 = useAdvancedCustomizationControlBarProps(p2)
	return React.createElement(BaseControlBarContainer, {
		config = v5.config,
		onActiveMenuItemChanged = p2.onActiveMenuItemChanged,
		LayoutOrder = p2.LayoutOrder
	})
end

return React.memo(AdvancedCustomizationControlBarContainer)
