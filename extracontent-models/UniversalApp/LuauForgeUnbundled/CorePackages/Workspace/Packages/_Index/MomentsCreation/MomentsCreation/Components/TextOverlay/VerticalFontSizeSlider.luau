local GuiService = game:GetService("GuiService")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local knob = Foundation.Knob
local slider = Foundation.Slider
local view = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useRef = React.useRef
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local FFlagMomentsTextOverlayFontSliderTouchArea = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayFontSliderTouchArea")

local FontSizeTouchArea = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/FontSizeTouchArea")
local computeRotatedTrackFraction = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/computeRotatedTrackFraction")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local minFontSize = Constants.TextOverlay.MinFontSize

local treatmentMaxFontSize = Constants.TextOverlay.TreatmentMaxFontSize

local function toGuiInputPosition(p2, current)
	local screenGui = current:FindFirstAncestorWhichIsA("ScreenGui")

	if screenGui == nil or not screenGui.IgnoreGuiInset then
		return p2
	end

	local v5

	if screenGui.ScreenInsets == Enum.ScreenInsets.DeviceSafeInsets then
		v5 = Enum.ScreenInsets.DeviceSafeInsets
	else
		v5 = Enum.ScreenInsets.None
	end

	return p2 + GuiService:GetInsetArea(v5).Min
end

local function VerticalFontSizeSlider(p2)
	local controller = p2.controller
	local v5 = useTokens()
	local v6 = useDeviceInsets()

	local v8 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = controller.getActiveSession(p3)
			local v8 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v9 = v8 and v8[1]

			if v9 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			return v9.textOverlayStyle.fontSize
		end)
	end, { controller })))

	local v9 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v10 = draft and draft[1]

		if v10 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v10, {
				textOverlayStyle = { fontSize = p3 }
			}) })
	end, { controller })

	local v10 = useCallback(function()
		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				eventNames.EditingFlowTextOverlayFontSizeSliderUsed,
				makeCreationEventFields.makeTextOverlayEventFields()
			)
		end
	end, {})
	local v11, v12, v13

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		v11 = useRef(nil)

		local v14 = useCallback(function(p3)
			local current = v11.current

			if current == nil then
				return
			end

			v9(minFontSize + computeRotatedTrackFraction(
				toGuiInputPosition(p3, current),
				current.AbsolutePosition + current.AbsoluteSize / 2,
				current.AbsoluteSize.X,
				current.AbsoluteRotation
			) * (treatmentMaxFontSize - minFontSize))
		end, { v9 })

		v12 = useCallback(function(p3, p4)
			v10()
			v14(p4)
		end, { v10, v14 })
		v13 = useCallback(function(p3, p4)
			v14(p4)
		end, { v14 })
	else
		v11 = nil
	end

	local v14 = math.clamp(p2.mediaHeight * 0.45, 140, 320)

	local createElement = React.createElement
	local v16 = {
		tag = {
			["anchor-center-center"] = true,
			["auto-xy"] = not FFlagMomentsTextOverlayFontSliderTouchArea
		},
		Size = 0,
		Position = 0,
		Rotation = -90,
		ZIndex = 10
	}

	local v17 = if FFlagMomentsTextOverlayFontSliderTouchArea then UDim2.fromOffset(v14, 48) else nil
	v16.Size = v17

	v16.Position = UDim2.new(1, -(math.max(v6.right, v5.Padding.XLarge) + v5.Padding.Medium), 0.5, 0)

	local createElement2 = React.createElement
	local v20 = {
		knob = React.createElement(knob, { size = Foundation.Enums.InputSize.Large }),
		knobVisibility = Foundation.Enums.Visibility.Always,
		onDragStarted = v10,
		onValueChanged = v9,
		size = Foundation.Enums.InputSize.XSmall,
		range = NumberRange.new(minFontSize, treatmentMaxFontSize),
		value = math.clamp(v8, minFontSize, treatmentMaxFontSize),
		variant = Foundation.Enums.SliderVariant.Standard,
		width = UDim.new(0, v14),
		AnchorPoint = 0,
		Position = 0,
		testId = "--social-moments-creation-slider-font-size"
	}
	local v21 = if FFlagMomentsTextOverlayFontSliderTouchArea then Vector2.new(0.5, 0.5) else nil
	v20.AnchorPoint = v21
	local v22 = if FFlagMomentsTextOverlayFontSliderTouchArea then UDim2.fromScale(0.5, 0.5) else nil
	v20.Position = v22
	local v18 = { Slider = createElement2(slider, v20), TouchArea = 0 }

	local v23 = if FFlagMomentsTextOverlayFontSliderTouchArea then React.createElement(FontSizeTouchArea, {
		touchAreaRef = v11,
		onDragStarted = v12,
		onDrag = v13,
		ZIndex = 2
	}) else nil
	v18.TouchArea = v23
	return createElement(view, v16, v18)
end

return VerticalFontSizeSlider
