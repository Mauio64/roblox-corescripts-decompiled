local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roact = dependencies.Roact
local logger = dependencies.Logger
local roactRodux = dependencies.RoactRodux
local roactAppExperiment = dependencies.RoactAppExperiment
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local FriendsLandingAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics")
local Navigator = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local filterStates = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Friends/filterStates")
local memoize = dependencies.memoize
local socialLibraries = dependencies.SocialLibraries
local bottomInsetBackground = dependencies.SocialCommon.Components.BottomInsetBackground
local compose = socialLibraries.RoduxTools.compose
local mapStateToProps = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingEntryPoint/mapStateToProps")
local mapDispatchToProps = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingEntryPoint/mapDispatchToProps")
local getInitialFilter = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingEntryPoint/getInitialFilter")
local withLocalization = dependencies.withLocalization

local getFStringSocialAddFriendsPageLayer = dependencies.getFStringSocialAddFriendsPageLayer

local fFlagFriendsPageAlwaysOpenPPV = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsPageAlwaysOpenPPV
local fFlagFriendsDeepLinkInitialFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagFriendsDeepLinkInitialFilter

local function fn() end

local extended = roact.PureComponent:extend("FriendsLandingEntryPoint")

extended.defaultProps = {
	renderAndroidBackButtonNavigationHandler = nil,
	luaAppPages = {},
	isLuobu = false,
	logger = nil,
	debug_willUnmount = nil
}

function extended:init()
	if self.props.logger then
		logger:setParent(self.props.logger)
	end

	self.state = {
		filter = filterStates.All,
		topBar = {
			[EnumScreens.FriendsLanding] = { shouldRenderCenter = false }
		}
	}

	if fFlagFriendsDeepLinkInitialFilter then
		self.state.filter = getInitialFilter(self.props.initialFilter)
	end

	self.localization = { pageError = "CommonUI.Messages.Response.PageError" }

	function self.setFilterKeys(value)
		assert(type(value) == "string", "Expected value to be a string")
		self:setState({ filter = value })
	end

	function self.showErrorToast(p2)
		self.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = { toastTitle = p2 }
			}
		})
	end

	function self.refreshPage(p2)
		return self.props.refreshPageData({
			localUserId = self.props.localUserId,
			inactiveFriendsNetworkRequestStatus = self.props.inactiveFriendsNetworkRequestStatus,
			onError = function()
				self.showErrorToast(p2.errorMessage)
				logger:info("Refreshing FriendsLanding data failed")
			end,
			onResolve = p2.onResolve or fn
		})
	end

	self.getAnalytics = memoize(function(p2)
		return FriendsLandingAnalytics.Class.new(
			{
				Diag = self.props.diagService,
				EventStream = self.props.eventIngestService
			},
			p2,
			self.props.getLoadingTimeInfo
		)
	end)
end

function extended.render(data)
	return withLocalization(data.localization)(function(p2)
		local createElement = roact.createElement
		local provider = FriendsLandingAnalytics.Context.Provider
		local v5 = {
			value = data.getAnalytics(data.props.localUserId)
		}

		local createElement2 = roact.createElement
		local provider2 = FriendsLandingContext.Provider
		local v8 = {
			navigateToLuaAppPages = data.props.navigateToLuaAppPages,
			filter = data.state.filter,
			setFilterKeys = data.setFilterKeys,
			screenSize = data.props.screenSize,
			friendRequestCount = data.props.friendRequestCount,
			totalFriendCount = data.props.totalFriendCount,
			wideMode = data.props.wideMode,
			playerSearchPage = data.props.luaAppPages.playerSearchPage,
			diagService = data.props.diagService,
			eventIngestService = data.props.eventIngestService,
			isLuobu = data.props.isLuobu,
			refreshPage = data.refreshPage,
			friendsRequestEventListener = data.props.friendsRequestEventListener,
			robloxEventReceiver = data.props.robloxEventReceiver,
			addFriendsPageSearchbarEnabled = data.props.addFriendsPageSearchbarEnabled,
			openProfilePeekView = data.props.openProfilePeekView,
			openPlayerContextualMenu = 0,
			openAmpUpsell = 0,
			passedNavParams = 0
		}

		local v9 = if not fFlagFriendsPageAlwaysOpenPPV then data.props.openPlayerContextualMenu else nil
		v8.openPlayerContextualMenu = v9

		v8.openAmpUpsell = data.props.openAmpUpsell
		v8.passedNavParams = data.props.passedNavParams
		return createElement(provider, v5, { createElement2(provider2, { value = v8 }, {
				navigation = roact.createElement(Navigator, {
					navigation = data.props.navigation
				}),
				BottomInsetBackground = roact.createElement(bottomInsetBackground)
			}) })
	end)
end

function extended.didMount(p2)
	logger:info("FriendsLandingEntryPoint mounted")
end

function extended.willUnmount(p2)
	logger:info("FriendsLandingEntryPoint unmounted")

	if p2.props.debug_willUnmount then
		p2.props.debug_willUnmount()
	end
end

return (compose(
	roactRodux.connect(mapStateToProps, mapDispatchToProps),
	roactAppExperiment.connectUserLayer({ getFStringSocialAddFriendsPageLayer() }, function(p2, p3)
		return {
			addFriendsPageSearchbarEnabled = (p2[getFStringSocialAddFriendsPageLayer()] or {}).show_add_friends_page_search_bar
		}
	end, false)
)(extended))
