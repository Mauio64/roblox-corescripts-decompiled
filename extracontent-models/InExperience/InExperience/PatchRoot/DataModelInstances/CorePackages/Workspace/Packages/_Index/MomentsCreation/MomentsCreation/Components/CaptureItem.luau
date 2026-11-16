local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Checkbox = Foundation.Checkbox
local Text = Foundation.Text
local View = Foundation.View

local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local getCaptureContent = require(MomentsCreation.Capture.getCaptureContent)
local getFormatTime = require(MomentsCreation.Utils.getFormatTime)

local FFlagMomentsGalleryCaptureOverlayUpdate = require(MomentsCreation.Flags.FFlagMomentsGalleryCaptureOverlayUpdate)

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
		local createElement3 = React.createElement
		local v3 = {
			AnchorPoint = Vector2.new(1, 0),
			isChecked = true,
			label = "",
			onActivated = function(_: boolean)
				onActivated()
			end,
			Position = UDim2.fromScale(1, 0),
			size = 0
		}
		local size

		if FFlagMomentsGalleryCaptureOverlayUpdate then
			size = Foundation.Enums.InputSize.XSmall
		else
			size = Foundation.Enums.InputSize.Small
		end

		v3.size = size
		selectedIndicator = createElement3(Checkbox, v3)
	end

	local timeLengthShadow

	if FFlagMomentsGalleryCaptureOverlayUpdate and props.capture.CaptureType == Enum.CaptureType.Video then
		timeLengthShadow = React.createElement(Text, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, 0, 1, 1),
			tag = "auto-xy text-label-medium",
			Text = getFormatTime(props.capture.TimeLength),
			textStyle = v.Color.Common.Shadow,
			ZIndex = 1
		})
	end

	local timeLength

	if props.capture.CaptureType == Enum.CaptureType.Video then
		timeLength = React.createElement(Text, {
			tag = "position-bottom-right anchor-bottom-right auto-xy text-label-medium content-emphasis",
			Text = getFormatTime(props.capture.TimeLength),
			ZIndex = FFlagMomentsGalleryCaptureOverlayUpdate and 2 or nil
		})
	end

	children.Overlay = createElement2(View, {
		tag = {
			["size-full padding-small"] = FFlagMomentsGalleryCaptureOverlayUpdate,
			["size-full padding-medium"] = not FFlagMomentsGalleryCaptureOverlayUpdate
		},
		ZIndex = 3
	}, {
		SelectedIndicator = selectedIndicator,
		TimeLengthShadow = timeLengthShadow,
		TimeLength = timeLength
	})

	children.CaptureThumbnail = React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ImageContent = getCaptureContent(props.capture),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1
	})
	return createElement(View, v2, children)
end
