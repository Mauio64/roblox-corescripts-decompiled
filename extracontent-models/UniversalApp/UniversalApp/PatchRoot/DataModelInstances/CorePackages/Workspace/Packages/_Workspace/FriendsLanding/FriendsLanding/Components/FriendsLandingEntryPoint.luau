local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local Logger = dependencies.Logger
local RoactRodux = dependencies.RoactRodux
local RoactAppExperiment = dependencies.RoactAppExperiment
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local Navigator = require(FriendsLanding.Navigator)
local EnumScreens = require(FriendsLanding.EnumScreens)
local filterStates = require(FriendsLanding.Friends.filterStates)
local memoize = dependencies.memoize
local SocialLibraries = dependencies.SocialLibraries
local BottomInsetBackground = dependencies.SocialCommon.Components.BottomInsetBackground
local compose = SocialLibraries.RoduxTools.compose
local mapStateToProps = require(script.mapStateToProps)
local mapDispatchToProps = require(script.mapDispatchToProps)
local withLocalization = dependencies.withLocalization
local getFStringSocialAddFriendsPageLayer = dependencies.getFStringSocialAddFriendsPageLayer
local FFlagContactImporterIXPCleanup = require(FriendsLandingParent.SharedFlags).FFlagContactImporterIXPCleanup
local FFlagFriendsPageAlwaysOpenPPV = require(FriendsLandingParent.SharedFlags).FFlagFriendsPageAlwaysOpenPPV

local function v23() -- line: 29
end

local v24 = Roact.PureComponent:extend("FriendsLandingEntryPoint")

v24.defaultProps = {
	renderAndroidBackButtonNavigationHandler = nil,
	isLuobu = false,
	logger = nil,
	debug_willUnmount = nil,
	luaAppPages = {}
}

function v24.init(p1) -- line: 45
	-- upvalues: Logger (copy), filterStates (copy), EnumScreens (copy), v23 (copy), memoize (copy), FriendsLandingAnalytics (copy)
	if p1.props.logger then
		Logger:setParent(p1.props.logger)
	end

	p1.state = {
		filter = filterStates.All,
		topBar = {
			[EnumScreens.FriendsLanding] = {
				shouldRenderCenter = false
			}
		}
	}
	p1.localization = {
		pageError = "CommonUI.Messages.Response.PageError"
	}

	function p1.setFilterKeys(p2) -- line: 63
		-- upvalues: p1 (copy)
		assert(type(p2) == "string", "Expected value to be a string")
		p1:setState({
			filter = p2
		})
	end
	function p1.showErrorToast(s1: string) -- line: 68
		-- upvalues: p1 (copy), EnumScreens (copy)
		p1.props.navigation.navigate(EnumScreens.GenericToast, {
			toastProps = {
				toastContent = {
					toastTitle = s1
				}
			}
		})
	end
	function p1.refreshPage(p3) -- line: 78
		-- upvalues: p1 (copy), Logger (copy), v23 (copy)
		return p1.props.refreshPageData({
			localUserId = p1.props.localUserId,
			inactiveFriendsNetworkRequestStatus = p1.props.inactiveFriendsNetworkRequestStatus,
			onError = function() -- line: 82
				-- upvalues: p1 (copy), p3 (copy), Logger (copy)
				p1.showErrorToast(p3.errorMessage)
				Logger:info("Refreshing FriendsLanding data failed")
			end,
			onResolve = p3.onResolve or v23
		})
	end

	p1.getAnalytics = memoize(function(p4) -- line: 90
		-- upvalues: FriendsLandingAnalytics (copy), p1 (copy)
		return FriendsLandingAnalytics.Class.new({
			Diag = p1.props.diagService,
			EventStream = p1.props.eventIngestService
		}, p4, p1.props.getLoadingTimeInfo)
	end)
end
function v24.render(p5) -- line: 98
	-- upvalues: withLocalization (copy), Roact (copy), FriendsLandingAnalytics (copy), FriendsLandingContext (copy), FFlagContactImporterIXPCleanup (copy), FFlagFriendsPageAlwaysOpenPPV (copy), Navigator (copy), BottomInsetBackground (copy)
	return withLocalization(p5.localization)(function(_) -- line: 99
		-- upvalues: Roact (copy), FriendsLandingAnalytics (copy), p5 (copy), FriendsLandingContext (copy), FFlagContactImporterIXPCleanup (copy), FFlagFriendsPageAlwaysOpenPPV (copy), Navigator (copy), BottomInsetBackground (copy)
		return Roact.createElement(FriendsLandingAnalytics.Context.Provider, {
			value = p5.getAnalytics(p5.props.localUserId)
		}, { Roact.createElement(FriendsLandingContext.Provider, {
			value = {
				navigateToLuaAppPages = p5.props.navigateToLuaAppPages,
				filter = p5.state.filter,
				setFilterKeys = p5.setFilterKeys,
				screenSize = p5.props.screenSize,
				friendRequestCount = p5.props.friendRequestCount,
				totalFriendCount = p5.props.totalFriendCount,
				wideMode = p5.props.wideMode,
				playerSearchPage = p5.props.luaAppPages.playerSearchPage,
				diagService = p5.props.diagService,
				eventIngestService = p5.props.eventIngestService,
				isLuobu = p5.props.isLuobu,
				refreshPage = p5.refreshPage,
				friendsRequestEventListener = p5.props.friendsRequestEventListener,
				robloxEventReceiver = p5.props.robloxEventReceiver,
				contactImporterAndPYMKEnabled = if not FFlagContactImporterIXPCleanup then p5.props.contactImporterAndPYMKEnabled else nil,
				contactImporterExperimentVariant = if not FFlagContactImporterIXPCleanup then p5.props.contactImporterExperimentVariant else nil,
				addFriendsPageSearchbarEnabled = p5.props.addFriendsPageSearchbarEnabled,
				openProfilePeekView = p5.props.openProfilePeekView,
				openPlayerContextualMenu = if not FFlagFriendsPageAlwaysOpenPPV then p5.props.openPlayerContextualMenu else nil,
				openAmpUpsell = p5.props.openAmpUpsell,
				passedNavParams = p5.props.passedNavParams
			}
		}, {
			navigation = Roact.createElement(Navigator, {
				navigation = p5.props.navigation
			}),
			BottomInsetBackground = Roact.createElement(BottomInsetBackground)
		}) })
	end)
end
function v24.didMount(_) -- line: 145
	-- upvalues: Logger (copy)
	Logger:info("FriendsLandingEntryPoint mounted")
end
function v24.willUnmount(p8) -- line: 149
	-- upvalues: Logger (copy)
	Logger:info("FriendsLandingEntryPoint unmounted")

	if p8.props.debug_willUnmount then
		p8.props.debug_willUnmount()
	end
end

return (compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), RoactAppExperiment.connectUserLayer({ getFStringSocialAddFriendsPageLayer() }, function(p9, _) -- line: 160
	-- upvalues: getFStringSocialAddFriendsPageLayer (copy)
	return {
		addFriendsPageSearchbarEnabled = (p9[getFStringSocialAddFriendsPageLayer()] or {}).show_add_friends_page_search_bar
	}
end, false))(v24))
