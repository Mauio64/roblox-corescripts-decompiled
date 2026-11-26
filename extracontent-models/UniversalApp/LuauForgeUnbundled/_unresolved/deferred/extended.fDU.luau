local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/Navigation").useEarlyIsFocused
local useNavigationProps = require("@luauforge/bundled/dFz").useNavigationProps
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local module2 = require("@luauforge/bundled/dGP")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local module3 = require("@luauforge/bundled/ehB")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local module5 = require("@luauforge/bundled/dFu")

local module6 = require("@luauforge/deferred/fvI")
local module7 = require("@luauforge/deferred/fvO")

local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local groupsNavigatorWithProviders = module2.Navigation.GroupsNavigatorWithProviders
local groupsRoutes = module2.Navigation.GroupsRoutes
local groupsWrapperContext = module2.Contexts.GroupsWrapperContext

local function fn(p2)
	local v5 = useDispatch()
	local v6 = useNavigation()
	local v7 = if fFlagEnableGroupOverviewPane then useEarlyIsFocused() else nil
	local v8 = useLocalUserId()

	local v9 = useNavigationProps(function(p3, p4)
		if fFlagEnableGroupOverviewPane then
			return {
				userId = p3,
				groupId = p4.groupId,
				groupOverviewPaneSource = p4.source
			}
		end

		return { userId = p3 }
	end)

	local userId = v9.userId or v8 and tostring(v8) or ""

	local v10 = React.useCallback(function(p3)
		local v11 = { name = module5.GenericWebPage, detail = p3 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			v5(module3(v11))
		end
	end, { v5 })

	local function fn2(p3)
		if
			fFlagEnableGroupOverviewPane
			and module2.CommunityListRouting.getShouldOpenGroupOverviewPane()
		then
			v6.navigate(groupsRoutes.GroupOverviewPane, { groupId = tostring(p3) })
		else
			v10(urlBuilder.user.group({ groupId = p3 }))
		end
	end

	local v13 = React.useCallback(fn2, { if fFlagEnableGroupOverviewPane then v6 else nil, v10 })

	local v14 = React.useCallback(function()
		v10(urlBuilder.new({ base = urlBase.WWW, path = "search/communities" })())
	end, { v10 })

	local v15 = React.useCallback(function()
		v10(urlBuilder.new({ base = urlBase.WWW, path = "communities/create" })())
	end, { v10 })

	local useMemo = React.useMemo
	local function fn3()
		local v18 = if fFlagEnableGroupOverviewPane then v6.goBack else nil
		return {
			navigateTo = {
				previousView = v18,
				webView = v10,
				groupDetails = v13,
				seeAllGroups = v14,
				createGroup = v15
			},
			userId = userId,
			groupId = v9.groupId,
			groupOverviewPaneSource = v9.groupOverviewPaneSource
		}
	end

	local goBack = if fFlagEnableGroupOverviewPane then v6.goBack else nil

	local groupId = if fFlagEnableGroupOverviewPane then v9.groupId else nil
	local v17 = if fFlagEnableGroupOverviewPane then v9.groupOverviewPaneSource else nil
	local v18 = useMemo(fn3, { v10, goBack, v13, v14, v15, userId, groupId, v17 })

	return React.createElement(groupsWrapperContext.Provider, { value = v18 }, {
		GroupsNavigator = React.createElement(
			groupsNavigatorWithProviders,
			not fFlagEnableGroupOverviewPane and {} or p2
		),
		AndroidBackButtonNavigationHandler = React.createElement(module6, {
			disabled = if fFlagEnableGroupOverviewPane then not v7 else nil,
			canGoBackInRN = not module7(v6.state),
			navigateBackInRN = v6.pop
		})
	})
end

local extended = React.PureComponent:extend("classWrapper")
function extended.render(p2)
	return React.createElement(fn, p2.props)
end

local v5 = if fFlagEnableGroupOverviewPane then groupsNavigatorWithProviders.router else nil
extended.router = v5

return extended
