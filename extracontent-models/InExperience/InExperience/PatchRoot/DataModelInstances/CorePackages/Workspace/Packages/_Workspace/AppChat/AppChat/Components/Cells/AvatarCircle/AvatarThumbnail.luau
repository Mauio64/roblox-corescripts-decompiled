local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local LoadableImage = UIBlox.App.Loading.LoadableImage

local function AvatarThumbnail(p)
	return React.createElement(LoadableImage, {
		Size = UDim2.fromScale(1, 1),
		Image = p.thumbnail,
		useShimmerAnimationWhileLoading = true,
		showFailedStateWhenLoadingFailed = true,
		cornerRadius = p.cornerRadius
	})
end

return AvatarThumbnail
