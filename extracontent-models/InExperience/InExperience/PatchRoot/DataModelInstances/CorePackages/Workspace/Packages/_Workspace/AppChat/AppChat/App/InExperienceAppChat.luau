local SessionService = game:GetService("SessionService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)

require(AppChatParent.ReactFocusNavigation)

local Responsive = require(AppChatParent.Responsive)
local UIBlox = require(AppChatParent.UIBlox)
local UserLib = require(AppChatParent.UserLib)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = UIBlox.App.Style.Constants
local AppSessionService = require(AppChatParent.RoactServiceTags).AppSessionService
local RoactServices = require(AppChatParent.RoactServices).RoactServices
local SetAppLoaded = require(AppChat.Actions.SetAppLoaded)
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
local Style = require(AppChatParent.Style)
local UiModeStyleProvider = Style.UiModeStyleProvider
local DesignTokenProvider = Style.DesignTokenProvider
local SquadEventReceiver = require(AppChatParent.SquadsCore.SquadEventReceiver)
local SquadOverlay = require(AppChatParent.SquadsCore.SquadOverlay)
local useParentContainerVisibilitySignal = require(AppChat.App.Hooks.useParentContainerVisibilitySignal)
local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local Foundation = require(AppChatParent.Foundation)
local OverlayHost = require(AppChat.Components.OSA.OverlayHost)
local v32 = game:DefineFastFlag("DebugAppChatDisplayOnJoin", false)
local v33 = game:DefineFastInt("AppChatInExperienceDisplayOrder", 5)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = require(AppChatParent.SharedFlags).GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local FFlagEnableAppChatSnoozeMenuFocus = require(AppChatParent.SharedFlags).FFlagEnableAppChatSnoozeMenuFocus
local getFFlagAppChatRequestedRoute = require(AppChat.Flags.getFFlagAppChatRequestedRoute)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(AppChatParent.InputHandlers)
local NotificationSnoozeMenuVisibleSignal = require(AppChatParent.ToastNotification).Signals.NotificationSnoozeMenuVisibleSignal
local useAppPolicy = require(AppChatParent.UniversalAppPolicy).useAppPolicy
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local v47 = game:DefineFastFlag("AppChatFixCloseVisibilityLinger", false)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

function wrapWithFocusRoot(p1, p2, p3) -- line: 72
	-- upvalues: React (copy), FocusRoot (copy), t1 (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	return React.createElement(FocusRoot, {
		isIsolated = true,
		eventHandlers = p2,
		eventMap = t1,
		isAutoFocusRoot = not FFlagEnableAppChatSnoozeMenuFocus or p3,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, p1)
end
function InExperienceAppChat() -- line: 82
	-- upvalues: React (copy), useDispatch (copy), useIsAppChatVisible (copy), v32 (copy), ParentContainerContext (copy), getFFlagAppChatRequestedRoute (copy), useParentContainerVisibilitySignal (copy), useAppChatUpdateSession (copy), usePreventExperienceControls (copy), SetAppLoaded (copy), getAllFriendsAsync (copy), PartyPageCarouselExperimentation (copy), getLocalUserFriendsCount (copy), GetLocalUser (copy), v47 (copy), GetFFlagIsSquadEnabled (copy), useSelector (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppPolicy (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), NotificationSnoozeMenuVisibleSignal (copy), SquadEventReceiver (copy), AppChatPersistentEventReceivers (copy), AppChatToastManagerInExp (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), UiModeStyleProvider (copy), Constants (copy), DesignTokenProvider (copy), v33 (copy), SquadOverlay (copy), LayerCollectorProvider (copy), Responsive (copy), RoactServices (copy), AppSessionService (copy), SessionService (copy), InExperienceAppChatContainer (copy), OverlayHost (copy), Foundation (copy)
	local v52 = React.useRef(nil)
	local v53 = useDispatch()
	local v54, v55 = useIsAppChatVisible(v32)
	local v56 = React.useContext(ParentContainerContext)
	local showParentContainer = v56.showParentContainer
	local hideParentContainer = v56.hideParentContainer
	local updateCurrentSquadId = v56.updateCurrentSquadId
	local visibilitySignal = v56.visibilitySignal
	local requestedRouteSignal = v56.requestedRouteSignal
	local getRequestedRoute = v56.getRequestedRoute
	local clearRequestedRoute = v56.clearRequestedRoute
	local v64, v65 = React.useState("")
	local v66 = getFFlagAppChatRequestedRoute()
	local v67 = nil
	local u68 = nil

	if v66 then
		local v69

		v67, v69 = React.useState(getRequestedRoute())
		u68 = v69
	end

	local v70, v71 = React.useState(true)

	useParentContainerVisibilitySignal()
	useAppChatUpdateSession(v54)
	usePreventExperienceControls(v54)
	React.useEffect(function() -- line: 108
		-- upvalues: v54 (copy), v53 (copy), SetAppLoaded (copy), getAllFriendsAsync (copy), PartyPageCarouselExperimentation (copy), getLocalUserFriendsCount (copy)
		if v54 then
			v53(SetAppLoaded(true))
			v53(getAllFriendsAsync(true))

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				v53(getLocalUserFriendsCount())
			end
		end
	end, {
		v53,
		v54
	})
	React.useEffect(function() -- line: 119
		-- upvalues: v53 (copy), GetLocalUser (copy)
		v53(GetLocalUser())
	end, { v53 })

	if v47 then
		React.useEffect(function() -- line: 126
			-- upvalues: visibilitySignal (copy), v52 (copy)
			local v78 = visibilitySignal:connect(function(p4) -- line: 127
				-- upvalues: v52 (copy)
				if not p4 and v52.current then
					v52.current.Enabled = false
				end
			end)

			return function() -- line: 133
				-- upvalues: v78 (copy)
				v78:disconnect()
			end
		end, { visibilitySignal })
	end

	if v66 then
		React.useEffect(function() -- line: 141
			-- upvalues: requestedRouteSignal (copy), u68 (ref)
			local v79 = requestedRouteSignal:connect(function(p5) -- line: 142
				-- upvalues: u68 (ref)
				u68(p5)
			end)

			return function() -- line: 146
				-- upvalues: v79 (copy)
				v79:disconnect()
			end
		end, { requestedRouteSignal })
	end

	if GetFFlagIsSquadEnabled() then
		local v72 = useSelector(function(p6) -- line: 153
			local v81 = p6.Squad and (p6.Squad.Squad and p6.Squad.Squad.currentSquad)

			if v81 and v81.squadId then
				return v81.squadId
			end

			return ""
		end)

		React.useEffect(function() -- line: 158
			-- upvalues: updateCurrentSquadId (copy), v72 (copy)
			updateCurrentSquadId(v72)
		end, {
			v72,
			updateCurrentSquadId
		})
	end

	local v73 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p7) -- line: 164
		return p7.Squad.SquadPrompt.arguments
	end)
	local v74 = React.useMemo(function() -- line: 169
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), hideParentContainer (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p8) -- line: 172
					-- upvalues: hideParentContainer (copy)
					hideParentContainer()
					p8:cancel()
				end)
			}
		}
	end, { hideParentContainer })
	local v75 = useAppPolicy(function(p9) -- line: 180
		return p9.getCanAccessParty()
	end)
	local v76 = GetFFlagIsSquadEnabled() and (v73 and v73.promptType)

	if FFlagEnableAppChatSnoozeMenuFocus then
		React.useEffect(function() -- line: 187
			-- upvalues: NotificationSnoozeMenuVisibleSignal (copy), v71 (copy)
			local v84 = NotificationSnoozeMenuVisibleSignal:connect(function(t2: {[any]: any}) -- line: 188
				-- upvalues: v71 (copy)
				v71(not t2.visible)
			end)

			return function() -- line: 192
				-- upvalues: v84 (copy)
				v84:disconnect()
			end
		end, {})
	end

	local t3 = {
		SquadEventReceiver = if not v75 then nil else React.createElement(SquadEventReceiver),
		AppChatPersistentEventReceivers = React.createElement(AppChatPersistentEventReceivers, {
			isInExperience = true
		}),
		AppChatToastManagerInExp = React.createElement(AppChatToastManagerInExp, {
			hideAllChatToasts = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then v54 else nil,
			isAppChatVisible = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then nil else v54,
			navigateToChat = function(p10) -- line: 206
				-- upvalues: showParentContainer (copy), v65 (copy)
				showParentContainer()
				v65(p10)
			end
		}),
		AppChatContainer = React.createElement(UiModeStyleProvider, {
			style = {
				themeName = Constants.ThemeName.Dark,
				fontName = Constants.FontName.Gotham
			}
		}, { React.createElement(DesignTokenProvider, {
			tokenMappers = {}
		}, {
			AppChatScreenGui = if not v54 and not v76 then nil else React.createElement("ScreenGui", {
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
				DisplayOrder = v33,
				ref = v52
			}, wrapWithFocusRoot({
				SquadOverlay = if not v76 then nil else React.createElement(SquadOverlay),
				AppChat = if not v54 then nil else React.createElement(LayerCollectorProvider, {}, {
					containerRef = React.createElement(Responsive.ContainerRef.Provider, {
						value = v52
					}, { React.createElement(RoactServices.ServiceProvider, {
						services = {
							[AppSessionService] = SessionService
						}
					}, {
						InExperienceAppChatContainer = React.createElement(InExperienceAppChatContainer, {
							hideAppChat = v55,
							initialConversationId = v64,
							setInitialConversationId = v65,
							requestedRoute = if not v66 then nil else v67,
							clearRequestedRoute = if not v66 then nil else clearRequestedRoute
						})
					}) })
				})
			}, v74, v70))
		}) }),
		OverlayHost = React.createElement(OverlayHost, {
			providers = {{
				class = Foundation.FoundationProvider,
				props = {
					theme = Foundation.Enums.Theme.Dark
				}
			}}
		})
	}

	return React.createElement(React.Fragment, {}, t3)
end

return InExperienceAppChat
