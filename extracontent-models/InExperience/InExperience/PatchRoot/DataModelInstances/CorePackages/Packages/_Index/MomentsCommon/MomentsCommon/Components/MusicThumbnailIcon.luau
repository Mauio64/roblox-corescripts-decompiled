local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local getRbxThumb = Foundation.Utility.getRbxThumb
local useImageLoadingState = require(MomentsCommon.Hooks.useImageLoadingState)
local MusicThumbnailIconSize = require(MomentsCommon.Enums.MusicThumbnailIconSize)
local t1 = {
	[MusicThumbnailIconSize.Small] = 24,
	[MusicThumbnailIconSize.Large] = 40
}
local t2 = {
	[MusicThumbnailIconSize.Small] = 2,
	[MusicThumbnailIconSize.Large] = 4
}

return function(t3: {[any]: any}) -- line: 31
	-- upvalues: getRbxThumb (copy), Foundation (copy), useImageLoadingState (copy), t1 (copy), React (copy), FoundationImage (copy), t2 (copy), Skeleton (copy)
	local v13 = getRbxThumb(Foundation.Enums.ThumbnailType.Asset, t3.assetId)
	local v14 = useImageLoadingState(v13)
	local v15 = t1[t3.size]

	if v14 then
		return React.createElement(FoundationImage, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			cornerRadius = UDim.new(0, t2[t3.size]),
			Image = v13,
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(v15, v15)
		})
	end

	return React.createElement(Skeleton, {
		LayoutOrder = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(v15, v15)
	})
end
