local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local Contexts = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Contexts
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)
local AppPage = require(Modules.LuaApp.AppPage)
local EntryPoint = require(CorePackages.Workspace.Packages.FriendsLanding.EntryPoint)
local EnumScreens = require(CorePackages.Workspace.Packages.FriendsLanding.EnumScreens)
local PlayerSearch = require(Modules.LuaApp.Components.UserSearch.Players.PlayerSearch)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local memoize = require(Modules.Common.memoize)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local RobloxEventReceiver = require(CorePackages.Workspace.Packages.RealtimeDelivery).RobloxEventReceiver
local llama = require(CorePackages.Packages.LuaSocialLibrariesDeps).llama
local OffPlatformFriendRequestsIXP = require(CorePackages.Workspace.Packages.ContactImporter).Flags.OffPlatformFriendRequestsIXP
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local formatUser = require(script.Parent.Parent.utils.formatUser)
local FFlagLuaAppEnableStickyShortcutBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableStickyShortcutBar
local v32 = if not FFlagLuaAppEnableStickyShortcutBar then nil else require(CorePackages.Workspace.Packages.AppShortcutBar).Hooks.useIsStickyShortcutBarEnabled
local FFlagCreateConnectionsHub = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCreateConnectionsHub
local FFlagContactImporterIXPCleanup = require(CorePackages.Workspace.Packages.SharedFlags).FFlagContactImporterIXPCleanup
local FFlagGuacStickyShortcutBarEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagGuacStickyShortcutBarEnabled
local v36 = if not FFlagGuacStickyShortcutBarEnabled then nil else require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local v37 = Roact.PureComponent:extend("FriendsLandingUniversalAppWrapper")

v37.defaultProps = {
	wideMode = false
}

function v37.init(p1) -- line: 62
	-- upvalues: RobloxEventReceiver (copy), llama (copy), formatUser (copy), EnumScreens (copy), FFlagContactImporterIXPCleanup (copy), Contexts (copy), AppPage (copy), RobloxAppEnums (copy), PlayerSearch (copy), memoize (copy), Roact (copy), EntryPoint (copy), Logger (copy)
	p1.robloxEventReceiver = RobloxEventReceiver.new(p1.props.notificationService)

	function p1.navigateDownToFriendRequests() -- line: 65
		-- upvalues: p1 (copy)
		p1.props.navigateDownToFriendRequests()
	end
	function p1.viewUserProfile(p2, p3) -- line: 69
		-- upvalues: llama (copy), formatUser (copy), p1 (copy)
		if p3 then
			local v62 = p3.profilePeekViewProps or {}
			local v63 = p3.contextualMenuProps or {}
			local v64 = llama.Dictionary.join(v63, {
				user = if not v63.user then {} else formatUser(v63.user)
			})

			p1.props.navigateToUserInfo(p2, {
				contextualMenuProps = v64,
				profilePeekViewProps = llama.Dictionary.join(v62, {
					resetPeekView = false,
					source = p3.source
				}),
				entryPoint = p3.entryPoint,
				openJoinable = p3.openJoinable,
				userInGame = p3.userInGame
			})
		end
	end

	p1.navigateToLuaAppPages = {
		[EnumScreens.FriendFinder] = p1.navigateDownToFriendRequests,
		[EnumScreens.ViewUserProfile] = p1.viewUserProfile,
		[EnumScreens.LearnMore] = if not p1.props.contactImporterAndPYMKEnabled and not FFlagContactImporterIXPCleanup or not p1.props.isContactImporterPolicyEnabled then nil else p1.props.openLearnMoreLink,
		[EnumScreens.ProfileQRCode] = function() -- line: 98
			-- upvalues: p1 (copy), Contexts (copy)
			p1.props.navigateTo3DQRCodePage({
				source = Contexts.AddFriends
			})
		end,
		[EnumScreens.SearchPage] = function() -- line: 103
			-- upvalues: p1 (copy), AppPage (copy), RobloxAppEnums (copy)
			p1.props.navigation.navigate(AppPage.SearchPage, {
				defaultSearchType = RobloxAppEnums.SearchTypes.Players
			})
		end,
		[EnumScreens.AmpWizardContainer] = p1.props.openAmpWizardContainer
	}
	p1.luaAppPages = {
		playerSearchPage = PlayerSearch
	}

	function p1.getLoadingTimeInfo() -- line: 116
		-- upvalues: p1 (copy)
		return p1.props.navigateToFriendsLandingEventStart
	end

	p1.renderFriendsLanding = p1.props.renderFriendsLanding or memoize(function(_, p5, p6, p7, _, p9) -- line: 122
		-- upvalues: Roact (copy), EntryPoint (copy), Logger (copy), p1 (copy), FFlagContactImporterIXPCleanup (copy)
		return Roact.createElement(EntryPoint, {
			isLuaProfilePageEnabled = true,
			navigation = p9,
			navigateToLuaAppPages = p5,
			wideMode = p6,
			luaAppPages = p7,
			logger = Logger,
			debug_willUnmount = p1.props.debug_entryPointWillUnmount,
			luaAddFriendsPageEnabled = p1.props.luaAddFriendsPageEnabled,
			robloxEventReceiver = p1.robloxEventReceiver,
			getLoadingTimeInfo = p1.getLoadingTimeInfo,
			contactImporterAndPYMKEnabled = if not FFlagContactImporterIXPCleanup then p1.props.contactImporterAndPYMKEnabled and p1.props.isContactImporterPolicyEnabled else nil,
			contactImporterExperimentVariant = if not FFlagContactImporterIXPCleanup then p1.props.contactImporterExperimentVariant else nil,
			diagService = p1.props.roactAnalytics.Diag,
			eventIngestService = p1.props.eventIngestService,
			openProfilePeekView = p1.props.openProfilePeekView,
			openPlayerContextualMenu = p1.props.openPlayerContextualMenu,
			passedNavParams = p1.props.passedNavParams
		})
	end)
