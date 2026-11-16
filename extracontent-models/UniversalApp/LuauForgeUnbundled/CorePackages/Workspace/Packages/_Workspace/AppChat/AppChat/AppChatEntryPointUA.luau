local AppBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppBlox")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib")
local AppTabBarRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppTabBarRodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

local appNotificationService = RoactServiceTags.AppNotificationService
local fullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local setTabBarVisibleFromChat = AppTabBarRodux.Thunks.SetTabBarVisibleFromChat
local signal = AppCommonLib.Signal
local squadAppChatEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Components").SquadAppChatEventReceiver
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

local module14 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/AppChatEntryPoint")
local module15 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EventReceivers/ChatEventReceiver")
local Container = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ExternalNavigationHandler/Container")
local useExternalNavigationByScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useExternalNavigationByScreen")
local useAppChatIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppChatIsWideMode")

local fFlagSquadAppChatRTNFix = SharedFlags.FFlagSquadAppChatRTNFix

local FFlagAppChatInExpSelectChatMembersMobileHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatInExpSelectChatMembersMobileHeight")

local v5 = {}

function LUAUFORGE_MODULE_GLOBALS_ikT_AppChatEntryPointUA(p2)
	local joined = Cryo.Dictionary.join(v5, p2)

	local v6 = useStyle()
	local v7 = useDispatch()
	local v8 = useEarlyIsFocused()

	local v9 = if FFlagAppChatInExpSelectChatMembersMobileHeight then useAppChatIsWideMode(false) else useIsWideMode()
	local v10 = useNavigation()
	local v11 = useAppPolicy(function(p3)
		return {
			shouldSystemBarUsuallyBePresent = p3.getShouldSystemBarUsuallyBePresent()
		}
	end)

	local state, setState = useState(0)
	local v12, v13 = useExternalNavigationByScreen()
	local v14 = useRoactService(appNotificationService)

	local v15 = useMemo(function()
		return signal.new()
	end)

	local v16 = useMemo(function()
		return joined.RobloxEventReceiver.new(v14)
	end)

	local v17 = useCallback(function(p3)
		v7(setTabBarVisibleFromChat(p3 or v11.shouldSystemBarUsuallyBePresent))
	end, { v7, v11.shouldSystemBarUsuallyBePresent })

	local v18 = useMemo(function()
		return {}
	end)

	local v19 = useSelector(function(p3)
		return p3.NotificationBadgeCounts.TopBarNotificationIcon
	end)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v21 = {
		FullscreenPageWithSafeArea = React.createElement(
			fullscreenPageWithSafeArea,
			{
				BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v6.Theme.BackgroundDefault.Transparency,
				includeStatusBar = true
			},
			{
				AppChatEntryPoint = React.createElement(module14, {
					setActiveConversationId = setState,
					updateExternalNavigationForScreen = v13,
					navigateToLuaAppPages = v18,
					rnBypassActionSignal = v15,
					notificationCount = v19,
					setTabBarVisible = v17,
					isVisible = v8,
					wideMode = v9,
					navigation = v10
				})
			}
		),
		ExternalNavigationHandler = React.createElement(Container, {
			navigationByScreen = v12
		}),
		ChatEventReceiver = React.createElement(module15, {
			robloxEventReceiver = v16,
			rnBypassActionSignal = v15,
			activeConversationId = tostring(state)
		}),
		SquadAppChatEventReceiver = 0
	}

	local v22 = if fFlagSquadAppChatRTNFix then React.createElement(squadAppChatEventReceiver) else nil
	v21.SquadAppChatEventReceiver = v22
	return createElement(fragment, {}, v21)
end

return LUAUFORGE_MODULE_GLOBALS_ikT_AppChatEntryPointUA
