local GuiService = game:GetService("GuiService")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local HoldToPlay = require(parent.HoldToPlay)
local Constants = HoldToPlay.Constants
local AppShortcutBar = require(parent.AppShortcutBar)
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local ButtonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local GamePlayButton = require(parent.GamePlayButton)
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local PlayButtonStates = GamePlayButton.PlayButtonStates
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local SessionType = RobloxAppSessionization.SessionType
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local HoldToPlayLauncher = DiscoveryAnalytics.Constants.Context.HoldToPlayLauncher

require(parent.SduiCoreSystem)
local SduiFocusNavActions = require(ServerDrivenUi.FocusNavigation.SduiFocusNavActions)
local SduiSharedContent = require(parent.SduiSharedContent)
local useSduiReportExperienceLaunched = SduiSharedContent.useSduiReportExperienceLaunched

local function SduiHoldToPlay(props)
	local dependencies = props.sduiContext.dependencies
	local networking = dependencies.networking
	local sessionService = dependencies.sessionService
	local ref = React.useRef(nil)
	local v = useButtonHold(Constants.SIGNAL_HOLD_INTENT_SECONDS, Constants.SIGNAL_HOLD_COMPLETE_SECONDS)

	local v2 = v.holdState == ButtonHoldStateEnum.HOLDING
		or v.holdState == ButtonHoldStateEnum.JUST_PRESSED
		or v.holdState == ButtonHoldStateEnum.COMPLETED
	local v3 = v.holdState == ButtonHoldStateEnum.COMPLETED

	local v4 = AppShortcutBarContext.useDispatchButtonHoldStarted()
	local v5 = AppShortcutBarContext.useDispatchButtonHoldEnded()

	local guiObject = React.useMemo(function()
		if props.guiObject then
			return props.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { props.guiObject })

	local v6 = v.holdState == ButtonHoldStateEnum.HOLDING or v.holdState == ButtonHoldStateEnum.COMPLETED

	React.useEffect(function()
		if v6 then
			local lastInputType = GetInputModeStore(false).getLastInputType(false)

			if props.setDisabledForHold and lastInputType == Responsive.Input.Directional then
				props.setDisabledForHold(true)
			end
		end

		return function()
			if props.setDisabledForHold then
				props.setDisabledForHold(false)
			end
		end
	end, { v6, props.setDisabledForHold })

	React.useEffect(function()
		if ref.current or not v2 then
			if ref.current and not v2 then
				v5(FocusNavigationEventNameEnum.HoldToPlay)
				ref.current = false
			end
		else
			ref.current = true
			v4(FocusNavigationEventNameEnum.HoldToPlay, v.holdProgress)
		end
	end, { v2, v.holdProgress, v4, v5 })

	local v7 = usePlayButtonState(networking, props.universeId)
	local v8 = useOnPlayButtonCallback(props.universeId, nil, HoldToPlayLauncher, nil, nil)

	local v9 = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		props.universeId,
		props.placeId
	)

	React.useEffect(function()
		if v3 then
			local playButtonState = v7.playButtonState
			SetGamePlaySession(sessionService, SessionType.StructuralIdentifier.GamePlayFromHoldToPlay, true)
			v8(playButtonState, v9)

			if v.cancelHold and playButtonState == PlayButtonStates.Playable then
				v.cancelHold()
			end
		end
	end, { v3, v.cancelHold, v7.playButtonState, sessionService, v9, v8 })

	local focusNavActions = React.useMemo(function()
		return {
			keys = { [Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.HoldToPlay },
			events = {
				[FocusNavigationEventNameEnum.HoldToPlay] = { handler = v.eventHandler }
			}
		}
	end, { v.eventHandler })

	return React.createElement(SduiFocusNavActions, {
		focusNavActions = focusNavActions,
		guiObject = guiObject
	})
end

return React.memo(SduiHoldToPlay)
