local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")

local BackgroundHighlight = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/BackgroundHighlight/BackgroundHighlight")
local useBackgroundHighlightProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/BackgroundHighlight/useBackgroundHighlightProps")

local function BackgroundHighlightContainer(p2)
	local v5 = useBackgroundHighlightProps(p2)
	return React.createElement(BackgroundHighlight, v5)
end

return BackgroundHighlightContainer
