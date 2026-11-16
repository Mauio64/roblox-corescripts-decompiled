local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppBlox = require(parent.AppBlox)
local AppCommonLib = require(parent.AppCommonLib)
local AppTabBarRodux = require(parent.AppTabBarRodux)
local Cryo = require(parent.Cryo)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SharedFlags = require(parent.SharedFlags)
local SocialCommon = require(parent.SocialCommon)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local AppNotificationService = RoactServiceTags.AppNotificationService
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local SetTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat
local Signal = AppCommonLib.Signal
local Components = require(parent.SquadsCore.Components)
local SquadAppChatEventReceiver = Components.SquadAppChatEventReceiver
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEarlyIsFocused = Navigation.useEarlyIsFocused
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
local useExternalNavigationByScreen = require(AppChat.Hooks.useExternalNavigationByScreen)
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)

local FFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix

local FFlagAppChatInExpSelectChatMembersMobileHeight = require(AppChat.Flags.FFlagAppChatInExpSelectChatMembersMobileHeight)

local v = {}

function AppChatEntryPointUA(p)
	local joined = Cryo.Dictionary.join(v, p)

	local v2 = useStyle()
	local v3 = useDispatch()
	local isVisible = useEarlyIsFocused()
	local wideMode

	if FFlagAppChatInExpSelectChatMembersMobileHeight then
		wideMode = useAppChatIsWideMode(false)
	else
		wideMode = useIsWideMode()
	end

	local navigation = useNavigation()
	local v4 = useAppPolicy(function(p2)
		return {
			shouldSystemBarUsuallyBePresent = p2.getShouldSystemBarUsuallyBePresent()
		}
	end)

	local state, setState = useState(0)
	local navigationByScreen, updateExternalNavigationForScreen = useExternalNavigationByScreen()
	local v5 = useRoactService(AppNotificationService)

	local rnBypassActionSignal = useMemo(function()
		return Signal.new()
	end)

	local robloxEventReceiver = useMemo(function()
		return joined.RobloxEventReceiver.new(v5)
	end)

	local setTabBarVisible = useCallback(function(flag: boolean)
		v3(SetTabBarVisibleFromChat(flag or v4.shouldSystemBarUsuallyBePresent))
	end, { v3, v4.shouldSystemBarUsuallyBePresent })

	local navigateToLuaAppPages = useMemo(function()
		return {}
	end)

	local notificationCount = useSelector(function(p2)
		return p2.NotificationBadgeCounts.TopBarNotificationIcon
	end)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v6 = {
		FullscreenPageWithSafeArea = React.createElement(
			FullscreenPageWithSafeArea,
			{
				BackgroundColor3 = v2.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v2.Theme.BackgroundDefault.Transparency,
				includeStatusBar = true
			},
			{
				AppChatEntryPoint = React.createElement(AppChatEntryPoint, {
					setActiveConversationId = setState,
					updateExternalNavigationForScreen = updateExternalNavigationForScreen,
					navigateToLuaAppPages = navigateToLuaAppPages,
					rnBypassActionSignal = rnBypassActionSignal,
					notificationCount = notificationCount,
					setTabBarVisible = setTabBarVisible,
					isVisible = isVisible,
					wideMode = wideMode,
					navigation = navigation
				})
			}
		),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = navigationByScreen
		}),
		ChatEventReceiver = React.createElement(ChatEventReceiver, {
			robloxEventReceiver = robloxEventReceiver,
			rnBypassActionSignal = rnBypassActionSignal,
			activeConversationId = tostring(state)
		}),
		SquadAppChatEventReceiver = 0
	}
	local squadAppChatEventReceiver

	if FFlagSquadAppChatRTNFix then
		squadAppChatEventReceiver = React.createElement(SquadAppChatEventReceiver)
	end

	v6.SquadAppChatEventReceiver = squadAppChatEventReceiver
	return createElement(fragment, {}, v6)
end

return AppChatEntryPointUA
