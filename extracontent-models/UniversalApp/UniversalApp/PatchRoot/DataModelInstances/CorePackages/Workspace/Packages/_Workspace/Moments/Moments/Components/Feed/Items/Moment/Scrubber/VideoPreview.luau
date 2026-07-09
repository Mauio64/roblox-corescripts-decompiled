local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Foundation = require(MomentsParent.Foundation)
local React = require(MomentsParent.React)
local ReactOtter = require(MomentsParent.ReactOtter)
local getColorStyleWithTransparency = require(Moments.Utils.getColorStyleWithTransparency)

require(script.Parent.useVideoScrubPreview)

local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function VideoPreview(t1: {[any]: any}) -- line: 32
	-- upvalues: useTokens (copy), getColorStyleWithTransparency (copy), React (copy), ReactOtter (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v13 = useTokens()
	local preview = t1.preview
	local v15 = t1.animationRatio:map(function(n1: number) -- line: 37
		return 1 - n1
	end)
	local v16 = v15:map(function(n2: number) -- line: 42
		-- upvalues: getColorStyleWithTransparency (copy), v13 (copy)
		return getColorStyleWithTransparency(v13.Color.Shift.Shift_400, n2).Transparency or 0
	end)
	local v17, v18 = React.useState(preview.isLoading)
	local v19, v20 = ReactOtter.useAnimatedBinding(0, function() -- line: 49
		-- upvalues: v18 (copy)
		v18(false)
	end)

	React.useEffect(function() -- line: 53
		-- upvalues: preview (copy), v20 (copy), ReactOtter (copy)
		if not preview.isLoading then
			v20(ReactOtter.ease(1, {
				duration = 0.1,
				easingStyle = Enum.EasingStyle.Quad
			}))
		end
	end, { preview.isLoading })

	local v21 = v19:map(function(n3: number) -- line: 64
		return 1 - n3
	end)

	return React.createElement(View, {
		tag = "size-2800 radius-medium bg-shift-200",
		aspectRatio = {
			AspectRatio = 0.5625,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		},
		stroke = {
			Color = v13.Color.Shift.Shift_400.Color3,
			Transparency = v16,
			Thickness = v13.Stroke.Thick
		},
		GroupTransparency = v15,
		LayoutOrder = t1.LayoutOrder
	}, {
		FrameA = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ImageTransparency = v21,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentA,
			ZIndex = preview.frontIsA:map(function(b1: boolean) -- line: 91
				if b1 then
					return 2
				end

				return 1
			end),
			ref = preview.imageARef
		}),
		FrameB = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ImageTransparency = v21,
			ScaleType = Enum.ScaleType.Crop,
			ImageContent = preview.contentB,
			ZIndex = preview.frontIsA:map(function(b2: boolean) -- line: 102
				if b2 then
					return 1
				end

				return 2
			end),
			ref = preview.imageBRef
		}),
		SkeletonOverlay = if not v17 then nil else React.createElement(View, {
			tag = "size-full",
			ZIndex = 3,
			GroupTransparency = v19
		}, {
			Shimmer = React.createElement(Skeleton, {
				radius = EnumsRadius.Medium,
				Size = UDim2.fromScale(1, 1)
			})
		})
	})
end

return React.memo(VideoPreview)
