local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local scriptParent = script.Parent
local Reducers = scriptParent.Reducers
local Reducer = require(Reducers.Reducer)
local Connection = script.Parent.Components.Connection
local Provider = require(Connection.LayoutValues).Provider
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local LayoutValuesContext = PlayerList.Common.LayoutValuesContext
local LeaderboardStoreContext = PlayerList.LeaderboardStoreContext
local v15 = require(CorePackages.Workspace.Packages.LeaderboardStore).dev.createMockLeaderboardStore()()
local ApolloProvider = require(CorePackages.Packages.ApolloClient).ApolloProvider
local mockApolloClient = require(CorePackages.Workspace.Packages.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local Array = require(CorePackages.Packages.LuauPolyfill).Array
local CreateLayoutValues = require(scriptParent.CreateLayoutValues)

local function TestProviders(p1) -- line: 37
	-- upvalues: Rodux (copy), Reducer (copy), mockApolloClient (copy), Array (copy), Roact (copy), RoactRodux (copy), ApolloProvider (copy), Provider (copy), CreateLayoutValues (copy), UIBlox (copy), Foundation (copy), LayoutValuesContext (copy), LeaderboardStoreContext (copy), v15 (copy)
	local v22 = Rodux.Store.new(Reducer)
	local v23 = mockApolloClient({
		mockResolvers = {
			Query = {
				userProfiles = function(_, p3, _, _) -- line: 42
					-- upvalues: Array (copy)
					return (Array.map(p3.userIds, function(p6) -- line: 43
						return {
							userId = p6,
							names = {
								alias = `alias{ p6 }`,
								combinedName = `combinedName{ p6 }`,
								contactName = `contactName{ p6 }`,
								displayName = `displayName{ p6 }`,
								username = `username{ p6 }`,
								platformName = `platformName{ p6 }`,
								inExperienceCombinedName = `inExperienceCombinedName{ p6 }`
							}
						}
					end))
				end
			},
			UserProfile = {
				id = function(p7) -- line: 61
					return (tostring(p7.userId))
				end,
				names = function(p8) -- line: 64
					return p8.names
				end
			}
		}
	})

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = p1.store or v22
	}, {
		ApolloProvider = Roact.createElement(ApolloProvider, {
			client = p1.client or v23
		}, {
			LayoutValuesProvider_DEPRECATED = Roact.createElement(Provider, {
				layoutValues = p1.layoutValues or CreateLayoutValues(false)
			}, {
				ThemeProvider = Roact.createElement(UIBlox.App.Style.AppStyleProvider, {}, {
					FoundationProvider = Roact.createElement(Foundation.FoundationProvider, {
						theme = Foundation.Enums.Theme.Dark
					}, {
						LayoutValuesProvider = Roact.createElement(LayoutValuesContext.Provider, {
							value = p1.layoutValues or CreateLayoutValues(false)
						}, {
							LeaderboardStoreProvider = Roact.createElement(LeaderboardStoreContext.Provider, {
								value = p1.leaderboardStore or v15
							}, p1.children)
						})
					})
				})
			})
		})
	})
end

return TestProviders
