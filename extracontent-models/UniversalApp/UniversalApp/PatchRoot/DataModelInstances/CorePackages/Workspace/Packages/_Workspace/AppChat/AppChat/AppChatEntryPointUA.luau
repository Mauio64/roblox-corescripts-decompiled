local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppBlox = require(AppChatParent.AppBlox)
local AppCommonLib = require(AppChatParent.AppCommonLib)
local AppTabBarRodux = require(AppChatParent.AppTabBarRodux)
local Cryo = require(AppChatParent.Cryo)
local Navigation = require(AppChatParent.Navigation)
local React = require(AppChatParent.React)
local RoactServiceTags = require(AppChatParent.RoactServiceTags)
local RoactUtils = require(AppChatParent.RoactUtils)
local RobloxAppHooks = require(AppChatParent.RobloxAppHooks)
local SharedFlags = require(AppChatParent.SharedFlags)
local SocialCommon = require(AppChatParent.SocialCommon)
local UIBlox = require(AppChatParent.UIBlox)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local AppNotificationService = RoactServiceTags.AppNotificationService
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local SetTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat
local Signal = AppCommonLib.Signal
local SquadAppChatEventReceiver = require(AppChatParent.SquadsCore.Components).SquadAppChatEventReceiver
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEarlyIsFocused = Navigation.useEarlyIsFocused
local useEffect = React.useEffect
local useMemo = React.useMemo
local useNavigation = Navigation.useNavigation
local useRoactService = RobloxAppHooks.useRoactService
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useState = React.useState
local useStyle = UIBlox.Core.Style.useStyle
local useIsWideMode = SocialCommon.Hooks.useIsWideMode
local AppChatEntryPoint = require(AppChat.AppChatEntryPoint)
local ChatEventReceiver = require(AppChat.Components.EventReceivers.ChatEventReceiver)
local Container = require(AppChat.Components.ExternalNavigationHandler.Container)
local ToggleChatPaused = require(AppChat.Actions.ToggleChatPaused)
local useExternalNavigationByScreen = require(AppChat.Hooks.useExternalNavigationByScreen)
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix
local FFlagAppChatInExpSelectChatMembersMobileHeight = require(AppChat.Flags.FFlagAppChatInExpSelectChatMembersMobileHeight)
local t1 = {}

function AppChatEntryPointUA(t2: {[any]: any}) -- line: 61
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useDispatch (copy), useEarlyIsFocused (copy), FFlagAppChatInExpSelectChatMembersMobileHeight (copy), useAppChatIsWideMode (copy), useIsWideMode (copy), useNavigation (copy), useAppPolicy (copy), useState (copy), useExternalNavigationByScreen (copy), useRoactService (copy), AppNotificationService (copy), useMemo (copy), Signal (copy), useCallback (copy), SetTabBarVisibleFromChat (copy), useSelector (copy), useEffect (copy), ToggleChatPaused (copy), React (copy), FullscreenPageWithSafeArea (copy), AppChatEntryPoint (copy), Container (copy), ChatEventReceiver (copy), FFlagSquadAppChatRTNFix (copy), SquadAppChatEventReceiver (copy)
	local v43 = Cryo.Dictionary.join(t1, t2)
	local v44 = useStyle()
	local v45 = useDispatch()
	local v46 = useEarlyIsFocused()
	local v47 = if not FFlagAppChatInExpSelectChatMembersMobileHeight then useIsWideMode() else useAppChatIsWideMode(false)
	local v48 = useNavigation()
	local v49 = useAppPolicy(function(p1) -- line: 71
		return {
			shouldSystemBarUsuallyBePresent = p1.getShouldSystemBarUsuallyBePresent()
		}
	end)
	local v50, v51 = useState(0)
	local v52, v53 = useExternalNavigationByScreen()
	local v54 = useRoactService(AppNotificationService)
	local v55 = useMemo(function() -- line: 81
		-- upvalues: Signal (copy)
		return Signal.new()
	end)
	local v56 = useMemo(function() -- line: 85
		-- upvalues: v43 (copy), v54 (copy)
		return v43.RobloxEventReceiver.new(v54)
	end)
	local v57 = useCallback(function(b1: boolean) -- line: 89
		-- upvalues: v45 (copy), SetTabBarVisibleFromChat (copy), v49 (copy)
		v45(SetTabBarVisibleFromChat(b1 or v49.shouldSystemBarUsuallyBePresent))
	end, {
		v45,
		v49.shouldSystemBarUsuallyBePresent
	})
	local v58 = useMemo(function() -- line: 93
		return {}
	end)
	local v59 = useSelector(function(p2) -- line: 97
		return p2.NotificationBadgeCounts.TopBarNotificationIcon
	end)

	useEffect(function() -- line: 101
		-- upvalues: v45 (copy), ToggleChatPaused (copy), v46 (copy)
		v45(ToggleChatPaused(not v46))
	end, {
		v46,
		v45
	})

	return React.createElement(React.Fragment, {}, {
		FullscreenPageWithSafeArea = React.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = v44.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v44.Theme.BackgroundDefault.Transparency
		}, {
			AppChatEntryPoint = React.createElement(AppChatEntryPoint, {
				setActiveConversationId = v51,
				updateExternalNavigationForScreen = v53,
				navigateToLuaAppPages = v58,
				rnBypassActionSignal = v55,
				notificationCount = v59,
				setTabBarVisible = v57,
				isVisible = v46,
				wideMode = v47,
				navigation = v48
			})
		}),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = v52
		}),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = v56,
			rnBypassActionSignal = v55,
			activeConversationId = tostring(v50)
		}),
		SquadAppChatEventReceiver = if not FFlagSquadAppChatRTNFix then nil else React.createElement(SquadAppChatEventReceiver)
	})
end

return AppChatEntryPointUA
