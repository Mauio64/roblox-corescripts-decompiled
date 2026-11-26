local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").App.Loading.LoadableImage

local function AvatarThumbnail(p2)
	return React.createElement(loadableImage, {
		Size = UDim2.fromScale(1, 1),
		Image = p2.thumbnail,
		useShimmerAnimationWhileLoading = true,
		showFailedStateWhenLoadingFailed = true,
		cornerRadius = p2.cornerRadius
	})
end

return AvatarThumbnail
