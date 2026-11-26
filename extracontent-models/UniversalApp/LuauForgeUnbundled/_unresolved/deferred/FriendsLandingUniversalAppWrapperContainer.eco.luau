local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local module2 = require("@luauforge/bundled/ecq")
local module3 = require("@luauforge/bundled/ecr")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local contexts = require("@luauforge/bundled/ecs").Analytics.Enums.Contexts

local module4 = require("@luauforge/bundled/ect")
local module5 = require("@luauforge/bundled/dFu")
local module6 = require("@luauforge/deferred/ecv")
local module7 = require("@luauforge/deferred/egm")
local module8 = require("@luauforge/deferred/egn")
local Cryo = require(CorePackages.Packages.Cryo)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps

local module9 = require("@luauforge/bundled/ehO")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local robloxEventReceiver = require("@luauforge/bundled/ehP").RobloxEventReceiver
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")

local module11 = require("@luauforge/deferred/ehQ")

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCreateConnectionsHub

local fFlagFriendsDeepLinkInitialFilter = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFriendsDeepLinkInitialFilter
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagEnableStickyShortcutBarOnAllPlatforms = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableStickyShortcutBarOnAllPlatforms

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground
local getShortcutBarStatusStore

if fFlagEnableStickyShortcutBarOnAllPlatforms then
	getShortcutBarStatusStore = require("@luauforge/bundled/ehS").GetShortcutBarStatusStore
else
	getShortcutBarStatusStore = nil
end

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local extended = Roact.PureComponent:extend("FriendsLandingUniversalAppWrapper")

extended.defaultProps = { wideMode = false }

function extended:init()
	self.robloxEventReceiver = robloxEventReceiver.new(self.props.notificationService)

	function self.navigateDownToFriendRequests()
		self.props.navigateDownToFriendRequests()
	end

	function self.viewUserProfile(p2, data)
		if data then
			local profilePeekViewProps = data.profilePeekViewProps or {}
			local contextualMenuProps = data.contextualMenuProps or {}
			local joined = llama.Dictionary.join(contextualMenuProps, {
				user = not contextualMenuProps.user and {} or module11(contextualMenuProps.user)
			})

			self.props.navigateToUserInfo(p2, {
				contextualMenuProps = joined,
				profilePeekViewProps = llama.Dictionary.join(profilePeekViewProps, {
					resetPeekView = false,
					source = data.source
				}),
				entryPoint = data.entryPoint,
				openJoinable = data.openJoinable,
				userInGame = data.userInGame
			})
		end
	end

	local v5 = {
		[module7.FriendFinder] = self.navigateDownToFriendRequests,
		[module7.ViewUserProfile] = self.viewUserProfile
	}
	local learnMore = module7.LearnMore
	local v6 = if self.props.isContactImporterPolicyEnabled then self.props.openLearnMoreLink else nil
	v5[learnMore] = v6

	v5[module7.ProfileQRCode] = function()
		self.props.navigateTo3DQRCodePage({ source = contexts.AddFriends })
	end
	v5[module7.SearchPage] = function()
		self.props.navigation.navigate(module5.SearchPage, {
			defaultSearchType = RobloxAppEnums.SearchTypes.Players
		})
	end

	v5[module7.AmpWizardContainer] = self.props.openAmpWizardContainer
	self.navigateToLuaAppPages = v5

	self.luaAppPages = { playerSearchPage = module8 }

	function self.getLoadingTimeInfo()
		return self.props.navigateToFriendsLandingEventStart
	end

	self.renderFriendsLanding = self.props.renderFriendsLanding or module9(function(p2, p3, p4, p5, p6, p7)
		local createElement = Roact.createElement
		local v8 = {
			navigation = p7,
			navigateToLuaAppPages = p3,
			isLuaProfilePageEnabled = true,
			wideMode = p4,
			luaAppPages = p5,
			logger = logger,
			debug_willUnmount = self.props.debug_entryPointWillUnmount,
			luaAddFriendsPageEnabled = self.props.luaAddFriendsPageEnabled,
			robloxEventReceiver = self.robloxEventReceiver,
			getLoadingTimeInfo = self.getLoadingTimeInfo,
			diagService = self.props.roactAnalytics.Diag,
			eventIngestService = self.props.eventIngestService,
			openProfilePeekView = self.props.openProfilePeekView,
			openPlayerContextualMenu = self.props.openPlayerContextualMenu,
			passedNavParams = self.props.passedNavParams,
			initialFilter = 0
		}
		local v9 = if fFlagFriendsDeepLinkInitialFilter then self.props.initialFilter else nil
		v8.initialFilter = v9
		return createElement(module6, v8)
	end)
end

function extended.render(data)
	return withStyle(function(p2)
		if
			fFlagCreateConnectionsHub
			and data.props.navigation.state.routeName == module5.CoHubMyConnections
		then
			return data.renderFriendsLanding(
				nil,
				data.navigateToLuaAppPages,
				data.props.wideMode,
				data.luaAppPages,
				nil,
				data.props.navigation
			)
		end

		return Roact.createElement(
			module4,
			{
				BackgroundColor3 = data.props.BackgroundColor,
				BackgroundTransparency = data.props.BackgroundTransparency,
				useFullScalePage = data.props.useFullScalePage,
				includeStatusBar = true
			},
			{
				FriendsLanding = data.renderFriendsLanding(
					nil,
					data.navigateToLuaAppPages,
					data.props.wideMode,
					data.luaAppPages,
					nil,
					data.props.navigation
				)
			}
		)
	end)
end

local v5 = RoactAppExperiment.connectUserLayer({ appUserLayers.SocialFriendsLayer }, function(p2, p3)
	return {
		luaAddFriendsPageEnabled = (p2[appUserLayers.SocialFriendsLayer] or {}).show_lua_add_friends_page == "True"
	}
end)(extended)

local v6 = useSheetNavigation.connect(function(p2, p3)
	return { centralOverlayType = p2.CentralOverlay.OverlayType }
end, nil)(v5)

local v7 = universalAppPolicy.connect(function(p2)
	return { isContactImporterPolicyEnabled = p2.getContactImporterEnabled() }
end)(v6)

local v8 = roactServices.connect({
	roactAnalytics = module2,
	eventIngestService = module3
})(v7)

local function FriendsLandingUniversalAppWrapperContainer(p2)
	local v9 = useDesignTokens()
	local v10 = useUiModeInfo()
	local v11 = useNavigation()

	local v12 = useAppPolicy(function(p3)
		return p3.getStickyShortcutBarEnabled()
	end)
	local v13

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		v13 = useSignalState(getShortcutBarStatusStore(false).getShortcutBarVisible)
	end

	local v14 = v10.uiMode == uiMode.TenFoot

	local v15 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local v16 = useNavigationProps(function(p3, p4)
		local v17 = {
			navigateToFriendsLandingEventStart = p4.navigateToFriendsLandingEventStart,
			initialFilter = 0
		}
		local v18 = if fFlagFriendsDeepLinkInitialFilter then p4.initialFilter else nil
		v17.initialFilter = v18
		return v17
	end)

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join
	local v18 = {
		BackgroundColor = v9.LuaApps.App.Page.BackgroundColor,
		BackgroundTransparency = v15 and 1 or v9.LuaApps.App.Page.BackgroundTransparency,
		navigation = v11,
		useFullScalePage = 0
	}
	local v19 = if fFlagEnableStickyShortcutBarOnAllPlatforms then v14 or v12 or v13 else v14 or v12
	v18.useFullScalePage = v19
	return createElement(v8, join(p2, v18, v16))
end

return FriendsLandingUniversalAppWrapperContainer
