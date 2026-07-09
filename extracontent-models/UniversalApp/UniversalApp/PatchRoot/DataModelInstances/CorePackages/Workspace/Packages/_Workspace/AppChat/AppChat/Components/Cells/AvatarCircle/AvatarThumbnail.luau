local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local LoadableImage = require(Parent.UIBlox).App.Loading.LoadableImage

local function AvatarThumbnail(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), LoadableImage (copy)
	return React.createElement(LoadableImage, {
		useShimmerAnimationWhileLoading = true,
		showFailedStateWhenLoadingFailed = true,
		Size = UDim2.fromScale(1, 1),
		Image = t1.thumbnail,
		cornerRadius = t1.cornerRadius
	})
end

return AvatarThumbnail
