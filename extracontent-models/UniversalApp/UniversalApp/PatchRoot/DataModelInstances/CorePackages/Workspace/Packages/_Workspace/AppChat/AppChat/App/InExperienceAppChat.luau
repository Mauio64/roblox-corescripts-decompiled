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
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(AppChatParent.InputHandlers)
local NotificationSnoozeMenuVisibleSignal = require(AppChatParent.ToastNotification).Signals.NotificationSnoozeMenuVisibleSignal
local useAppPolicy = require(AppChatParent.UniversalAppPolicy).useAppPolicy
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local v46 = game:DefineFastFlag("AppChatFixCloseVisibilityLinger", false)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

function wrapWithFocusRoot(p1, p2, p3) -- line: 71
	-- upvalues: React (copy), FocusRoot (copy), t1 (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	return React.createElement(FocusRoot, {
		isIsolated = true,
		eventHandlers = p2,
		eventMap = t1,
		isAutoFocusRoot = not FFlagEnableAppChatSnoozeMenuFocus or p3,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
	}, p1)
end
function InExperienceAppChat() -- line: 81
	-- upvalues: React (copy), useDispatch (copy), useIsAppChatVisible (copy), v32 (copy), ParentContainerContext (copy), useParentContainerVisibilitySignal (copy), useAppChatUpdateSession (copy), usePreventExperienceControls (copy), SetAppLoaded (copy), getAllFriendsAsync (copy), PartyPageCarouselExperimentation (copy), getLocalUserFriendsCount (copy), GetLocalUser (copy), v46 (copy), GetFFlagIsSquadEnabled (copy), useSelector (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppPolicy (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), NotificationSnoozeMenuVisibleSignal (copy), SquadEventReceiver (copy), AppChatPersistentEventReceivers (copy), AppChatToastManagerInExp (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), UiModeStyleProvider (copy), Constants (copy), DesignTokenProvider (copy), v33 (copy), SquadOverlay (copy), LayerCollectorProvider (copy), Responsive (copy), RoactServices (copy), AppSessionService (copy), SessionService (copy), InExperienceAppChatContainer (copy), OverlayHost (copy), Foundation (copy)
	local v51 = React.useRef(nil)
	local v52 = useDispatch()
	local v53, v54 = useIsAppChatVisible(v32)
	local v55 = React.useContext(ParentContainerContext)
	local showParentContainer = v55.showParentContainer
	local hideParentContainer = v55.hideParentContainer
	local updateCurrentSquadId = v55.updateCurrentSquadId
	local visibilitySignal = v55.visibilitySignal
	local v60, v61 = React.useState("")
	local v62, v63 = React.useState(true)

	useParentContainerVisibilitySignal()
	useAppChatUpdateSession(v53)
	usePreventExperienceControls(v53)
	React.useEffect(function() -- line: 97
		-- upvalues: v53 (copy), v52 (copy), SetAppLoaded (copy), getAllFriendsAsync (copy), PartyPageCarouselExperimentation (copy), getLocalUserFriendsCount (copy)
		if v53 then
			v52(SetAppLoaded(true))
			v52(getAllFriendsAsync(true))

			if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
				v52(getLocalUserFriendsCount())
			end
		end
	end, {
		v52,
		v53
	})
	React.useEffect(function() -- line: 108
		-- upvalues: v52 (copy), GetLocalUser (copy)
		v52(GetLocalUser())
	end, { v52 })

	if v46 then
		React.useEffect(function() -- line: 115
			-- upvalues: visibilitySignal (copy), v51 (copy)
			local v70 = visibilitySignal:connect(function(p4) -- line: 116
				-- upvalues: v51 (copy)
				if not p4 and v51.current then
					v51.current.Enabled = false
				end
			end)

			return function() -- line: 122
				-- upvalues: v70 (copy)
				v70:disconnect()
			end
		end, { visibilitySignal })
	end

	if GetFFlagIsSquadEnabled() then
		local v64 = useSelector(function(p5) -- line: 129
			local v72 = p5.Squad and (p5.Squad.Squad and p5.Squad.Squad.currentSquad)

			if v72 and v72.squadId then
				return v72.squadId
			end

			return ""
		end)

		React.useEffect(function() -- line: 134
			-- upvalues: updateCurrentSquadId (copy), v64 (copy)
			updateCurrentSquadId(v64)
		end, {
			v64,
			updateCurrentSquadId
		})
	end

	local v65 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p6) -- line: 140
		return p6.Squad.SquadPrompt.arguments
	end)
	local v66 = React.useMemo(function() -- line: 145
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), hideParentContainer (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p7) -- line: 148
					-- upvalues: hideParentContainer (copy)
					hideParentContainer()
					p7:cancel()
				end)
			}
		}
	end, { hideParentContainer })
	local v67 = useAppPolicy(function(p8) -- line: 156
		return p8.getCanAccessParty()
	end)
	local v68 = GetFFlagIsSquadEnabled() and (v65 and v65.promptType)

	if FFlagEnableAppChatSnoozeMenuFocus then
		React.useEffect(function() -- line: 163
			-- upvalues: NotificationSnoozeMenuVisibleSignal (copy), v63 (copy)
			local v75 = NotificationSnoozeMenuVisibleSignal:connect(function(t2: {[any]: any}) -- line: 164
				-- upvalues: v63 (copy)
				v63(not t2.visible)
			end)

			return function() -- line: 168
				-- upvalues: v75 (copy)
				v75:disconnect()
			end
		end, {})
	end

	local t3 = {
		SquadEventReceiver = if not v67 then nil else React.createElement(SquadEventReceiver),
		AppChatPersistentEventReceivers = React.createElement(AppChatPersistentEventReceivers, {
			isInExperience = true
		}),
		AppChatToastManagerInExp = React.createElement(AppChatToastManagerInExp, {
			hideAllChatToasts = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then v53 else nil,
			isAppChatVisible = if not GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then nil else v53,
			navigateToChat = function(p9) -- line: 182
				-- upvalues: showParentContainer (copy), v61 (copy)
				showParentContainer()
				v61(p9)
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
			AppChatScreenGui = if not v53 and not v68 then nil else React.createElement("ScreenGui", {
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
				DisplayOrder = v33,
				ref = v51
			}, wrapWithFocusRoot({
				SquadOverlay = if not v68 then nil else React.createElement(SquadOverlay),
				AppChat = if not v53 then nil else React.createElement(LayerCollectorProvider, {}, {
					containerRef = React.createElement(Responsive.ContainerRef.Provider, {
						value = v51
					}, { React.createElement(RoactServices.ServiceProvider, {
						services = {
							[AppSessionService] = SessionService
						}
					}, {
						InExperienceAppChatContainer = React.createElement(InExperienceAppChatContainer, {
							hideAppChat = v54,
							initialConversationId = v60,
							setInitialConversationId = v61
						})
					}) })
				})
			}, v66, v62))
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
