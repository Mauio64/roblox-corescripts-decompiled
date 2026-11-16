local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local useCallback = React.useCallback
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local FormFactor = MomentsCommon.Enums.FormFactor
local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local function useTextFontRowState(p)
	local v = useTokens()
	local v2 = useFormFactor() == FormFactor.Wide

	local font = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = p.getActiveSession(p2)
			local v3

			if activeSession ~= nil then
				v3 = activeSession.getDraft(p2)
			end

			local v4 = v3 and v3[1]

			if v4 == nil then
				return Enum.Font.BuilderSansMedium
			end

			return v4.textOverlayStyle.font
		end)
	end, { p })))

	local onChipActivated = useCallback(function(font2, p2: number)
		local activeSession = p.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v3 = draft and draft[1]

		if v3 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v3, {
				textOverlayStyle = { font = font2 }
			}) })

		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayFontSelected,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonIndex = tostring(p2),
					font = font2.Name
				})
			)
		end
	end, { p })

	local scrollingFrameRef = useRef(nil)
	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	local onScrollViewportChanged = useCallback(function(data)
		if data.AbsoluteWindowSize.X == 0 then
			return
		end

		setState(data.CanvasPosition.X > 0)
		setState2(data.AbsoluteWindowSize.X + data.CanvasPosition.X < data.AbsoluteCanvasSize.X - 1)
	end, {})

	local v3 = ReactOtter.useMotor(0, function(p2)
		local current = scrollingFrameRef.current

		if current == nil then
			return
		end

		current.CanvasPosition = Vector2.new(p2, 0)
	end)

	local v4 = useCallback(function(p2: number)
		local current = scrollingFrameRef.current

		if current == nil then
			return
		end

		local v4 = math.max(current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X, 0)
		local v5 = current.AbsoluteWindowSize.X * 0.8

		local v6 = math.clamp(current.CanvasPosition.X + p2 * v5, 0, v4)
		v3(ReactOtter.ease(v6, {
			duration = v.Time.Time_200,
			easingStyle = Enum.EasingStyle.Quad,
			startingValue = current.CanvasPosition.X
		}))
	end, { v, v3 })

	return {
		font = font,
		onChipActivated = onChipActivated,
		scrollingFrameRef = scrollingFrameRef,
		onScrollViewportChanged = onScrollViewportChanged,
		showLeftChevron = v2 and state,
		showRightChevron = v2 and state2,
		onLeftChevronActivated = useCallback(function()
			v4(-1)
		end, { v4 }),
		onRightChevronActivated = useCallback(function()
			v4(1)
		end, { v4 })
	}
end

return useTextFontRowState
