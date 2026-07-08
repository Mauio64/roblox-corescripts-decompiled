local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local BuilderIcons = require(Parent.BuilderIcons)
local Dash = require(Parent.Dash)
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local IconImage = BuilderIcons.Icon.Image
local Icon = Foundation.Icon
local View = Foundation.View
local LoadableVideo = MomentsCommon.LoadableVideo
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), IconImage (copy), LoadableVideo (copy), Dash (copy)
	local v13 = useTokens()

	if not t1.capture then
		return React.createElement(View, {
			tag = "bg-shift-200 radius-large size-full"
		}, {
			EmptyState = React.createElement(Icon, {
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = IconImage,
				Position = UDim2.fromScale(0.5, 0.5),
				size = v13.Size.Size_1200,
				style = v13.Color.Shift.Shift_400
			})
		})
	end

	return React.createElement(View, {
		tag = "size-full"
	}, {
		UIPadding = if t1.scaleType ~= Enum.ScaleType.Fit then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 0)
		}),
		Overlay = React.createElement(React.Fragment, {}, t1.children),
		VideoPreview = if t1.capture.CaptureType ~= Enum.CaptureType.Video then nil else React.createElement(LoadableVideo, {
			Looped = false,
			Playing = true,
			cornerRadius = v13.Radius.Large,
			onLoaded = Dash.noop,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onResolutionChanged = t1.onResolutionChanged,
			renderOnFailed = t1.onRenderFailed,
			Size = UDim2.fromScale(1, 1),
			scaleType = t1.scaleType,
			videoRef = t1.playbackController.videoRef
		}),
		ImagePreview = if t1.capture.CaptureType ~= Enum.CaptureType.Screenshot then nil else React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ref = t1.playbackController.imageRef,
			ScaleType = t1.scaleType,
			Size = UDim2.fromScale(1, 1),
			[React.Change.AbsoluteSize] = t1.onAbsoluteSizeChanged
		})
	})
end
