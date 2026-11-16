local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize

local View = Foundation.View

local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage

local Enums = require(ProfilePlatform.Common.Enums)

local function interpolateHeight(p: number, p2: number, p3: number)
	return p + (p2 - p) * p3
end

local function CoverPhoto(props)
	local v = props.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.Wide
	local v2 = props.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.PeekView
	local isFullView = props.profileFormFactorInfo.isFullView

	local v3 = useScreenSize()
	local v4 = React.useMemo(function(): number
		return if v2 then 393 else 456
	end, { v2, isFullView, props.peekViewOpenPercent })

	local v5 = React.useMemo(function()
		if v2 and not isFullView then
			return props.peekViewOpenPercent * 98 + 295
		end

		return v4
	end, { v2, isFullView, props.peekViewOpenPercent, v4 })

	local v6 = v5 - 100
	local v7 = v5 - props.parallaxOffset
	local v8 = v6 - props.parallaxOffset
	local v9

	if isFullView then
		v9 = UDim.new(0, v3.X)
	else
		v9 = UDim.new(1, 0)
	end

	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, Size = UDim2.new(v9, UDim.new(0, v6)), ZIndex = -1 },
		{
			ParallaxWrapper = React.createElement(
				View,
				{
					Size = UDim2.new(1, 0, 0, v8),
					Position = UDim2.new(0, 0, 0, props.parallaxOffset)
				},
				{
					CoverPhotoWrapper = React.createElement(
						View,
						{ Size = UDim2.new(1, 0, 0, v7), ClipsDescendants = true },
						{
							CoverPhoto = React.createElement(LoadableImage, {
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								Image = props.coverPhotoThumbnail,
								Position = UDim2.fromScale(0.5, 0.5),
								ScaleType = Enum.ScaleType.Crop,
								Size = UDim2.new(1, 0, 0, v4),
								useShimmerAnimationWhileLoading = true
							})
						}
					),
					GradientWrapper = React.createElement(View, {
						Size = UDim2.new(1, 0, 0, 100),
						Position = UDim2.new(0, 0, 0, v8),
						tag = (v or isFullView) and "bg-surface-0" or "bg-surface-100"
					}, {
						Gradient = React.createElement("UIGradient", {
							Rotation = 270,
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(0.25, 0),
								NumberSequenceKeypoint.new(0.5, 0.1),
								NumberSequenceKeypoint.new(0.75, 0.5),
								NumberSequenceKeypoint.new(1, 1)
							})
						})
					})
				}
			)
		}
	)
end

return CoverPhoto
