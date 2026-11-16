local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")

local VirtualizedFeedView = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/VirtualizedFeedView")
local useVirtualizedFeedViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/useVirtualizedFeedViewModel")

local function AssetPickerVirtualizedFeedContainer(p2)
	local v5 = useVirtualizedFeedViewModel(p2)
	return React.createElement(VirtualizedFeedView, v5)
end

return AssetPickerVirtualizedFeedContainer
