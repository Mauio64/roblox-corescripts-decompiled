local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local checkbox = Foundation.Checkbox
local text = Foundation.Text
local view = Foundation.View

local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local getCaptureContent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/getCaptureContent")
local getFormatTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/getFormatTime")

local FFlagMomentsGalleryCaptureOverlayUpdate = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsGalleryCaptureOverlayUpdate")

local useCallback = React.useCallback
local useTokens = Foundation.Hooks.useTokens

return function(props)
	local v5 = useTokens()

	local v6 = useCallback(function()
		props.onActivated(props.capture)
	end, { props.capture, props.onActivated })

	local createElement = React.createElement
	local v8 = {
		onActivated = v6,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full",
		ZIndex = props.zIndex
	}
	local children = {
		GradientBackdrop = React.createElement(gradientBackdrop, {
			anchorPoint = Vector2.new(0, 1),
			color3 = v5.Color.Common.Scrim.Color3,
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
	local v12

	if props.selected then
		local createElement3 = React.createElement
		local v14 = {
			AnchorPoint = Vector2.new(1, 0),
			isChecked = true,
			label = "",
			onActivated = function(p2)
				v6()
			end,
			Position = UDim2.fromScale(1, 0),
			size = 0
		}

		local v15 = if FFlagMomentsGalleryCaptureOverlayUpdate then Foundation.Enums.InputSize.XSmall else Foundation.Enums.InputSize.Small
		v14.size = v15
		v12 = createElement3(checkbox, v14)
	end

	local v13 = if FFlagMomentsGalleryCaptureOverlayUpdate and props.capture.CaptureType == Enum.CaptureType.Video then React.createElement(text, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 1),
		tag = "auto-xy text-label-medium",
		Text = getFormatTime(props.capture.TimeLength),
		textStyle = v5.Color.Common.Shadow,
		ZIndex = 1
	}) else nil

	local v14 = if props.capture.CaptureType == Enum.CaptureType.Video then React.createElement(text, {
		tag = "position-bottom-right anchor-bottom-right auto-xy text-label-medium content-emphasis",
		Text = getFormatTime(props.capture.TimeLength),
		ZIndex = FFlagMomentsGalleryCaptureOverlayUpdate and 2 or nil
	}) else nil
	children.Overlay = createElement2(view, {
		tag = {
			["size-full padding-small"] = FFlagMomentsGalleryCaptureOverlayUpdate,
			["size-full padding-medium"] = not FFlagMomentsGalleryCaptureOverlayUpdate
		},
		ZIndex = 3
	}, { SelectedIndicator = v12, TimeLengthShadow = v13, TimeLength = v14 })

	children.CaptureThumbnail = React.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ImageContent = getCaptureContent(props.capture),
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 1
	})
	return createElement(view, v8, children)
end
