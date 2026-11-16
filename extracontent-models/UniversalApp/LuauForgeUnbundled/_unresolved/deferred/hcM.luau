local module = require("@luauforge/deferred/hbU")

local roact = module.Roact
local llama = module.llama
local roactNavigation = module.RoactNavigation
local backBehavior = module.RoactNavigation.BackBehavior
local Context = require("@game/CorePackages/Packages/_Index/SocialLibraries/SocialLibraries/Context")
local module3 = require("@luauforge/deferred/hcN")
local module4 = require("@luauforge/deferred/hcO")
local module5 = require("@luauforge/deferred/hcP")
local fFlagCreateConnectionsHub = require("@luauforge/deferred/hbX").FFlagCreateConnectionsHub
local fFlagAppChatFixRootChatBackNavigation = require("@luauforge/deferred/hbX").FFlagAppChatFixRootChatBackNavigation
local function getActiveChildNavigationOptions(p2)
	local state = p2.state
	local index = state.index
	local v5 = state.routes and state.routes[index]

	if v5 and v5.routes then
		return getActiveChildNavigationOptions((p2.getChildNavigation(v5.key)))
	end

	return roactNavigation.getActiveChildNavigationOptions(p2)
end

local function getActiveRouteName(data)
	local index = data.index
	local v5 = data.routes and data.routes[index]

	if v5 then
		return getActiveRouteName(v5)
	end

	return data.routeName
end

return function(p2, data)
	local v5 = {
		[module4.RoactChat] = {
			screen = function(p3)
				return Context.with(function(props)
					local v6 = {
						logger = props.Logger,
						isLuaProfilePageEnabled = props.isLuaProfilePageEnabled,
						parameters = props.parameters,
						wideMode = props.wideMode,
						isVisible = props.isVisible,
						notificationCount = props.notificationCount,
						navigateToLuaAppPages = props.navigateToLuaAppPages,
						rnBypassActionSignal = props.rnBypassActionSignal,
						setActiveConversationId = props.setActiveConversationId,
						setBackButtonEnabled = props.setBackButtonEnabled,
						setTabBarVisible = props.setTabBarVisible,
						androidBackButtonSignal = data.androidBackButtonSignal[module4.RoactChat],
						androidBackButtonConnection = data.androidBackButtonConnection,
						updateExternalNavigationForScreen = props.updateExternalNavigationForScreen
					}

					local joined = llama.Dictionary.join(p3, data, v6, {
						navigateToRootStack = function()
							if fFlagAppChatFixRootChatBackNavigation then
								local navigateToLuaAppPage = v6.navigateToLuaAppPages[module4.Home]

								if navigateToLuaAppPage then
									navigateToLuaAppPage()
								end
							else
								p3.navigation.navigate(module4.SocialTab)
							end
						end,
						navigateToAddFriends = not fFlagCreateConnectionsHub and function()
							data.navigateToAddFriends()
						end or nil
					})

					local joined2 = llama.Dictionary.join(joined, {
						chatPlacement = module5.Enum.ChatTab
					})

					return roact.createElement(p2[module4.RoactChat], joined2)
				end)
			end,
			navigationOptions = { tabBarVisible = true }
		}
	}

	local robloxSwitchNavigator = roactNavigation.createRobloxSwitchNavigator({ v5 }, {
		initialRouteName = data.initialRouteName,
		keepVisitedScreensMounted = false,
		backBehavior = backBehavior.History
	})

	local extended = roact.PureComponent:extend("SocialTabSwitchNavigator")

	function extended:init()
		function self.onBackButtonPressed()
			local state = self.props.navigation.state
			local index = state.index
			local v6 = state.routes and state.routes[index]

			local v7 = if v6 then getActiveRouteName(v6) else state.routeName

			if self.props.androidBackButtonHandlerDisabled then
				return
			end

			if v7 == module4.RoactChat or v7 == module4.SocialTab then
				data.androidBackButtonSignal[v7]:fire()
			else
				self.props.navigation.goBack()
			end
		end

		function self.isTabViewVisible(): boolean
			local state = self.props.navigation.state
			local index = state.index
			local v6 = state.routes and state.routes[index]

			return (if v6 then getActiveRouteName(v6) else state.routeName) == module4.RoactChat
		end
	end

	function extended.didMount(p3)
		data.connectToAndroidBackButton(p3.onBackButtonPressed)
	end

	function extended.willUnmount(p3)
		data.disconnectFromAndroidBackButton()
	end

	function extended.willUpdate(p3, p4)
		local navigation = p4.navigation
		local state = navigation.state
		local index = state.index
		local v6 = state.routes and state.routes[index]
		local v7

		if v6 and v6.routes then
			v7 = getActiveChildNavigationOptions((navigation.getChildNavigation(v6.key)))
		else
			v7 = roactNavigation.getActiveChildNavigationOptions(navigation)
		end

		if v7 and v7.tabBarVisible ~= nil then
			Context.with(function(p5)
				if p5.setTabBarVisible then
					p5.setTabBarVisible(v7.tabBarVisible)
				end
			end)
		end
	end

	function extended.render(p3)
		return Context.with(function(props)
			if props.isLuaProfilePageEnabled then
				props.setIsTabBarEnabled(p3.isTabViewVisible)
			end

			return roact.createFragment({
				eventReceiver = roact.createElement(module3, {
					robloxEventReceiver = props.robloxEventReceiver,
					getActiveConversationId = props.getActiveConversationId,
					showTabBar = function()
						local state = p3.props.navigation.state
						local index = state.index
						local v6 = state.routes and state.routes[index]

						local v7 = if v6 then getActiveRouteName(v6) else state.routeName

						props.setTabBarVisible(v7 == module4.RoactChat)
					end,
					goToChat = function()
						p3.props.navigation.navigate(module4.RoactChat)
					end
				}),
				switchNavigator = roact.createElement(robloxSwitchNavigator, {
					navigation = p3.props.navigation
				})
			})
		end)
	end

	extended.router = robloxSwitchNavigator.router

	return extended
end
