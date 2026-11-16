local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local View = Foundation.View
local useCallback = React.useCallback
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)

local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local TextAlignmentButton = require(MomentsCreation.Components.TextOverlay.TextAlignmentButton)
local TextColorButton = require(MomentsCreation.Components.TextOverlay.TextColorButton)
local TextColorSwatchRow = require(MomentsCreation.Components.TextOverlay.TextColorSwatchRow)
local TextFontButton = require(MomentsCreation.Components.TextOverlay.TextFontButton)
local TextFontRow = require(MomentsCreation.Components.TextOverlay.TextFontRow)

require(MomentsCreation.Types.CreationFlowTypes)

local function TextOverlayToolbar(props)
	local controller = props.controller
	local v = useTokens()

	local state, setState = useState(nil)

	local onToggle = useCallback(function()
		local v2 = state ~= "Color" and "Color" or nil

		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayColorPickerToggled,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonToggled = v2 == nil and "close" or "open"
				})
			)
		end

		setState(v2)
	end, { state })

	local onToggle2 = useCallback(function()
		local v2 = state ~= "Font" and "Font" or nil

		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayFontToolbarToggled,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonToggled = v2 == nil and "close" or "open"
				})
			)
		end

		setState(v2)
	end, { state })

	if props.isKeyboardVisible or not FFlagMomentsTextOverlayV2Redesign then
		return nil
	end

	local createElement = React.createElement
	local v2 = {
		tag = "col align-x-center gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
		ZIndex = 10,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		padding = { bottom = UDim.new(0, v.Padding.Large) }
	}

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = "row gap-xsmall auto-xy",
		padding = { left = UDim.new(0, v.Padding.Large), right = UDim.new(0, v.Padding.Large) }
	}
	local fontButton

	if FFlagMomentsTextOverlayV2Redesign then
		fontButton = React.createElement(TextFontButton, {
			LayoutOrder = 1,
			expanded = state == "Font",
			onToggle = onToggle2
		})
	end

	local colorButton

	if FFlagMomentsTextOverlayV2Redesign then
		colorButton = React.createElement(TextColorButton, {
			LayoutOrder = 2,
			expanded = state == "Color",
			onToggle = onToggle
		})
	end

	local alignmentButton

	if FFlagMomentsTextOverlayV2Redesign then
		alignmentButton = React.createElement(TextAlignmentButton, {
			LayoutOrder = 3,
			controller = controller
		})
	end

	local v4 = {
		IconRow = createElement2(View, v3, {
			FontButton = fontButton,
			ColorButton = colorButton,
			AlignmentButton = alignmentButton
		}),
		SwatchRow = 0,
		FontRow = 0
	}
	local swatchRow

	if FFlagMomentsTextOverlayV2Redesign and state == "Color" then
		swatchRow = React.createElement(TextColorSwatchRow, {
			LayoutOrder = 2,
			controller = controller
		})
	end

	v4.SwatchRow = swatchRow
	local fontRow

	if FFlagMomentsTextOverlayV2Redesign and state == "Font" then
		fontRow = React.createElement(TextFontRow, { LayoutOrder = 3, controller = controller })
	end

	v4.FontRow = fontRow
	return createElement(View, v2, v4)
end

return TextOverlayToolbar
