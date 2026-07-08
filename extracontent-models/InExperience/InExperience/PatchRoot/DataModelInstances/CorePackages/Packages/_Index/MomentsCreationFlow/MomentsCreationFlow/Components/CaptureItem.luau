local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Checkbox = Foundation.Checkbox
local FoundationText = Foundation.Text
local View = Foundation.View
local GradientBackdrop = MomentsCommon.GradientBackdrop
local getContentFromCapture = require(MomentsCreationFlow.Utils.getContentFromCapture)
local getFormatTime = MomentsCommon.Utils.getFormatTime
local useCallback = React.useCallback
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useTokens (copy), useCallback (copy), React (copy), View (copy), Foundation (copy), GradientBackdrop (copy), Checkbox (copy), FoundationText (copy), getFormatTime (copy), getContentFromCapture (copy)
	local v15 = useTokens()
	local v16 = useCallback(function() -- line: 32
		-- upvalues: t1 (copy)
		t1.onActivated(t1.capture)
	end, {
		t1.capture,
		t1.onActivated
	})

	return React.createElement(View, {
		tag = "size-full",
		onActivated = v16,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		ZIndex = t1.zIndex
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 270,
			startingTransparency = 0.6,
			zIndex = 2,
			anchorPoint = Vector2.new(0, 1),
			color3 = v15.Color.Common.Scrim.Color3,
			position = UDim2.fromScale(0, 1),
			size = UDim2.fromScale(1, 1)
		}),
		Overlay = React.createElement(View, {
			tag = "padding-medium size-full",
			ZIndex = 3
		}, {
			SelectedIndicator = if not t1.selected then nil else React.createElement(Checkbox, {
				isChecked = true,
				AnchorPoint = Vector2.new(1, 0),
				onActivated = v16,
				Position = UDim2.fromScale(1, 0),
				size = Foundation.Enums.InputSize.Small
			}),
			TimeLength = if t1.capture.CaptureType ~= Enum.CaptureType.Video then nil else React.createElement(FoundationText, {
				tag = "anchor-bottom-right auto-xy content-emphasis position-bottom-right text-label-medium",
				Text = getFormatTime(t1.capture.TimeLength)
			})
		}),
		CaptureThumbnail = React.createElement("ImageLabel", {
			BorderSizePixel = 0,
			ZIndex = 1,
			ImageContent = getContentFromCapture(t1.capture),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
