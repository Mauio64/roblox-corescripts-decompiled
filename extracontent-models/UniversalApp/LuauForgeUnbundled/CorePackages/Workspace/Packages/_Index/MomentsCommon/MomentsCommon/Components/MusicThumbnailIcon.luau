local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")

local image = Foundation.Image
local skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb

local useImageLoadingState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Hooks/useImageLoadingState")

local MusicThumbnailIconSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Enums/MusicThumbnailIconSize")

local v5 = { [MusicThumbnailIconSize.Small] = 24, [MusicThumbnailIconSize.Large] = 40 }

local v6 = { [MusicThumbnailIconSize.Small] = 2, [MusicThumbnailIconSize.Large] = 4 }

return function(p2)
	local rbxThumb = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, p2.assetId)
	local v7 = useImageLoadingState(rbxThumb)
	local v8 = v5[p2.size]

	local createElement = React.createElement
	local v10 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		cornerRadius = UDim.new(0, v6[p2.size]),
		Image = rbxThumb,
		LayoutOrder = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(v8, v8)
	}

	local v12 = if not v7 then React.createElement(skeleton, {
		Size = UDim2.fromScale(1, 1)
	}) else nil
	return createElement(image, v10, { Skeleton = v12 })
end
