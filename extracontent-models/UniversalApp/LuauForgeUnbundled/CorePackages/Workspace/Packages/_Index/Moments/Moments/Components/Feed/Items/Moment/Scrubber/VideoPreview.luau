local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ReactOtter")

local getColorStyleWithTransparency = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getColorStyleWithTransparency")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/Scrubber/useVideoScrubPreview")

local skeleton = Foundation.Skeleton
local view = Foundation.View
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function VideoPreview(props)
	local v5 = useTokens()
	local preview = props.preview

	local mapped = props.animationRatio:map(function(p2)
		return 1 - p2
	end)

	local mapped2 = mapped:map(function(p2)
		return getColorStyleWithTransparency(v5.Color.Shift.Shift_400, p2).Transparency or 0
	end)

	local state, setState = React.useState(preview.isLoading)
	local v6, v7 = ReactOtter.useAnimatedBinding(0, function()
		setState(false)
	end)

	React.useEffect(function()
		if not preview.isLoading then
			v7(ReactOtter.ease(1, { duration = 0.1, easingStyle = Enum.EasingStyle.Quad }))
		end
	end, { preview.isLoading })

	local mapped3 = v6:map(function(p2)
		return 1 - p2
	end)

	local createElement = React.createElement
	local v9 = {
		tag = "size-2800 radius-medium bg-shift-200",
		aspectRatio = {
			AspectRatio = 0.5625,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		stroke = {
			Color = v5.Color.Shift.Shift_400.Color3,
			Transparency = mapped2,
			Thickness = v5.Stroke.Thick
		},
		GroupTransparency = mapped,
		LayoutOrder = props.LayoutOrder
	}
	local v10 = {
		FrameA = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ImageTransparency = mapped3,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentA,
			ZIndex = preview.frontIsA:map(function(p2): number
				if p2 then
					return 2
				end

				return 1
			end),
			ref = preview.imageARef
		}),
		FrameB = React.createElement("ImageLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ImageTransparency = mapped3,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentB,
			ZIndex = preview.frontIsA:map(function(p2): number
				if p2 then
					return 1
				end

				return 2
			end),
			ref = preview.imageBRef
		}),
		SkeletonOverlay = 0
	}

	local v11 = if state then React.createElement(
		view,
		{ tag = "size-full", ZIndex = 3, GroupTransparency = v6 },
		{
			Shimmer = React.createElement(skeleton, {
				radius = radius.Medium,
				Size = UDim2.fromScale(1, 1)
			})
		}
	) else nil
	v10.SkeletonOverlay = v11
	return createElement(view, v9, v10)
end

return React.memo(VideoPreview)
