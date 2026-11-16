local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local RoactNavigation = require(parent.RoactNavigation)
local LibraryBrowserContainer = require(script.Parent.LibraryBrowser.LibraryBrowserContainer)
local LibraryCategoryContainer = require(script.Parent.LibraryCategory.LibraryCategoryContainer)
local LibraryDetailContainer = require(script.Parent.LibraryDetail.LibraryDetailContainer)
require(BuildExperience.Stores.BuildLibrary.createBuildLibraryStore)
require(script.Parent.LibraryCategories)
require(script.Parent.LibraryTypes)
require(script.Parent.LibraryWorldCutout.LibraryWorldCutoutView)
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function getTransitionConfig(p, p2)
	local routeName

	if p2 ~= nil then
		routeName = p2.scene.route.routeName
	end

	local routeName2 = p.scene.route.routeName
	local v = routeName2 == "Search" or routeName == "Search"
	local v2 = routeName2 == "Detail" or routeName == "Detail"

	if v and not v2 then
		local clone = table.clone(RoactNavigation.StackViewTransitionConfigs.FadeInPlace)
		function clone.screenInterpolator(p3)
			return {
				initialPosition = UDim2.fromScale(0, 0),
				forceHidden = p3.scene.index ~= p.index and (p2 == nil or p3.scene.index ~= p2.index)
			}
		end

		return clone
	elseif UserGameSettings.ReducedMotion then
		return RoactNavigation.StackViewTransitionConfigs.FadeInPlace
	else
		return RoactNavigation.StackViewTransitionConfigs.SlideFromRight
	end
end

local function BrowserScreen(p)
	local screenProps = p.screenProps
	return React.createElement(LibraryBrowserContainer, {
		onOpenItem = screenProps.onOpenItem,
		onOpenCategory = screenProps.onOpenCategory,
		library = screenProps.library,
		isReady = screenProps.isReady,
		query = "",
		worldCutout = screenProps.worldCutout
	})
end

local function CategoryScreen(p)
	local screenProps = p.screenProps
	local params = p.navigation.state.params
	local ref = React.useRef(screenProps.query)

	if screenProps.query ~= "" then
		ref.current = screenProps.query
	end

	return React.createElement(LibraryCategoryContainer, {
		itemKind = params.itemKind,
		categoryKey = params.categoryKey,
		folderId = params.folderId,
		query = p.navigation.state.routeName ~= "Search" and "" or ref.current,
		onOpenItem = screenProps.onOpenItem,
		onOpenCategory = screenProps.onOpenCategory,
		library = screenProps.library,
		isReady = screenProps.isReady
	})
end

local function SearchScreen(p)
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion or UserGameSettings.ReducedMotion
	local v = p.screenProps.query ~= ""
	local v2, v3 = Motion.useMotion({
		transparency = reducedMotion and 0 or 1
	})
	React.useEffect(function()
		v3(Motion.createState({
			transparency = v and 0 or 1
		}, {
			default = Motion.transition({
				duration = reducedMotion and 0 or 0.15
			})
		}))
	end, { v, reducedMotion, v3 })
	return React.createElement(
		Foundation.View,
		{
			GroupTransparency = v2.transparency,
			tag = "size-full bg-surface-0",
			testId = "Library.Search.Results"
		},
		{
			Grid = React.createElement(CategoryScreen, p)
		}
	)
end

local function DetailScreen(p)
	local screenProps = p.screenProps
	local state = p.navigation.state
	local v = screenProps.activeRouteKey == state.key
	return React.createElement(LibraryDetailContainer, {
		isActive = screenProps.isOpen and v,
		itemId = state.params.itemId,
		itemKind = state.params.itemKind,
		library = screenProps.library,
		isReady = screenProps.isReady,
		onBack = function()
			if v then
				screenProps.onBack()
			end
		end,
		chatActions = screenProps.chatActions,
		resourceActions = screenProps.resourceActions,
		unavailableText = screenProps.unavailableText
	})
end

return RoactNavigation.createAppContainer(RoactNavigation.createRobloxStackNavigator({
	{
		Browser = { screen = BrowserScreen }
	},
	{
		Category = { screen = CategoryScreen }
	},
	{
		Search = {
			screen = SearchScreen,
			navigationOptions = { transparent = true }
		}
	},
	{
		Detail = { screen = DetailScreen }
	}
}, {
	initialRouteName = "Browser",
	transitionConfig = getTransitionConfig,
	defaultNavigationOptions = { absorbInputSelectable = false }
}))
