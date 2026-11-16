local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local useCallback = React.useCallback
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local formFactor = MomentsCommon.Enums.FormFactor
local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function useTextFontRowState(p2)
	local v5 = useTokens()
	local v6 = useFormFactor() == formFactor.Wide

	local v8 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = p2.getActiveSession(p3)
			local v8 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v9 = v8 and v8[1]

			if v9 == nil then
				return Enum.Font.BuilderSansMedium
			end

			return v9.textOverlayStyle.font
		end)
	end, { p2 })))

	local v9 = useCallback(function(p3, p4)
		local activeSession = p2.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v10 = draft and draft[1]

		if v10 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v10, {
				textOverlayStyle = { font = p3 }
			}) })

		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				eventNames.EditingFlowTextOverlayFontSelected,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonIndex = tostring(p4),
					font = p3.Name
				})
			)
		end
	end, { p2 })

	local v10 = useRef(nil)
	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	local v11 = useCallback(function(data)
		if data.AbsoluteWindowSize.X == 0 then
			return
		end

		setState(data.CanvasPosition.X > 0)
		setState2(data.AbsoluteWindowSize.X + data.CanvasPosition.X < data.AbsoluteCanvasSize.X - 1)
	end, {})

	local v12 = ReactOtter.useMotor(0, function(p3)
		local current = v10.current

		if current == nil then
			return
		end

		current.CanvasPosition = Vector2.new(p3, 0)
	end)

	local v13 = useCallback(function(p3)
		local current = v10.current

		if current == nil then
			return
		end

		local v14 = math.max(current.AbsoluteCanvasSize.X - current.AbsoluteWindowSize.X, 0)
		local v15 = current.AbsoluteWindowSize.X * 0.8

		local v16 = math.clamp(current.CanvasPosition.X + p3 * v15, 0, v14)
		v12(ReactOtter.ease(v16, {
			duration = v5.Time.Time_200,
			easingStyle = Enum.EasingStyle.Quad,
			startingValue = current.CanvasPosition.X
		}))
	end, { v5, v12 })

	return {
		font = v8,
		onChipActivated = v9,
		scrollingFrameRef = v10,
		onScrollViewportChanged = v11,
		showLeftChevron = v6 and state,
		showRightChevron = v6 and state2,
		onLeftChevronActivated = useCallback(function()
			v13(-1)
		end, { v13 }),
		onRightChevronActivated = useCallback(function()
			v13(1)
		end, { v13 })
	}
end

return useTextFontRowState
