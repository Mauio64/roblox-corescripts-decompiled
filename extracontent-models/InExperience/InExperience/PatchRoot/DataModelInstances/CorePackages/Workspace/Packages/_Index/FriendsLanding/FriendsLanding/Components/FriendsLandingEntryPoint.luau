local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact
local logger = dependencies.Logger
local roactRodux = dependencies.RoactRodux
local roactAppExperiment = dependencies.RoactAppExperiment
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local Navigator = require(FriendsLanding.Navigator)

local EnumScreens = require(FriendsLanding.EnumScreens)
local filterStates = require(FriendsLanding.Friends.filterStates)
local memoize = dependencies.memoize
local socialLibraries = dependencies.SocialLibraries
local bottomInsetBackground = dependencies.SocialCommon.Components.BottomInsetBackground
local compose = socialLibraries.RoduxTools.compose
local mapStateToProps = require(script.mapStateToProps)
local mapDispatchToProps = require(script.mapDispatchToProps)
local getInitialFilter = require(script.getInitialFilter)
local withLocalization = dependencies.withLocalization

local getFStringSocialAddFriendsPageLayer = dependencies.getFStringSocialAddFriendsPageLayer

local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsPageAlwaysOpenPPV = SharedFlags.FFlagFriendsPageAlwaysOpenPPV
local SharedFlags2 = require(parent.SharedFlags)
local FFlagFriendsDeepLinkInitialFilter = SharedFlags2.FFlagFriendsDeepLinkInitialFilter

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

	if FFlagFriendsDeepLinkInitialFilter then
		self.state.filter = getInitialFilter(self.props.initialFilter)
	end

	self.localization = { pageError = "CommonUI.Messages.Response.PageError" }

	function self.setFilterKeys(filter)
		assert(type(filter) == "string", "Expected value to be a string")
		self:setState({ filter = filter })
	end

	function self.showErrorToast(toastTitle: string)
		self.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = { toastTitle = toastTitle }
			}
		})
	end

	function self.refreshPage(p)
		return self.props.refreshPageData({
			localUserId = self.props.localUserId,
			inactiveFriendsNetworkRequestStatus = self.props.inactiveFriendsNetworkRequestStatus,
			onError = function()
				self.showErrorToast(p.errorMessage)
				logger:info("Refreshing FriendsLanding data failed")
			end,
			onResolve = p.onResolve or fn
		})
	end

	self.getAnalytics = memoize(function(p)
		return FriendsLandingAnalytics.Class.new(
			{ Diag = self.props.diagService, EventStream = self.props.eventIngestService },
			p,
			self.props.getLoadingTimeInfo
		)
	end)
end

function extended.render(data)
	return withLocalization(data.localization)(function(_)
		local createElement = roact.createElement
		local provider = FriendsLandingAnalytics.Context.Provider
		local v = {
			value = data.getAnalytics(data.props.localUserId)
		}

		local createElement2 = roact.createElement
		local provider2 = FriendsLandingContext.Provider
		local v2 = {
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
		local openPlayerContextualMenu

		if not FFlagFriendsPageAlwaysOpenPPV then
			openPlayerContextualMenu = data.props.openPlayerContextualMenu
		end

		v2.openPlayerContextualMenu = openPlayerContextualMenu

		v2.openAmpUpsell = data.props.openAmpUpsell
		v2.passedNavParams = data.props.passedNavParams
		return createElement(provider, v, { createElement2(provider2, { value = v2 }, {
				navigation = roact.createElement(Navigator, { navigation = data.props.navigation }),
				BottomInsetBackground = roact.createElement(bottomInsetBackground)
			}) })
	end)
end

function extended.didMount(_)
	logger:info("FriendsLandingEntryPoint mounted")
end

function extended.willUnmount(p)
	logger:info("FriendsLandingEntryPoint unmounted")

	if p.props.debug_willUnmount then
		p.props.debug_willUnmount()
	end
end

return (compose(
	roactRodux.connect(mapStateToProps, mapDispatchToProps),
	roactAppExperiment.connectUserLayer({ getFStringSocialAddFriendsPageLayer() }, function(p, _)
		return {
			addFriendsPageSearchbarEnabled = (p[getFStringSocialAddFriendsPageLayer()] or {}).show_add_friends_page_search_bar
		}
	end, false)
)(extended))
