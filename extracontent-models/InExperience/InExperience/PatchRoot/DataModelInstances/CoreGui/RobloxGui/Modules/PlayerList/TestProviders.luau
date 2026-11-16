local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local parent = script.Parent
local reducers = parent.Reducers
local Reducer = require(reducers.Reducer)

local Connection = script.Parent.Components.Connection
local LayoutValues = require(Connection.LayoutValues)
local Provider = LayoutValues.Provider

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local LayoutValuesContext = PlayerList.Common.LayoutValuesContext
local LeaderboardStoreContext = PlayerList.LeaderboardStoreContext

local LeaderboardStore = require(CorePackages.Workspace.Packages.LeaderboardStore)
local v = LeaderboardStore.dev.createMockLeaderboardStore()()

local ApolloClient = require(CorePackages.Packages.ApolloClient)
local ApolloProvider = ApolloClient.ApolloProvider

local GraphQLServer = require(CorePackages.Workspace.Packages.GraphQLServer)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient

local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

local CreateLayoutValues = require(parent.CreateLayoutValues)

local function TestProviders(props)
	local store = Rodux.Store.new(Reducer)
	local v2 = mockApolloClient({
		mockResolvers = {
			Query = {
				userProfiles = function(_, p, _, _)
					return (Array.map(p.userIds, function(userId)
						return {
							userId = userId,
							names = {
								alias = `alias{userId}`,
								combinedName = `combinedName{userId}`,
								contactName = `contactName{userId}`,
								displayName = `displayName{userId}`,
								username = `username{userId}`,
								platformName = `platformName{userId}`,
								inExperienceCombinedName = `inExperienceCombinedName{userId}`
							}
						}
					end))
				end
			},
			UserProfile = {
				id = function(p)
					return (tostring(p.userId))
				end,
				names = function(p)
					return p.names
				end
			}
		}
	})

	return Roact.createElement(RoactRodux.StoreProvider, {
		store = props.store or store
	}, {
		ApolloProvider = Roact.createElement(ApolloProvider, {
			client = props.client or v2
		}, {
			LayoutValuesProvider_DEPRECATED = Roact.createElement(Provider, {
				layoutValues = props.layoutValues or CreateLayoutValues(false)
			}, {
				ThemeProvider = Roact.createElement(UIBlox.App.Style.AppStyleProvider, {}, {
					FoundationProvider = Roact.createElement(
						Foundation.FoundationProvider,
						{ colorMode = Foundation.Enums.ColorMode.Dark },
						{
							LayoutValuesProvider = Roact.createElement(LayoutValuesContext.Provider, {
								value = props.layoutValues or CreateLayoutValues(false)
							}, {
								LeaderboardStoreProvider = Roact.createElement(LeaderboardStoreContext.Provider, {
									value = props.leaderboardStore or v
								}, props.children)
							})
						}
					)
				})
			})
		})
	})
end

return TestProviders
