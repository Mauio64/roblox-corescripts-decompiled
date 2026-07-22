local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local MomentMediaView = require(script.Parent.MomentMediaView)

require(script.Parent.Parent.MediaTypes)

local useVideoPosterFrame = require(script.Parent.Parent.useVideoPosterFrame)
local GetFFlagMomentsTileSkeletonPoster = require(MomentsCommon.Flags.GetFFlagMomentsTileSkeletonPoster)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius

local function MomentMediaTile(t1: {[any]: any}) -- line: 42
	-- upvalues: useVideoPosterFrame (copy), GetFFlagMomentsTileSkeletonPoster (copy), React (copy), MomentMediaView (copy), Skeleton (copy), EnumsRadius (copy)
	local mediaItem = t1.mediaItem
	local cornerRadius = mediaItem.cornerRadius
	local v14 = mediaItem.captureType == Enum.CaptureType.Video
	local v15 = if not v14 then nil else mediaItem.content
	local v16 = useVideoPosterFrame(v15)
	local v17 = if not GetFFlagMomentsTileSkeletonPoster() then v16 or mediaItem.posterContent else if not v14 then mediaItem.posterContent else v16

	if t1.isActive and v14 then
		return React.createElement(MomentMediaView, {
			suppressTapToToggle = true,
			holdPosterUntilPlaying = true,
			tag = "size-full clip",
			momentId = mediaItem.momentId,
			posterContent = v17,
			cornerRadius = cornerRadius
		})
	end

	if GetFFlagMomentsTileSkeletonPoster() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			Shimmer = React.createElement(Skeleton, {
				ZIndex = 1,
				radius = if not cornerRadius then EnumsRadius.None else EnumsRadius.Large,
				Size = UDim2.fromScale(1, 1)
			}),
			Poster = if v17 == nil then nil else React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				ImageContent = v17,
				ScaleType = Enum.ScaleType.Crop
			}, {
				Corner = if cornerRadius == nil then nil else React.createElement("UICorner", {
					CornerRadius = UDim.new(0, cornerRadius)
				})
			})
		})
	end

	return React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ImageContent = v17,
		ScaleType = Enum.ScaleType.Crop
	}, {
		Corner = if cornerRadius == nil then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, cornerRadius)
		})
	})
end

return MomentMediaTile
