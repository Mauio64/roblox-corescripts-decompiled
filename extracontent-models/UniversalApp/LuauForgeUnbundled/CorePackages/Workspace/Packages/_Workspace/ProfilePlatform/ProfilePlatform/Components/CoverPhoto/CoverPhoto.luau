local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useScreenSize

local view = Foundation.View

local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Loading.LoadableImage

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local function interpolateHeight(p2, p3, p4)
	return p2 + (p3 - p2) * p4
end

local function CoverPhoto(props)
	local v5 = props.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.Wide
	local v6 = props.profileFormFactorInfo.formFactor == Enums.ProfileFormFactor.PeekView
	local isFullView = props.profileFormFactorInfo.isFullView

	local v7 = useScreenSize()
	local v8 = React.useMemo(function(): number
		if v6 then
			return 393
		end

		return 456
	end, { v6, isFullView, props.peekViewOpenPercent })

	local v9 = React.useMemo(function()
		if v6 and not isFullView then
			return 295 + 98 * props.peekViewOpenPercent
		end

		return v8
	end, { v6, isFullView, props.peekViewOpenPercent, v8 })

	local v10 = v9 - 100
	local v11 = v9 - props.parallaxOffset
	local v12 = v10 - props.parallaxOffset

	local v13 = if isFullView then UDim.new(0, v7.X) else UDim.new(1, 0)
	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			Size = UDim2.new(v13, UDim.new(0, v10)),
			ZIndex = -1
		},
		{
			ParallaxWrapper = React.createElement(
				view,
				{
					Size = UDim2.new(1, 0, 0, v12),
					Position = UDim2.new(0, 0, 0, props.parallaxOffset)
				},
				{
					CoverPhotoWrapper = React.createElement(
						view,
						{ Size = UDim2.new(1, 0, 0, v11), ClipsDescendants = true },
						{
							CoverPhoto = React.createElement(loadableImage, {
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundTransparency = 1,
								Image = props.coverPhotoThumbnail,
								Position = UDim2.fromScale(0.5, 0.5),
								ScaleType = Enum.ScaleType.Crop,
								Size = UDim2.new(1, 0, 0, v8),
								useShimmerAnimationWhileLoading = true
							})
						}
					),
					GradientWrapper = React.createElement(view, {
						Size = UDim2.new(1, 0, 0, 100),
						Position = UDim2.new(0, 0, 0, v12),
						tag = (v5 or isFullView) and "bg-surface-0" or "bg-surface-100"
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
