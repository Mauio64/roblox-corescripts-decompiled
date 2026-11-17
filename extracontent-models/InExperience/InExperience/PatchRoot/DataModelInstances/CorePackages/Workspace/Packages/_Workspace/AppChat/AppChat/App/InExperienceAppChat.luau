local SessionService = game:GetService("SessionService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
require(parent.ReactFocusNavigation)
local Responsive = require(parent.Responsive)
local UIBlox = require(parent.UIBlox)
local UserLib = require(parent.UserLib)
local RoactUtils = require(parent.RoactUtils)
local SocialCommon = require(parent.SocialCommon)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Constants = UIBlox.App.Style.Constants

local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices

local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)
local GetAppLoadedStore = require(AppChat.Stores.GetAppLoadedStore)
local FFlagAppChatUseSignalsForAppLoaded = require(AppChat.Flags.FFlagAppChatUseSignalsForAppLoaded)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)

local InExperienceAppChatContainer = require(AppChat.App.InExperienceAppChatContainer)
local getAllFriendsAsync = require(AppChat.Conversations.Thunks.getAllFriendsAsync)
local getLocalUserFriendsCount = require(AppChat.Conversations.Thunks.getLocalUserFriendsCount)
local GetLocalUser = UserLib.Thunks.GetLocalUser

local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local AppChatToastManagerInExp = require(AppChat.App.AppChatToastManagerInExp)
local AppChatPersistentEventReceivers = require(AppChat.Components.EventReceivers.AppChatPersistentEventReceivers)
local useIsAppChatVisible = require(AppChat.App.Hooks.useIsAppChatVisible)
local usePreventExperienceControls = require(AppChat.App.Hooks.usePreventExperienceControls)
local useAppChatUpdateSession = require(AppChat.Hooks.useAppChatUpdateSession)
local usePartyChatReactiveFeatureRestriction = require(AppChat.Hooks.usePartyChatReactiveFeatureRestriction)

