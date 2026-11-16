local parent = script:FindFirstAncestor("MomentsCreationFlow").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Image = BuilderIcons.Icon.Image

local Icon = Foundation.Icon
local View = Foundation.View

local LoadableVideo = MomentsCommon.LoadableVideo

local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()

	if not props.capture then
		return React.createElement(View, { tag = "bg-shift-200 radius-large size-full" }, {
			EmptyState = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				LayoutOrder = 2,
				name = Image,
				Position = UDim2.fromScale(0.5, 0.5),
				size = v.Size.Size_1200,
				style = v.Color.Shift.Shift_400
			})
		})
	end

	local createElement = React.createElement
	local uiPadding

	if props.scaleType == Enum.ScaleType.Fit then
		uiPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		})
	end

	local v2 = {
		UIPadding = uiPadding,
		Overlay = React.createElement(React.Fragment, {}, props.children),
		VideoPreview = 0,
		ImagePreview = 0
	}
	local videoPreview

	if props.capture.CaptureType == Enum.CaptureType.Video then
		videoPreview = React.createElement(LoadableVideo, {
			cornerRadius = v.Radius.Large,
			Looped = false,
			onLoaded = Dash.noop,
			onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
			onResolutionChanged = props.onResolutionChanged,
			Playing = true,
			renderOnFailed = props.onRenderFailed,
			Size = UDim2.fromScale(1, 1),
			scaleType = props.scaleType,
			videoRef = props.playbackController.videoRef
		})
	end

	v2.VideoPreview = videoPreview
	local imagePreview

	if props.capture.CaptureType == Enum.CaptureType.Screenshot then
		imagePreview = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ref = props.playbackController.imageRef,
			ScaleType = props.scaleType,
			Size = UDim2.fromScale(1, 1),
			[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
		})
	end

	v2.ImagePreview = imagePreview
	return createElement(View, { tag = "size-full" }, v2)
end
