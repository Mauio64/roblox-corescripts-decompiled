local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Checkbox = Foundation.Checkbox
local Text = Foundation.Text
local View = Foundation.View

local GradientBackdrop = MomentsCommon.GradientBackdrop

local getContentFromCapture = require(MomentsCreationFlow.Utils.getContentFromCapture)
local getFormatTime = MomentsCommon.Utils.getFormatTime

local useCallback = React.useCallback
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v = useTokens()

	local onActivated = useCallback(function()
		props.onActivated(props.capture)
	end, { props.capture, props.onActivated })

	local createElement = React.createElement
	local v2 = {
		onActivated = onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full",
		ZIndex = props.zIndex
	}
	local children = {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			anchorPoint = Vector2.new(0, 1),
			color3 = v.Color.Common.Scrim.Color3,
			position = UDim2.fromScale(0, 1),
			rotation = 270,
			size = UDim2.fromScale(1, 1),
			startingTransparency = 0.6,
			zIndex = 2
		}),
		Overlay = 0,
		CaptureThumbnail = 0
	}

	local createElement2 = React.createElement
	local selectedIndicator

	if props.selected then
		selectedIndicator = React.createElement(Checkbox, {
			AnchorPoint = Vector2.new(1, 0),
			isChecked = true,
			onActivated = onActivated,
			Position = UDim2.fromScale(1, 0),
			size = Foundation.Enums.InputSize.Small
		})
	end

	local timeLength

	if props.capture.CaptureType == Enum.CaptureType.Video then
		timeLength = React.createElement(Text, {
			tag = "anchor-bottom-right auto-xy content-emphasis position-bottom-right text-label-medium",
			Text = getFormatTime(props.capture.TimeLength)
		})
	end

	children.Overlay = createElement2(View, { tag = "padding-medium size-full", ZIndex = 3 }, {
		SelectedIndicator = selectedIndicator,
		TimeLength = timeLength
	})

	children.CaptureThumbnail = React.createElement("ImageLabel", {
		BorderSizePixel = 0,
		ImageContent = getContentFromCapture(props.capture),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1
	})
	return createElement(View, v2, children)
end
