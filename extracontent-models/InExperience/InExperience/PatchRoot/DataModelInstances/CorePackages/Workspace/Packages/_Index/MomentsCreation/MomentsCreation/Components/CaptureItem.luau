local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Checkbox = Foundation.Checkbox
local FoundationText = Foundation.Text
local View = Foundation.View
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local getCaptureContent = require(MomentsCreation.Capture.getCaptureContent)
local getFormatTime = require(MomentsCreation.Utils.getFormatTime)
local useCallback = React.useCallback
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), useCallback (copy), React (copy), View (copy), Foundation (copy), GradientBackdrop (copy), Checkbox (copy), FoundationText (copy), getFormatTime (copy), getCaptureContent (copy)
	local v15 = useTokens()
	local v16 = useCallback(function() -- line: 37
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
			tag = "size-full padding-medium",
			ZIndex = 3
		}, {
			SelectedIndicator = if not t1.selected then nil else React.createElement(Checkbox, {
				isChecked = true,
				label = "",
				AnchorPoint = Vector2.new(1, 0),
				onActivated = function(_: boolean) -- line: 66
					-- upvalues: v16 (copy)
					v16()
				end,
				Position = UDim2.fromScale(1, 0),
				size = Foundation.Enums.InputSize.Small
			}),
			TimeLength = if t1.capture.CaptureType ~= Enum.CaptureType.Video then nil else React.createElement(FoundationText, {
				tag = "position-bottom-right anchor-bottom-right auto-xy text-label-medium content-emphasis",
				Text = getFormatTime(t1.capture.TimeLength)
			})
		}),
		CaptureThumbnail = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			ImageContent = getCaptureContent(t1.capture),
			ScaleType = Enum.ScaleType.Crop,
			Size = UDim2.fromScale(1, 1)
		})
	})
end
