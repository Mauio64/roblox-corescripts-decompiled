local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")

local useCustomizeControlBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/useCustomizeControlBarProps")
local BaseControlBarContainer = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/BaseControlBarContainer")

local function CustomizeControlBarContainer(p2)
	local v5 = useCustomizeControlBarProps(p2)
	return React.createElement(BaseControlBarContainer, {
		config = v5.config,
		onActiveMenuItemChanged = p2.onActiveMenuItemChanged,
		LayoutOrder = p2.LayoutOrder
	})
end

return React.memo(CustomizeControlBarContainer)
