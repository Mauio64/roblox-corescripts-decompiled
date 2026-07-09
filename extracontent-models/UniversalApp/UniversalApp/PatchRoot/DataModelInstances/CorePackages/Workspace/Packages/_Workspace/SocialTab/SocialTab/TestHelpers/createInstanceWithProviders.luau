local SocialTab = script:FindFirstAncestor("SocialTab")
local Analytics = require(SocialTab.Analytics)
local SocialTabContext = require(SocialTab.SocialTabContext)
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local Rodux = dependencies.Rodux
local RoactRodux = dependencies.RoactRodux
local Mock = dependencies.Mock
local ApolloClient = require(SocialTabParent.ApolloClient)
local mockApolloClient = require(SocialTabParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local UnitTestHelpers = require(SocialTab.devDependencies).UnitTestHelpers
local v13 = Rodux.Store.new(function(p1, _) -- line: 20
	return p1
end, {
	ScreenSize = Vector2.new(100, 100)
}, { Rodux.thunkMiddleware })

return function(p3, t1: {[any]: any}) -- line: 32
	-- upvalues: Mock (copy), mockApolloClient (copy), Roact (copy), ApolloClient (copy), RoactRodux (copy), v13 (copy), UnitTestHelpers (copy), dependencies (copy), Analytics (copy), SocialTabContext (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Parent = game:GetService("CoreGui")

	local v19 = Mock.MagicMock.new()
	local v20 = mockApolloClient({})

	v19.wideMode = true
	v19.isLuaProfilePageEnabled = true

	local v21 = Roact.createFragment({ Roact.createElement(ApolloClient.ApolloProvider, {
		client = v20
	}, {
		storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
			store = t1.store or v13
		}, {
			styleProvider = UnitTestHelpers.createStyleProvider({
				policyProvider = Roact.createElement(dependencies.UniversalAppPolicy.Provider, {
					policy = t1.policy or { function() -- line: 51
						return {
							getShowDisplayName = function() -- line: 53
								return true
							end,
							getFriendFinder = function() -- line: 56
								return true
							end,
							getAccountProviderName = function() -- line: 59
								return ""
							end,
							shouldInviteFromAccountProvider = function() -- line: 62
								return true
							end,
							getShouldShowGroupsTile = function() -- line: 65
								return true
							end,
							getChatHeaderNotifications = function() -- line: 68
								return true
							end,
							getContactImporterEnabled = function() -- line: 71
								return true
							end,
							getWebViewSupport = function() -- line: 74
								return true
							end,
							getNotificationsCanReceiveStream = function() -- line: 77
								return true
							end
						}
					end }
				}, {
					analyticsProvider = Roact.createElement(Analytics.Context.Provider, {
						value = Mock.MagicMock.new()
					}, {
						socialTabContext = Roact.createElement(SocialTabContext.Provider, {
							value = v19
						}, {
							myElement = Roact.createElement(p3, t1.props)
						})
					})
				})
			})
		})
	}) })
	local v22 = Roact.mount(UnitTestHelpers.mockLocale(v21), ScreenGui)

	return ScreenGui, function() -- line: 100
		-- upvalues: Roact (copy), v22 (copy), ScreenGui (copy)
		Roact.unmount(v22)
		ScreenGui:Destroy()
	end
end
