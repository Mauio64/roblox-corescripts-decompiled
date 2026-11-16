local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local GuiService = game:GetService("GuiService")

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Knob = Foundation.Knob
local Slider = Foundation.Slider
local View = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useRef = React.useRef
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local FFlagMomentsTextOverlayFontSliderTouchArea = require(MomentsCreation.Flags.FFlagMomentsTextOverlayFontSliderTouchArea)

local FontSizeTouchArea = require(MomentsCreation.Components.TextOverlay.FontSizeTouchArea)
local computeRotatedTrackFraction = require(MomentsCreation.Utils.computeRotatedTrackFraction)

local Constants = require(MomentsCreation.Constants)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local MinFontSize = Constants.TextOverlay.MinFontSize

local TreatmentMaxFontSize = Constants.TextOverlay.TreatmentMaxFontSize

local function toGuiInputPosition(vector2: Vector2, current)
	local screenGui = current:FindFirstAncestorWhichIsA("ScreenGui")

	if screenGui == nil or not screenGui.IgnoreGuiInset then
		return vector2
	end

	local v

	if screenGui.ScreenInsets == Enum.ScreenInsets.DeviceSafeInsets then
		v = Enum.ScreenInsets.DeviceSafeInsets
	else
		v = Enum.ScreenInsets.None
	end

	return vector2 + GuiService:GetInsetArea(v).Min
end

local function VerticalFontSizeSlider(p)
	local controller = p.controller
	local v = useTokens()
	local v2 = useDeviceInsets()

	local v3 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)
			local v3

			if activeSession ~= nil then
				v3 = activeSession.getDraft(p2)
			end

			local v4 = v3 and v3[1]

			if v4 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			return v4.textOverlayStyle.fontSize
		end)
	end, { controller })))

	local onValueChanged = useCallback(function(fontSize: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v4 = draft and draft[1]

		if v4 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v4, {
				textOverlayStyle = { fontSize = fontSize }
			}) })
	end, { controller })

	local onDragStarted = useCallback(function()
		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayFontSizeSliderUsed,
				makeCreationEventFields.makeTextOverlayEventFields()
			)
		end
	end, {})
	local touchAreaRef, onDragStarted2, onDrag

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		touchAreaRef = useRef(nil)

		local v4 = useCallback(function(vector2: Vector2)
			local current = touchAreaRef.current

			if current == nil then
				return
			end

			onValueChanged(MinFontSize + computeRotatedTrackFraction(
				toGuiInputPosition(vector2, current),
				current.AbsolutePosition + current.AbsoluteSize / 2,
				current.AbsoluteSize.X,
				current.AbsoluteRotation
			) * (TreatmentMaxFontSize - MinFontSize))
		end, { onValueChanged })

		onDragStarted2 = useCallback(function(_, vector2: Vector2)
			onDragStarted()
			v4(vector2)
		end, { onDragStarted, v4 })
		onDrag = useCallback(function(_, vector2: Vector2)
			v4(vector2)
		end, { v4 })
	else
		touchAreaRef = nil
	end

	local v4 = math.clamp(p.mediaHeight * 0.45, 140, 320)

	local createElement = React.createElement
	local v5 = {
		tag = {
			["anchor-center-center"] = true,
			["auto-xy"] = not FFlagMomentsTextOverlayFontSliderTouchArea
		},
		Size = 0,
		Position = 0,
		Rotation = -90,
		ZIndex = 10
	}
	local size

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		size = UDim2.fromOffset(v4, 48)
	end

	v5.Size = size

	v5.Position = UDim2.new(1, -(math.max(v2.right, v.Padding.XLarge) + v.Padding.Medium), 0.5, 0)

	local createElement2 = React.createElement
	local v6 = {
		knob = React.createElement(Knob, { size = Foundation.Enums.InputSize.Large }),
		knobVisibility = Foundation.Enums.Visibility.Always,
		onDragStarted = onDragStarted,
		onValueChanged = onValueChanged,
		size = Foundation.Enums.InputSize.XSmall,
		range = NumberRange.new(MinFontSize, TreatmentMaxFontSize),
		value = math.clamp(v3, MinFontSize, TreatmentMaxFontSize),
		variant = Foundation.Enums.SliderVariant.Standard,
		width = UDim.new(0, v4),
		AnchorPoint = 0,
		Position = 0,
		testId = "--social-moments-creation-slider-font-size"
	}
	local anchorPoint

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		anchorPoint = Vector2.new(0.5, 0.5)
	end

	v6.AnchorPoint = anchorPoint
	local position

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		position = UDim2.fromScale(0.5, 0.5)
	end

	v6.Position = position
	local v7 = { Slider = createElement2(Slider, v6), TouchArea = 0 }
	local touchArea

	if FFlagMomentsTextOverlayFontSliderTouchArea then
		touchArea = React.createElement(FontSizeTouchArea, {
			touchAreaRef = touchAreaRef,
			onDragStarted = onDragStarted2,
			onDrag = onDrag,
			ZIndex = 2
		})
	end

	v7.TouchArea = touchArea
	return createElement(View, v5, v7)
end

return VerticalFontSizeSlider
