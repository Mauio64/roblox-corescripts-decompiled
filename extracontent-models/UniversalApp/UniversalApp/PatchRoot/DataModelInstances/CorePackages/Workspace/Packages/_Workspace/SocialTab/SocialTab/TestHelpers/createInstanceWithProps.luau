local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local Roact = dependencies.Roact
local Rodux = dependencies.Rodux
local RoactRodux = dependencies.RoactRodux
local ApolloClient = require(SocialTabParent.ApolloClient)
local GraphQLServer = require(SocialTabParent.GraphQLServer)
local UserProfiles = require(SocialTabParent.UserProfiles)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient
local UnitTestHelpers = require(SocialTab.devDependencies).UnitTestHelpers
local v12 = Rodux.Store.new(function(p1, _) -- line: 17
	return p1
end, {
	ScreenSize = Vector2.new(100, 100)
}, { Rodux.thunkMiddleware })

return function(p3, p4, p5) -- line: 23
	-- upvalues: mockApolloClient (copy), UserProfiles (copy), Roact (copy), ApolloClient (copy), RoactRodux (copy), v12 (copy), UnitTestHelpers (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Parent = game:GetService("CoreGui")

	local v19 = mockApolloClient({})

	v19:writeQuery({
		variables = {
			userIds = { "1" }
		},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
		data = {
			userProfiles = {{
				__typename = "UserProfile",
				id = "1",
				names = {
					__typename = "Names",
					combinedName = "Stacey",
					username = "This shouldn't show"
				}
			}}
		}
	})
	v19:writeQuery({
		variables = {
			userIds = { "test" }
		},
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds,
		data = {
			userProfiles = {{
				__typename = "UserProfile",
				id = "test",
				names = {
					__typename = "Names",
					combinedName = "DisplayName",
					username = "Username"
				}
			}}
		}
	})

	local v20 = if p5 then Roact.createElement("Frame", {
		Size = p5
	}, {
		testElement = Roact.createElement(p3, p4)
	}) else Roact.createElement(p3, p4)
	local v21 = Roact.createFragment({
		apolloProvider = Roact.createElement(ApolloClient.ApolloProvider, {
			client = v19
		}, {
			storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = v12
			}, {
				styleProvider = UnitTestHelpers.createStyleProvider({
					myElement = v20
				})
			})
		})
	})
	local v22 = Roact.mount(UnitTestHelpers.mockLocale(v21), ScreenGui)

	return ScreenGui, function() -- line: 94
		-- upvalues: Roact (copy), v22 (copy), ScreenGui (copy)
		Roact.unmount(v22)
		ScreenGui:Destroy()
	end
end