end
function v37.render(p10) -- line: 157
	-- upvalues: withStyle (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), Roact (copy), FullscreenPageWithSafeArea (copy)
	return withStyle(function(_) -- line: 158
		-- upvalues: FFlagCreateConnectionsHub (copy), p10 (copy), AppPage (copy), Roact (copy), FullscreenPageWithSafeArea (copy)
		if FFlagCreateConnectionsHub and p10.props.navigation.state.routeName == AppPage.CoHubMyConnections then
			return p10.renderFriendsLanding(nil, p10.navigateToLuaAppPages, p10.props.wideMode, p10.luaAppPages, nil, p10.props.navigation)
		end

		return Roact.createElement(FullscreenPageWithSafeArea, {
			includeStatusBar = true,
			BackgroundColor3 = p10.props.BackgroundColor,
			BackgroundTransparency = p10.props.BackgroundTransparency,
			useFullScalePage = p10.props.useFullScalePage
		}, {
			FriendsLanding = p10.renderFriendsLanding(nil, p10.navigateToLuaAppPages, p10.props.wideMode, p10.luaAppPages, nil, p10.props.navigation)
		})
	end)
end

local v38 = RoactAppExperiment.connectUserLayer({ AppUserLayers.SocialFriendsLayer }, function(p12, _) -- line: 190
	-- upvalues: AppUserLayers (copy), FFlagContactImporterIXPCleanup (copy), OffPlatformFriendRequestsIXP (copy)
	local v47 = p12[AppUserLayers.SocialFriendsLayer] or {}
	local v48 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.getExperimentVariant(p12) else nil
	local v49 = if not FFlagContactImporterIXPCleanup then OffPlatformFriendRequestsIXP.experimentOrRolloutEnabled(p12) else nil

	return {
		luaAddFriendsPageEnabled = v47.show_lua_add_friends_page == "True",
		contactImporterAndPYMKEnabled = if not FFlagContactImporterIXPCleanup then v49 else nil,
		contactImporterExperimentVariant = if not FFlagContactImporterIXPCleanup then v48 else nil
	}
end)(v37)
local v39 = RoactRodux.connect(function(p14, _) -- line: 208
	return {
		centralOverlayType = p14.CentralOverlay.OverlayType
	}
end, nil)(v38)
local v40 = UniversalAppPolicy.connect(function(p16) -- line: 214
	return {
		isContactImporterPolicyEnabled = p16.getContactImporterEnabled()
	}
end)(v39)
local u41 = RoactServices.connect({
	roactAnalytics = RoactAnalytics,
	eventIngestService = AppEventIngestService
})(v40)

local function FriendsLandingUniversalAppWrapperContainer(p17) -- line: 225
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), useNavigation (copy), FFlagGuacStickyShortcutBarEnabled (copy), v36 (copy), FFlagLuaAppEnableStickyShortcutBar (copy), v32 (copy), UiMode (copy), useNavigationProps (copy), Roact (copy), u41 (ref), Cryo (copy)
	local v54 = useDesignTokens()
	local v55 = useUiModeInfo()
	local v56 = useNavigation()
	local v57 = if not FFlagGuacStickyShortcutBarEnabled then if not FFlagLuaAppEnableStickyShortcutBar then nil else v32() else v36(function(p18) -- line: 232
		return p18.getStickyShortcutBarEnabled()
	end)
	local v58 = v55.uiMode == UiMode.TenFoot
	local v59 = useNavigationProps(function(_, p20) -- line: 241
		return {
			navigateToFriendsLandingEventStart = p20.navigateToFriendsLandingEventStart
		}
	end)

	return Roact.createElement(u41, Cryo.Dictionary.join(p17, {
		BackgroundColor = v54.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = v54.LuaApps.App.Page.BackgroundTransparency,
		navigation = v56,
		useFullScalePage = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then v58 else v58 or v57
	}, v59))
end

return FriendsLandingUniversalAppWrapperContainer
