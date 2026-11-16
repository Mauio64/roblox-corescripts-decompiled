local SessionService = game:GetService("SessionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local constants = UIBlox.App.Style.Constants

local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServiceTags").AppSessionService
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServices").RoactServices

local SetAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/SetAppLoaded")
local GetAppLoadedStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetAppLoadedStore")
local FFlagAppChatUseSignalsForAppLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForAppLoaded")
local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/EnteredChatFromEntryPoint")

local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/InExperienceAppChatContainer")
local getAllFriendsAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getAllFriendsAsync")
local getLocalUserFriendsCount = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/getLocalUserFriendsCount")
local getLocalUser = UserLib.Thunks.GetLocalUser

local layerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/AppChatToastManagerInExp")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/AppChatPersistentEventReceivers")
local useIsAppChatVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useIsAppChatVisible")
local usePreventExperienceControls = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/usePreventExperienceControls")
local useAppChatUpdateSession = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppChatUpdateSession")
local usePartyChatReactiveFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/usePartyChatReactiveFeatureRestriction")

local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Style")
local uiModeStyleProvider = Style.UiModeStyleProvider
local designTokenProvider = Style.DesignTokenProvider
local module21 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadEventReceiver")
local module22 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadOverlay")

local useParentContainerVisibilitySignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/App/Hooks/useParentContainerVisibilitySignal")
local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local colorMode = Foundation.Enums.ColorMode
local OverlayHost = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/OverlayHost")

local defineFastFlag = game:DefineFastFlag("DebugAppChatDisplayOnJoin", false)
local defineFastInt = game:DefineFastInt("AppChatInExperienceDisplayOrder", 5)
local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagAppChatGateInExpSquadEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatGateInExpSquadEventReceiver")

local getFFlagAppChatInExpToastSnoozeMenuDismissFix = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local partyPageCarouselExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialExperiments").PartyPageCarouselExperimentation
local fFlagEnableAppChatSnoozeMenuFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableAppChatSnoozeMenuFocus
local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab
local isSideSheetEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InExperienceSideSheetUtils/isSideSheetEnabled")
local fFlagSideSheetFocusNav = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSideSheetFocusNav
local fFlagEnableDrawerAnimatingHook = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableDrawerAnimatingHook

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local focusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")

local notificationSnoozeMenuVisibleSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ToastNotification").Signals.NotificationSnoozeMenuVisibleSignal
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy").useAppPolicy
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector

local Drawer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Drawer")
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local useDrawerAnimating = Drawer.Hooks.useDrawerAnimating

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

function LUAUFORGE_MODULE_GLOBALS_ikd_wrapWithFocusRoot(p2, p3, p4)
	return React.createElement(focusRoot, {
		eventHandlers = p3,
		eventMap = navigateBacks,
		isAutoFocusRoot = not fFlagEnableAppChatSnoozeMenuFocus or p4,
		isIsolated = true,
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
	}, p2)
end

