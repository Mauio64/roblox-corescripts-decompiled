local GuiService = game:GetService("GuiService")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Responsive = require(ServerDrivenUiParent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local Constants = require(ServerDrivenUiParent.HoldToPlay).Constants
local AppShortcutBarContext = require(ServerDrivenUiParent.AppShortcutBar).AppShortcutBarContext
local FocusNavigationUtils = require(ServerDrivenUiParent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local GamePlayButton = require(ServerDrivenUiParent.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local RobloxAppSessionization = require(ServerDrivenUiParent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local HoldToPlayLauncher = require(ServerDrivenUiParent.DiscoveryAnalytics).Constants.Context.HoldToPlayLauncher

require(ServerDrivenUiParent.SduiCoreSystem)

local SduiFocusNavActions = require(ServerDrivenUi.FocusNavigation.SduiFocusNavActions)
local useSduiReportExperienceLaunched = require(ServerDrivenUiParent.SduiSharedContent).useSduiReportExperienceLaunched

local function SduiHoldToPlay(t1: {[any]: any}) -- line: 50
	-- upvalues: React (copy), useButtonHold (copy), Constants (copy), ButtonHoldStateEnum (copy), AppShortcutBarContext (copy), GuiService (copy), GetInputModeStore (copy), Responsive (copy), FocusNavigationEventNameEnum (copy), usePlayButtonState (copy), useOnPlayButtonCallback (copy), HoldToPlayLauncher (copy), useSduiReportExperienceLaunched (copy), SetGamePlaySession (copy), SessionType (copy), PlayButtonStates (copy), SduiFocusNavActions (copy)
	local dependencies = t1.sduiContext.dependencies
	local networking = dependencies.networking
	local sessionService = dependencies.sessionService
	local v28 = React.useRef(nil)
	local v29 = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS)
	local v30 = v29.holdState == ButtonHoldStateEnum.HOLDING or (v29.holdState == ButtonHoldStateEnum.JUST_PRESSED or v29.holdState == ButtonHoldStateEnum.COMPLETED)
	local v31 = v29.holdState == ButtonHoldStateEnum.COMPLETED
	local v32 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v33 = AppShortcutBarContext.useDispatchButtonHoldEnded()
	local v34 = React.useMemo(function() -- line: 65
		-- upvalues: t1 (copy), GuiService (copy)
		if t1.guiObject then
			return t1.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { t1.guiObject })
	local v35 = v29.holdState == ButtonHoldStateEnum.HOLDING or v29.holdState == ButtonHoldStateEnum.COMPLETED

	React.useEffect(function() -- line: 76
		-- upvalues: v35 (copy), GetInputModeStore (copy), t1 (copy), Responsive (copy)
		if v35 then
			local v40 = GetInputModeStore(false).getLastInputType(false)

			if t1.setDisabledForHold and v40 == Responsive.Input.Directional then
				t1.setDisabledForHold(true)
			end
		end

		return function() -- line: 84
			-- upvalues: t1 (copy)
			if t1.setDisabledForHold then
				t1.setDisabledForHold(false)
			end
		end
	end, {
		v35,
		t1.setDisabledForHold
	})
	React.useEffect(function() -- line: 96
		-- upvalues: v28 (copy), v30 (copy), v32 (copy), FocusNavigationEventNameEnum (copy), v29 (copy), v33 (copy)
		if not v28.current and v30 then
			v28.current = true
			v32(FocusNavigationEventNameEnum.HoldToPlay, v29.holdProgress)

			return
		end

		if v28.current and not v30 then
			v33(FocusNavigationEventNameEnum.HoldToPlay)
			v28.current = false
		end
	end, {
		v30,
		v29.holdProgress,
		v32,
		v33
	})

	local v36 = usePlayButtonState(networking, t1.universeId)
	local v37 = useOnPlayButtonCallback(t1.universeId, nil, HoldToPlayLauncher, nil, nil)
	local v38 = useSduiReportExperienceLaunched(t1.sduiContext, t1.analyticsContext, t1.universeId, t1.placeId)

	React.useEffect(function() -- line: 112
		-- upvalues: v31 (copy), v36 (copy), SetGamePlaySession (copy), sessionService (copy), SessionType (copy), v37 (copy), v38 (copy), v29 (copy), PlayButtonStates (copy)
		if v31 then
			local playButtonState = v36.playButtonState

			SetGamePlaySession(sessionService, SessionType.StructuralIdentifier.GamePlayFromHoldToPlay, true)
			v37(playButtonState, v38)

			if v29.cancelHold and playButtonState == PlayButtonStates.Playable then
				v29.cancelHold()
			end
		end
	end, {
		v31,
		v29.cancelHold,
		v36.playButtonState,
		sessionService,
		v38,
		v37
	})

	local v39 = React.useMemo(function() -- line: 132
		-- upvalues: FocusNavigationEventNameEnum (copy), v29 (copy)
		return {
			keys = {
				[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToPlay
			},
			events = {
				[FocusNavigationEventNameEnum.HoldToPlay] = {
					handler = v29.eventHandler
				}
			}
		}
	end, { v29.eventHandler })

	return React.createElement(SduiFocusNavActions, {
		focusNavActions = v39,
		guiObject = v34
	})
end

return React.memo(SduiHoldToPlay)
