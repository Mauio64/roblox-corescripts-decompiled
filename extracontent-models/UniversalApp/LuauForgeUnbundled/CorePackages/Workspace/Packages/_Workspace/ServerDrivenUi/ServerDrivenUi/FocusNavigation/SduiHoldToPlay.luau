local GuiService = game:GetService("GuiService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local getInputModeStore = Responsive.GetInputModeStore
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/HoldToPlay").Constants
local appShortcutBarContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AppShortcutBar").AppShortcutBarContext
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/FocusNavigationUtils")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useButtonHold = FocusNavigationUtils.useButtonHold
local buttonHoldStateEnum = FocusNavigationUtils.ButtonHoldStateEnum
local GamePlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GamePlayButton")
local useOnPlayButtonCallback = GamePlayButton.useOnPlayButtonCallback
local usePlayButtonState = GamePlayButton.usePlayButtonState
local playButtonStates = GamePlayButton.PlayButtonStates
local RobloxAppSessionization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppSessionization")
local setGamePlaySession = RobloxAppSessionization.SetGamePlaySession
local sessionType = RobloxAppSessionization.SessionType
local holdToPlayLauncher = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Constants.Context.HoldToPlayLauncher

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local SduiFocusNavActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/FocusNavigation/SduiFocusNavActions")
local useSduiReportExperienceLaunched = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").useSduiReportExperienceLaunched

local function SduiHoldToPlay(props)
	local dependencies = props.sduiContext.dependencies
	local networking = dependencies.networking
	local sessionService = dependencies.sessionService
	local ref = React.useRef(nil)
	local v5 = useButtonHold(constants.SIGNAL_HOLD_INTENT_SECONDS, constants.SIGNAL_HOLD_COMPLETE_SECONDS)

	local v6 = v5.holdState == buttonHoldStateEnum.HOLDING
		or v5.holdState == buttonHoldStateEnum.JUST_PRESSED
		or v5.holdState == buttonHoldStateEnum.COMPLETED
	local v7 = v5.holdState == buttonHoldStateEnum.COMPLETED

	local v8 = appShortcutBarContext.useDispatchButtonHoldStarted()
	local v9 = appShortcutBarContext.useDispatchButtonHoldEnded()

	local v10 = React.useMemo(function()
		if props.guiObject then
			return props.guiObject
		end

		return GuiService.SelectedCoreObject
	end, { props.guiObject })

	local v11 = v5.holdState == buttonHoldStateEnum.HOLDING or v5.holdState == buttonHoldStateEnum.COMPLETED

	React.useEffect(function()
		if v11 then
			local lastInputType = getInputModeStore(false).getLastInputType(false)

			if props.setDisabledForHold and lastInputType == Responsive.Input.Directional then
				props.setDisabledForHold(true)
			end
		end

		return function()
			if props.setDisabledForHold then
				props.setDisabledForHold(false)
			end
		end
	end, { v11, props.setDisabledForHold })

	React.useEffect(function()
		if ref.current or not v6 then
			if ref.current and not v6 then
				v9(focusNavigationEventNameEnum.HoldToPlay)
				ref.current = false
			end
		else
			ref.current = true
			v8(focusNavigationEventNameEnum.HoldToPlay, v5.holdProgress)
		end
	end, { v6, v5.holdProgress, v8, v9 })

	local v12 = usePlayButtonState(networking, props.universeId)
	local v13 = useOnPlayButtonCallback(props.universeId, nil, holdToPlayLauncher, nil, nil)

	local v14 = useSduiReportExperienceLaunched(
		props.sduiContext,
		props.analyticsContext,
		props.universeId,
		props.placeId
	)

	React.useEffect(function()
		if v7 then
			local playButtonState = v12.playButtonState
			setGamePlaySession(
				sessionService,
				sessionType.StructuralIdentifier.GamePlayFromHoldToPlay,
				true
			)
			v13(playButtonState, v14)

			if v5.cancelHold and playButtonState == playButtonStates.Playable then
				v5.cancelHold()
			end
		end
	end, { v7, v5.cancelHold, v12.playButtonState, sessionService, v14, v13 })

	local v15 = React.useMemo(function()
		return {
			keys = { [Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.HoldToPlay },
			events = {
				[focusNavigationEventNameEnum.HoldToPlay] = {
					handler = v5.eventHandler
				}
			}
		}
	end, { v5.eventHandler })

	return React.createElement(SduiFocusNavActions, { focusNavActions = v15, guiObject = v10 })
end

return React.memo(SduiHoldToPlay)
