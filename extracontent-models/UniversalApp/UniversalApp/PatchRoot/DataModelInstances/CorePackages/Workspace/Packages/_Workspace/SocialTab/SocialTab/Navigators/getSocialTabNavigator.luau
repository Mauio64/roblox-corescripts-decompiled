local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local SocialTabParent = SocialTab.Parent
local Roact = dependencies.Roact
local llama = dependencies.llama
local RoactNavigation = dependencies.RoactNavigation
local BackBehavior = dependencies.RoactNavigation.BackBehavior
local SocialTabContext = require(SocialTab.SocialTabContext)
local SocialTabEventReceiver = require(SocialTab.SocialTabEventReceiver)
local SocialTabNavigationEventReceiver = require(SocialTab.SocialTabNavigationEventReceiver)
local SocialTabContainer = require(SocialTab.Components.SocialTabContainer)
local EnumScreens = require(SocialTab.EnumScreens)
local ChatPlacementContext = require(SocialTabParent.AppChat.ChatPlacementContext)
local v14 = game:DefineFastFlag("SocialTabBarVisibleFix", false)
local v15 = game:DefineFastFlag("SocialTabBarSwitchNavUseContext2", false)
local FFlagCreateConnectionsHub = require(SocialTabParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagAppChatFixRootChatBackNavigation = require(SocialTabParent.SharedFlags).FFlagAppChatFixRootChatBackNavigation

local function getActiveChildNavigationOptions(p1) -- line: 21
	-- upvalues: getActiveChildNavigationOptions (copy), RoactNavigation (copy)
	local state = p1.state
	local index = state.index
	local v23 = state.routes and state.routes[index]

	if v23 and v23.routes then
		local v24 = p1.getChildNavigation(v23.key)

		return getActiveChildNavigationOptions(v24)
	end

	return RoactNavigation.getActiveChildNavigationOptions(p1)
end
local function getActiveRouteName(p2) -- line: 34
	-- upvalues: getActiveRouteName (copy)
	local index = p2.index
	local v27 = p2.routes and p2.routes[index]

	if v27 then
		return getActiveRouteName(v27)
	end

	return p2.routeName
end

return function(p3, p4) -- line: 44
	-- upvalues: EnumScreens (copy), Roact (copy), SocialTabContainer (copy), SocialTabNavigationEventReceiver (copy), RoactNavigation (copy), SocialTabContext (copy), llama (copy), FFlagAppChatFixRootChatBackNavigation (copy), FFlagCreateConnectionsHub (copy), ChatPlacementContext (copy), BackBehavior (copy), getActiveRouteName (copy), getActiveChildNavigationOptions (copy), v14 (copy), SocialTabEventReceiver (copy), v15 (copy)
	local t2 = {
		{
			[EnumScreens.SocialTab] = {
				screen = function(p5) -- line: 49
					-- upvalues: Roact (copy), SocialTabContainer (copy), SocialTabNavigationEventReceiver (copy), RoactNavigation (copy)
					return Roact.createFragment({
						screen = Roact.createElement(SocialTabContainer, {
							navigation = p5.navigation
						}),
						navigationEvents = Roact.createElement(SocialTabNavigationEventReceiver, {
							navigationEventReceiver = RoactNavigation.NavigationEvents
						})
					})
				end,
				navigationOptions = {
					tabBarVisible = true
				}
			}
		},
		{
			[EnumScreens.RoactChat] = {
				screen = function(p6) -- line: 66
					-- upvalues: SocialTabContext (copy), p4 (copy), EnumScreens (copy), llama (copy), FFlagAppChatFixRootChatBackNavigation (copy), FFlagCreateConnectionsHub (copy), ChatPlacementContext (copy), Roact (copy), p3 (copy)
					return SocialTabContext.with(function(p7) -- line: 67
						-- upvalues: p4 (copy), EnumScreens (copy), llama (copy), p6 (copy), FFlagAppChatFixRootChatBackNavigation (copy), FFlagCreateConnectionsHub (copy), ChatPlacementContext (copy), Roact (copy), p3 (copy)
						local t1 = {
							logger = p7.Logger,
							isLuaProfilePageEnabled = p7.isLuaProfilePageEnabled,
							parameters = p7.parameters,
							wideMode = p7.wideMode,
							isVisible = p7.isVisible,
							notificationCount = p7.notificationCount,
							navigateToLuaAppPages = p7.navigateToLuaAppPages,
							rnBypassActionSignal = p7.rnBypassActionSignal,
							setActiveConversationId = p7.setActiveConversationId,
							setBackButtonEnabled = p7.setBackButtonEnabled,
							setTabBarVisible = p7.setTabBarVisible,
							androidBackButtonSignal = p4.androidBackButtonSignal[EnumScreens.RoactChat],
							androidBackButtonConnection = p4.androidBackButtonConnection,
							updateExternalNavigationForScreen = p7.updateExternalNavigationForScreen
						}
						local v51 = llama.Dictionary.join(p6, p4, t1, {
							navigateToRootStack = function() -- line: 87
								-- upvalues: FFlagAppChatFixRootChatBackNavigation (copy), t1 (copy), EnumScreens (copy), p6 (copy)
								if FFlagAppChatFixRootChatBackNavigation then
									local v62 = t1.navigateToLuaAppPages[EnumScreens.Home]

									if v62 then
										v62()

										return
									end
								else
									p6.navigation.navigate(EnumScreens.SocialTab)
								end
							end,
							navigateToAddFriends = not FFlagCreateConnectionsHub and function() -- line: 100
								-- upvalues: p4 (copy)
								p4.navigateToAddFriends()
							end or nil
						})
						local v52 = llama.Dictionary.join(v51, {
							chatPlacement = ChatPlacementContext.Enum.ChatTab
						})

						return Roact.createElement(p3[EnumScreens.RoactChat], v52)
					end)
				end,
				navigationOptions = {
					tabBarVisible = true
				}
			}
		}
	}
	local v31 = llama.List.removeIndex(t2, 1)
	local v32 = RoactNavigation.createRobloxSwitchNavigator(v31, {
		keepVisitedScreensMounted = false,
		initialRouteName = p4.initialRouteName,
		backBehavior = BackBehavior.History
	})
	local v33 = Roact.PureComponent:extend("SocialTabSwitchNavigator")

	function v33.init(p8) -- line: 130
		-- upvalues: getActiveRouteName (copy), EnumScreens (copy), p4 (copy)
		function p8.onBackButtonPressed() -- line: 132
			-- upvalues: p8 (copy), getActiveRouteName (copy), EnumScreens (copy), p4 (copy)
			local state = p8.props.navigation.state
			local index = state.index
			local v55 = state.routes and state.routes[index]
			local v56 = if not v55 then state.routeName else getActiveRouteName(v55)

			if p8.props.androidBackButtonHandlerDisabled then
				return
			end

			if v56 == EnumScreens.RoactChat or v56 == EnumScreens.SocialTab then
				p4.androidBackButtonSignal[v56]:fire()

				return
			end

			p8.props.navigation.goBack()
		end
		function p8.isTabViewVisible() -- line: 158
			-- upvalues: p8 (copy), getActiveRouteName (copy), EnumScreens (copy)
			local state = p8.props.navigation.state
			local index = state.index
			local v59 = state.routes and state.routes[index]

			return ((if not v59 then state.routeName else getActiveRouteName(v59))) == EnumScreens.RoactChat
		end
	end
	function v33.didMount(p9) -- line: 164
		-- upvalues: p4 (copy)
		p4.connectToAndroidBackButton(p9.onBackButtonPressed)
	end
	function v33.willUnmount(_) -- line: 168
		-- upvalues: p4 (copy)
		p4.disconnectFromAndroidBackButton()
	end
	function v33.willUpdate(_, p12) -- line: 172
		-- upvalues: getActiveChildNavigationOptions (copy), RoactNavigation (copy), v14 (copy), SocialTabContext (copy), p4 (copy)
		local navigation = p12.navigation
		local state = navigation.state
		local index = state.index
		local v44 = state.routes and state.routes[index]
		local v46

		if v44 and v44.routes then
			local v45 = navigation.getChildNavigation(v44.key)

			v46 = getActiveChildNavigationOptions(v45)
		else
			v46 = RoactNavigation.getActiveChildNavigationOptions(navigation)
		end

		local v47 = v46

		if v47 and v47.tabBarVisible ~= nil then
			if v14 then
				SocialTabContext.with(function(p13) -- line: 177
					-- upvalues: v47 (copy)
					if p13.setTabBarVisible then
						p13.setTabBarVisible(v47.tabBarVisible)
					end
				end)

				return
			end

			p4.setTabBarVisible(v47.tabBarVisible)
		end
	end
	function v33.render(p14) -- line: 189
		-- upvalues: SocialTabContext (copy), Roact (copy), SocialTabEventReceiver (copy), getActiveRouteName (copy), v15 (copy), EnumScreens (copy), p4 (copy), v32 (copy)
		return SocialTabContext.with(function(p15) -- line: 190
			-- upvalues: p14 (copy), Roact (copy), SocialTabEventReceiver (copy), getActiveRouteName (copy), v15 (copy), EnumScreens (copy), p4 (copy), v32 (copy)
			if p15.isLuaProfilePageEnabled then
				p15.setIsTabBarEnabled(p14.isTabViewVisible)
			end

			return Roact.createFragment({
				eventReceiver = Roact.createElement(SocialTabEventReceiver, {
					robloxEventReceiver = p15.robloxEventReceiver,
					getActiveConversationId = p15.getActiveConversationId,
					showTabBar = function() -- line: 199
						-- upvalues: p14 (copy), getActiveRouteName (copy), v15 (copy), p15 (copy), EnumScreens (copy), p4 (copy)
						local state = p14.props.navigation.state
						local index = state.index
						local v65 = state.routes and state.routes[index]
						local v66 = if not v65 then state.routeName else getActiveRouteName(v65)

						if v15 then
							p15.setTabBarVisible(v66 == EnumScreens.RoactChat)

							return
						end

						p4.setTabBarVisible(v66 == EnumScreens.RoactChat)
					end,
					goToChat = function() -- line: 207
						-- upvalues: p14 (copy), EnumScreens (copy)
						p14.props.navigation.navigate(EnumScreens.RoactChat)
					end
				}),
				switchNavigator = Roact.createElement(v32, {
					navigation = p14.props.navigation
				})
			})
		end)
	end

	v33.router = v32.router

	return v33
end