function LUAUFORGE_MODULE_GLOBALS_ikd_InExperienceAppChat()
	local ref = React.useRef(nil)
	local v5 = useDispatch()
	local v6, v7 = useIsAppChatVisible(defineFastFlag)
	local v8 = React.useContext(ParentContainerContext)
	local showParentContainer = v8.showParentContainer
	local hideParentContainer = v8.hideParentContainer
	local updateCurrentSquadId = v8.updateCurrentSquadId
	local visibilitySignal = v8.visibilitySignal
	local requestedRouteSignal = v8.requestedRouteSignal
	local getRequestedRoute = v8.getRequestedRoute
	local clearRequestedRoute = v8.clearRequestedRoute
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(getRequestedRoute())
	local state3, setState3 = React.useState(true)
	local v9, v10

	if isSideSheetEnabled and fFlagSideSheetFocusNav and fFlagEnableDrawerAnimatingHook then
		v9 = useDrawerVisible()
		v10 = useDrawerAnimating()
	else
		v9 = nil
		v10 = nil
	end

	useParentContainerVisibilitySignal()
	useAppChatUpdateSession(v6)
	usePreventExperienceControls(v6)

	if fFlagAppChatReactiveFeatureRestrictions then
		usePartyChatReactiveFeatureRestriction(v6)
	end

	React.useEffect(function()
		if v6 then
			if FFlagAppChatUseSignalsForAppLoaded then
				GetAppLoadedStore(false).setAppLoaded(true)
			else
				v5(SetAppLoaded(true))
			end

			v5(getAllFriendsAsync(true))

			if partyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				v5(getLocalUserFriendsCount())
			end
		end
	end, { v5, v6 })

	React.useEffect(function()
		v5(getLocalUser())
	end, { v5 })
	React.useEffect(function()
		local connection = visibilitySignal:connect(function(p2)
			if not p2 and ref.current then
				ref.current.Enabled = false
			end
		end)

		return function()
			connection:disconnect()
		end
	end, { visibilitySignal })

	React.useEffect(function()
		local connection = requestedRouteSignal:connect(function(p2)
			setState2(p2)
		end)

		return function()
			connection:disconnect()
		end
	end, { requestedRouteSignal })

	if getFFlagIsSquadEnabled() then
		local v11 = useSelector(function(p2)
			local currentSquad = p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return ""
		end)

		React.useEffect(function()
			updateCurrentSquadId(v11)
		end, { v11, updateCurrentSquadId })
	end

	local v11

	if getFFlagIsSquadEnabled() then
		v11 = useSelector(function(p2)
			return p2.Squad.SquadPrompt.arguments
		end)
	end

	local v12 = React.useMemo(function()
		local v13 = {}
		v13[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				hideParentContainer()
				object:cancel()
			end)
		}

		return v13
	end, { hideParentContainer })

	local v13 = useAppPolicy(function(p2)
		return p2.getCanAccessParty()
	end)

	local promptType = getFFlagIsSquadEnabled() and v11 and v11.promptType

	if fFlagEnableAppChatSnoozeMenuFocus then
		React.useEffect(function()
			local connection = notificationSnoozeMenuVisibleSignal:connect(function(p2)
				setState3(not p2.visible)
			end)
			return function()
				connection:disconnect()
			end
		end, {})
	end

	local v14 = React.useCallback(function(p2)
		local function openLegacyAppChat()
			showParentContainer()
			setState(p2)
			v5(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastInExp))
		end

		if fFlagExpChatEnableFriendsTab then
			return v8.openFriendsChatConversation(p2):andThen(function(p3)
				if not p3 then
					showParentContainer()
					setState(p2)
					v5(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastInExp))
				end

				return p3
			end)
		end

		showParentContainer()
		setState(p2)
		v5(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastInExp))

		return nil
	end, { v5, v8.openFriendsChatConversation, showParentContainer })

	if isSideSheetEnabled and fFlagSideSheetFocusNav and fFlagEnableDrawerAnimatingHook then
		React.useEffect(function()
			setState3(not (v9 or v10))
		end, { v9, v10 })
	end

	if FFlagAppChatGateInExpSquadEventReceiver then
		v13 = getFFlagIsSquadEnabled() and v13
	end

	local v15 = if v13 then React.createElement(module21) else nil
	local children = {
		SquadEventReceiver = v15,
		AppChatPersistentEventReceivers = React.createElement(module15, {
			isInExperience = true
		}),
		AppChatToastManagerInExp = 0,
		AppChatContainer = 0
	}

	local createElement = React.createElement
	local v18 = if not getFFlagAppChatInExpToastSnoozeMenuDismissFix() then v6 else nil
	local v19 = if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then v6 else nil
	children.AppChatToastManagerInExp = createElement(module14, {
		hideAllChatToasts = v18,
		isAppChatVisible = v19,
		navigateToChat = v14
	})

	local createElement2 = React.createElement
	local v21 = {
		style = { themeName = colorMode.Dark, fontName = constants.FontName.Gotham }
	}

	local createElement3 = React.createElement
	local v26

	if v6 or promptType then
		local createElement4 = React.createElement

		local v28 = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
			DisplayOrder = defineFastInt,
			ref = ref
		}

		local LUAUFORGE_MODULE_GLOBALS_ikd_wrapWithFocusRoot2 = LUAUFORGE_MODULE_GLOBALS_ikd_wrapWithFocusRoot
		local v30 = if promptType then React.createElement(module22) else nil

		local v31 = if v6 then React.createElement(layerCollectorProvider, {}, {
			containerRef = React.createElement(Responsive.ContainerRef.Provider, {
				value = ref
			}, {
				React.createElement(roactServices.ServiceProvider, {
					services = { [appSessionService] = SessionService }
				}, {
					InExperienceAppChatContainer = React.createElement(module11, {
						hideAppChat = v7,
						initialConversationId = state,
						setInitialConversationId = setState,
						requestedRoute = state2,
						clearRequestedRoute = clearRequestedRoute
					})
				})
			})
		}) else nil
		v26 = createElement4(
			"ScreenGui",
			v28,
			LUAUFORGE_MODULE_GLOBALS_ikd_wrapWithFocusRoot2(
				{ SquadOverlay = v30, AppChat = v31 },
				v12,
				state3
			)
		)
	end

	children.AppChatContainer = createElement2(uiModeStyleProvider, v21, {
		createElement3(designTokenProvider, { tokenMappers = {} }, {
			AppChatScreenGui = v26
		})
	})

	children.OverlayHost = React.createElement(OverlayHost, {
		providers = {
			{
				class = Foundation.FoundationProvider,
				props = { colorMode = colorMode.Dark }
			}
		}
	})

	return React.createElement(React.Fragment, {}, children)
end

return LUAUFORGE_MODULE_GLOBALS_ikd_InExperienceAppChat
