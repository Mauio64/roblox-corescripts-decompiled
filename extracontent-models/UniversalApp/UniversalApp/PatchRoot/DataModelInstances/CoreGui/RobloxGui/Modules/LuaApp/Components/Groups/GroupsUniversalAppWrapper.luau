local CorePackages = game:GetService("CorePackages")
local Modules = script:FindFirstAncestor("Modules")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local Groups = require(CorePackages.Workspace.Packages.Groups)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v12 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local AppPage = require(Modules.LuaApp.AppPage)
local Container = require(Modules.LuaApp.Navigation.AndroidBackButtonNavigationHandler.Container)
local isRootRouteInRN = require(Modules.LuaApp.Navigation.isRootRouteInRN)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase
local GroupsNavigatorWithProviders = Groups.Navigation.GroupsNavigatorWithProviders
local GroupsWrapperContext = Groups.Contexts.GroupsWrapperContext

local function v21(_) -- line: 39
	-- upvalues: useDispatch (copy), useNavigation (copy), useLocalUserId (copy), useNavigationProps (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), NavigateDown (copy), UrlBuilder2 (copy), UrlBase (copy), GroupsWrapperContext (copy), GroupsNavigatorWithProviders (copy), Container (copy), isRootRouteInRN (copy)
	local v24 = useDispatch()
	local v25 = useNavigation()
	local v26 = useLocalUserId()
	local v27 = useNavigationProps(function(p2, _) -- line: 44
		return {
			userId = p2
		}
	end).userId or (v26 and tostring(v26) or "")
	local v28 = React.useCallback(function(s1: string) -- line: 52
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v12 (copy), v24 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.GenericWebPage,
			detail = s1
		}

		if FFlagSignalsNavP3Dispatch then
			v12.down(v12.fromLegacyPage(t1))

			return
		end

		v24(NavigateDown(t1))
	end, { v24 })
	local v29 = React.useCallback(function(p4) -- line: 64
		-- upvalues: v28 (copy), UrlBuilder2 (copy)
		v28(UrlBuilder2.user.group({
			groupId = p4
		}))
	end, { v28 })
	local v30 = React.useCallback(function() -- line: 68
		-- upvalues: v28 (copy), UrlBuilder2 (copy), UrlBase (copy)
		v28(UrlBuilder2.new({
			path = "search/communities",
			base = UrlBase.WWW
		})())
	end, { v28 })
	local v31 = React.useCallback(function() -- line: 75
		-- upvalues: v28 (copy), UrlBuilder2 (copy), UrlBase (copy)
		v28(UrlBuilder2.new({
			path = "communities/create",
			base = UrlBase.WWW
		})())
	end, { v28 })
	local v32 = React.useMemo(function() -- line: 83
		-- upvalues: v28 (copy), v29 (copy), v30 (copy), v31 (copy), v27 (copy)
		return {
			navigateTo = {
				webView = v28,
				groupDetails = v29,
				seeAllGroups = v30,
				createGroup = v31
			},
			userId = v27
		}
	end, {
		v28,
		v29,
		v30,
		v31,
		v27
	})

	return React.createElement(GroupsWrapperContext.Provider, {
		value = v32
	}, {
		GroupsNavigator = React.createElement(GroupsNavigatorWithProviders, {}),
		AndroidBackButtonNavigationHandler = React.createElement(Container, {
			canGoBackInRN = not isRootRouteInRN(v25.state),
			navigateBackInRN = v25.pop
		})
	})
end

local v22 = React.PureComponent:extend("classWrapper")

function v22.render(p5) -- line: 107
	-- upvalues: React (copy), v21 (copy)
	return React.createElement(v21, p5.props)
end

return v22
