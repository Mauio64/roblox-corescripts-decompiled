local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb

local useImageLoadingState = require(MomentsCommon.Hooks.useImageLoadingState)

local MusicThumbnailIconSize = require(MomentsCommon.Enums.MusicThumbnailIconSize)

local v = { [MusicThumbnailIconSize.Small] = 24, [MusicThumbnailIconSize.Large] = 40 }

local v2 = { [MusicThumbnailIconSize.Small] = 2, [MusicThumbnailIconSize.Large] = 4 }

return function(p)
	local rbxThumb = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, p.assetId)
	local v3 = useImageLoadingState(rbxThumb)
	local v4 = v[p.size]

	local createElement = React.createElement
	local v5 = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		cornerRadius = UDim.new(0, v2[p.size]),
		Image = rbxThumb,
		LayoutOrder = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(v4, v4)
	}
	local skeleton

	if not v3 then
		skeleton = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
	end

	return createElement(Image, v5, { Skeleton = skeleton })
end