local Style = require(parent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local DesignTokenProvider = Style.DesignTokenProvider
local SquadEventReceiver = require(parent.SquadsCore.SquadEventReceiver)
local SquadOverlay = require(parent.SquadsCore.SquadOverlay)

local useParentContainerVisibilitySignal = require(AppChat.App.Hooks.useParentContainerVisibilitySignal)
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode
local OverlayHost = require(AppChat.Components.OSA.OverlayHost)

local defineFastFlag = game:DefineFastFlag("DebugAppChatDisplayOnJoin", false)
local defineFastInt = game:DefineFastInt("AppChatInExperienceDisplayOrder", 5)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags2.GetFFlagIsSquadEnabled
local FFlagAppChatGateInExpSquadEventReceiver = require(AppChat.Flags.FFlagAppChatGateInExpSquadEventReceiver)

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags3.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local SocialExperiments = require(parent.SocialExperiments)
local PartyPageCarouselExperimentation = SocialExperiments.PartyPageCarouselExperimentation
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableAppChatSnoozeMenuFocus = SharedFlags4.FFlagEnableAppChatSnoozeMenuFocus
local isSideSheetEnabled = require(parent.InExperienceSideSheetUtils.isSideSheetEnabled)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagSideSheetFocusNav = SharedFlags5.FFlagSideSheetFocusNav
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableDrawerAnimatingHook = SharedFlags6.FFlagEnableDrawerAnimatingHook

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(parent.InputHandlers)

local ToastNotification = require(parent.ToastNotification)
local NotificationSnoozeMenuVisibleSignal = ToastNotification.Signals.NotificationSnoozeMenuVisibleSignal
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local Drawer = require(parent.Drawer)
local useDrawerVisible = Drawer.Hooks.useDrawerVisible
local useDrawerAnimating = Drawer.Hooks.useDrawerAnimating

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

function wrapWithFocusRoot(p, eventHandlers, p2)
	return React.createElement(FocusRoot, {
		eventHandlers = eventHandlers,
		eventMap = navigateBacks,
		isAutoFocusRoot = not FFlagEnableAppChatSnoozeMenuFocus or p2,
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, p)
end

function InExperienceAppChat()
	local ref = React.useRef(nil)
	local v = useDispatch()
	local v2, hideAppChat = useIsAppChatVisible(defineFastFlag)
	local v3 = React.useContext(ParentContainerContext)
	local showParentContainer = v3.showParentContainer
	local hideParentContainer = v3.hideParentContainer
	local updateCurrentSquadId = v3.updateCurrentSquadId
	local visibilitySignal = v3.visibilitySignal
	local requestedRouteSignal = v3.requestedRouteSignal
	local getRequestedRoute = v3.getRequestedRoute
	local clearRequestedRoute = v3.clearRequestedRoute
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(getRequestedRoute())
	local state3, setState3 = React.useState(true)
	local v4, v5

	if isSideSheetEnabled and FFlagSideSheetFocusNav and FFlagEnableDrawerAnimatingHook then
		v4 = useDrawerVisible()
		v5 = useDrawerAnimating()
	else
		v4 = nil
		v5 = nil
	end

	useParentContainerVisibilitySignal()
	useAppChatUpdateSession(v2)
	usePreventExperienceControls(v2)

	if FFlagAppChatReactiveFeatureRestrictions then
		usePartyChatReactiveFeatureRestriction(v2)
	end

	React.useEffect(function()
		if v2 then
			if FFlagAppChatUseSignalsForAppLoaded then
				GetAppLoadedStore(false).setAppLoaded(true)
			else
				v(SetAppLoaded(true))
			end

			v(getAllFriendsAsync(true))

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				v(getLocalUserFriendsCount())
			end
		end
	end, { v, v2 })

	React.useEffect(function()
		v(GetLocalUser())
	end, { v })
	React.useEffect(function()
		local connection = visibilitySignal:connect(function(p)
			if not p and ref.current then
				ref.current.Enabled = false
			end
		end)

		return function()
			connection:disconnect()
		end
	end, { visibilitySignal })

	React.useEffect(function()
		local connection = requestedRouteSignal:connect(function(p)
			setState2(p)
		end)

		return function()
			connection:disconnect()
		end
	end, { requestedRouteSignal })

	if GetFFlagIsSquadEnabled() then
		local v6 = useSelector(function(p)
			local currentSquad = p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return ""
		end)

		React.useEffect(function()
			updateCurrentSquadId(v6)
		end, { v6, updateCurrentSquadId })
	end

	local v6

	if GetFFlagIsSquadEnabled() then
		v6 = useSelector(function(p)
			return p.Squad.SquadPrompt.arguments
		end)
	end

	local v7 = React.useMemo(function()
		local v7 = {}
		v7[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				hideParentContainer()
				object:cancel()
			end)
		}

		return v7
	end, { hideParentContainer })

	local v8 = useAppPolicy(function(p)
		return p.getCanAccessParty()
	end)

	local promptType = GetFFlagIsSquadEnabled() and v6 and v6.promptType

	if FFlagEnableAppChatSnoozeMenuFocus then
		React.useEffect(function()
			local connection = NotificationSnoozeMenuVisibleSignal:connect(function(p)
				setState3(not p.visible)
			end)
			return function()
				connection:disconnect()
			end
		end, {})
	end

	local navigateToChat = React.useCallback(function(p: string)
		local function openLegacyAppChat() -- 1 equivalent call inferred from this helper
			showParentContainer()
			setState(p)
			v(EnteredChatFromEntryPoint(SocialCommon.Enums.ChatEntryPointNames.ToastInExp))
		end
		return v3.openFriendsChatConversation(p):andThen(function(p2)
			if not p2 then
				openLegacyAppChat() -- inferred equivalent call
			end

			return p2
		end)
	end, { v, v3.openFriendsChatConversation, showParentContainer })

	if isSideSheetEnabled and FFlagSideSheetFocusNav and FFlagEnableDrawerAnimatingHook then
		React.useEffect(function()
			setState3(not (v4 or v5))
		end, { v4, v5 })
	end

	if FFlagAppChatGateInExpSquadEventReceiver then
		v8 = GetFFlagIsSquadEnabled() and v8
	end

	local squadEventReceiver

	if v8 then
		squadEventReceiver = React.createElement(SquadEventReceiver)
	end

	local children = {
		SquadEventReceiver = squadEventReceiver,
		AppChatPersistentEventReceivers = React.createElement(AppChatPersistentEventReceivers, {
			isInExperience = true
		}),
		AppChatToastManagerInExp = 0,
		AppChatContainer = 0
	}

	local createElement = React.createElement
	local hideAllChatToasts

	if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		hideAllChatToasts = v2
	end

	local isAppChatVisible

	if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
		isAppChatVisible = v2
	end

	children.AppChatToastManagerInExp = createElement(AppChatToastManagerInExp, {
		hideAllChatToasts = hideAllChatToasts,
		isAppChatVisible = isAppChatVisible,
		navigateToChat = navigateToChat
	})

	local createElement2 = React.createElement
	local v9 = {
		style = { themeName = ColorMode.Dark, fontName = Constants.FontName.Gotham }
	}

	local createElement3 = React.createElement
	local appChatScreenGui

	if v2 or promptType then
		local createElement4 = React.createElement

		local v10 = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
			DisplayOrder = defineFastInt,
			ref = ref
		}

		local wrapWithFocusRoot = wrapWithFocusRoot
		local squadOverlay

		if promptType then
			squadOverlay = React.createElement(SquadOverlay)
		end

		local appChat

		if v2 then
			appChat = React.createElement(LayerCollectorProvider, {}, {
				containerRef = React.createElement(Responsive.ContainerRef.Provider, { value = ref }, {
					React.createElement(roactServices.ServiceProvider, {
						services = { [AppSessionService] = SessionService }
					}, {
						InExperienceAppChatContainer = React.createElement(InExperienceAppChatContainer, {
							hideAppChat = hideAppChat,
							initialConversationId = state,
							setInitialConversationId = setState,
							requestedRoute = state2,
							clearRequestedRoute = clearRequestedRoute
						})
					})
				})
			})
		end

		appChatScreenGui = createElement4(
			"ScreenGui",
			v10,
			wrapWithFocusRoot({ SquadOverlay = squadOverlay, AppChat = appChat }, v7, state3)
		)
	end

	children.AppChatContainer = createElement2(UiModeStyleProvider, v9, {
		createElement3(DesignTokenProvider, { tokenMappers = {} }, {
			AppChatScreenGui = appChatScreenGui
		})
	})

	children.OverlayHost = React.createElement(OverlayHost, {
		providers = {
			{
				class = Foundation.FoundationProvider,
				props = { colorMode = ColorMode.Dark }
			}
		}
	})

	return React.createElement(React.Fragment, {}, children)
end

return InExperienceAppChat
