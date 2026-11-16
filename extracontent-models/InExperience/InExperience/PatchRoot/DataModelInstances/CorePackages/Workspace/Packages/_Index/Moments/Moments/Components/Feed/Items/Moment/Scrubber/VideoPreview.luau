local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)
require(script.Parent.useVideoScrubPreview)

local Skeleton = Foundation.Skeleton
local View = Foundation.View
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function VideoPreview(props)
	local v = useTokens()
	local preview = props.preview

	local mapped = props.animationRatio:map(function(p: number)
		return 1 - p
	end)

	local mapped2 = mapped:map(function(p: number)
		return getColorStyleWithTransparency(v.Color.Shift.Shift_400, p).Transparency or 0
	end)

	local state, setState = React.useState(preview.isLoading)
	local groupTransparency, v2 = ReactOtter.useAnimatedBinding(0, function()
		setState(false)
	end)

	React.useEffect(function()
		if not preview.isLoading then
			v2(ReactOtter.ease(1, { duration = 0.1, easingStyle = Enum.EasingStyle.Quad }))
		end
	end, { preview.isLoading })

	local mapped3 = groupTransparency:map(function(p: number)
		return 1 - p
	end)

	local createElement = React.createElement
	local v3 = {
		tag = "size-2800 radius-medium bg-shift-200",
		aspectRatio = {
			AspectRatio = 0.5625,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		stroke = {
			Color = v.Color.Shift.Shift_400.Color3,
			Transparency = mapped2,
			Thickness = v.Stroke.Thick
		},
		GroupTransparency = mapped,
		LayoutOrder = props.LayoutOrder
	}
	local v4 = {
		FrameA = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ImageTransparency = mapped3,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentA,
			ZIndex = preview.frontIsA:map(function(flag: boolean): number
				return if flag then 2 else 1
			end),
			ref = preview.imageARef
		}),
		FrameB = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ImageTransparency = mapped3,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentB,
			ZIndex = preview.frontIsA:map(function(flag: boolean): number
				return if flag then 1 else 2
			end),
			ref = preview.imageBRef
		}),
		SkeletonOverlay = 0
	}
	local skeletonOverlay

	if state then
		skeletonOverlay = React.createElement(
			View,
			{ tag = "size-full", ZIndex = 3, GroupTransparency = groupTransparency },
			{
				Shimmer = React.createElement(Skeleton, {
					radius = Radius.Medium,
					Size = UDim2.fromScale(1, 1)
				})
			}
		)
	end

	v4.SkeletonOverlay = skeletonOverlay
	return createElement(View, v3, v4)
end

return React.memo(VideoPreview)
