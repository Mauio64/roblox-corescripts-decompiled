local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View
local useCallback = React.useCallback
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")

local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local TextAlignmentButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextAlignmentButton")
local TextColorButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextColorButton")
local TextColorSwatchRow = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextColorSwatchRow")
local TextFontButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextFontButton")
local TextFontRow = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextFontRow")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function TextOverlayToolbar(props)
	local controller = props.controller
	local v5 = useTokens()

	local state, setState = useState(nil)

	local v6 = useCallback(function()
		local v7 = state ~= "Color" and "Color" or nil

		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				eventNames.EditingFlowTextOverlayColorPickerToggled,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonToggled = v7 == nil and "close" or "open"
				})
			)
		end

		setState(v7)
	end, { state })

	local v7 = useCallback(function()
		local v8 = state ~= "Font" and "Font" or nil

		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				eventNames.EditingFlowTextOverlayFontToolbarToggled,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonToggled = v8 == nil and "close" or "open"
				})
			)
		end

		setState(v8)
	end, { state })

	if props.isKeyboardVisible or not fFlagMomentsTextOverlayV2Redesign then
		return nil
	end

	local createElement = React.createElement
	local v9 = {
		tag = "col align-x-center gap-medium position-bottom-center anchor-bottom-center size-full-0 auto-y",
		ZIndex = 10,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		padding = { bottom = UDim.new(0, v5.Padding.Large) }
	}

	local createElement2 = React.createElement
	local v12 = {
		LayoutOrder = 1,
		tag = "row gap-xsmall auto-xy",
		padding = {
			left = UDim.new(0, v5.Padding.Large),
			right = UDim.new(0, v5.Padding.Large)
		}
	}

	local v14 = if fFlagMomentsTextOverlayV2Redesign then React.createElement(TextFontButton, {
		LayoutOrder = 1,
		expanded = state == "Font",
		onToggle = v7
	}) else nil

	local v15 = if fFlagMomentsTextOverlayV2Redesign then React.createElement(TextColorButton, {
		LayoutOrder = 2,
		expanded = state == "Color",
		onToggle = v6
	}) else nil

	local v16 = if fFlagMomentsTextOverlayV2Redesign then React.createElement(TextAlignmentButton, {
		LayoutOrder = 3,
		controller = controller
	}) else nil
	local v10 = {
		IconRow = createElement2(view, v12, {
			FontButton = v14,
			ColorButton = v15,
			AlignmentButton = v16
		}),
		SwatchRow = 0,
		FontRow = 0
	}

	local v17 = if fFlagMomentsTextOverlayV2Redesign and state == "Color" then React.createElement(TextColorSwatchRow, {
		LayoutOrder = 2,
		controller = controller
	}) else nil
	v10.SwatchRow = v17

	local v18 = if fFlagMomentsTextOverlayV2Redesign and state == "Font" then React.createElement(TextFontRow, {
		LayoutOrder = 3,
		controller = controller
	}) else nil
	v10.FontRow = v18
	return createElement(view, v9, v10)
end

return TextOverlayToolbar
