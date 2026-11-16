local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")

local useBaseControlBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/useBaseControlBarProps")
local BaseControlBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/BaseControlBar")

local function BaseControlBarContainer(p2)
	local v5 = useBaseControlBarProps(p2)
	return React.createElement(BaseControlBar, v5)
end

return React.memo(BaseControlBarContainer)
