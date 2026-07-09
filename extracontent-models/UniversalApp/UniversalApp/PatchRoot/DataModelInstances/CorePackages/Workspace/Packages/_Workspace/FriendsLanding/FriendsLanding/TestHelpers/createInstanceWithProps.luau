local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local devDependencies = require(FriendsLanding.devDependencies)
local Roact = dependencies.Roact
local Rodux = dependencies.Rodux
local RoactRodux = dependencies.RoactRodux
local UnitTestHelpers = devDependencies.UnitTestHelpers
local installReducer = require(FriendsLanding.installReducer)
local ApolloClient = require(FriendsLandingParent.ApolloClient)
local mockApolloClient = require(FriendsLandingParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient

return function(p1) -- line: 19
	-- upvalues: Roact (copy), Rodux (copy), installReducer (copy), UnitTestHelpers (copy), ApolloClient (copy), mockApolloClient (copy), RoactRodux (copy)
	return function(p2, p3, p4) -- line: 20
		-- upvalues: Roact (copy), Rodux (copy), installReducer (copy), UnitTestHelpers (copy), ApolloClient (copy), mockApolloClient (copy), RoactRodux (copy), p1 (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Parent = game:GetService("CoreGui")

		local v17 = if p4 then Roact.createElement("Frame", {
			Size = p4
		}, {
			testElement = Roact.createElement(p2, p3)
		}) else Roact.createElement(p2, p3)
		local v18 = Rodux.Store.new(Rodux.combineReducers({
			FriendsLanding = installReducer(),
			LocalUserId = function(p5) -- line: 38
				return p5
			end
		}), {}, { Rodux.thunkMiddleware })
		local v19 = Roact.createFragment({
			styleProvider = UnitTestHelpers.createStyleProvider({
				apolloClient = Roact.createElement(ApolloClient.ApolloProvider, {
					client = mockApolloClient({})
				}, {
					StoreProvider = Roact.createElement(RoactRodux.StoreProvider, {
						store = v18
					}, {
						myElement = v17
					})
				})
			})
		})
		local v20 = Roact.mount(p1(v19), ScreenGui)

		return ScreenGui, function() -- line: 60
			-- upvalues: Roact (copy), v20 (copy), ScreenGui (copy)
			Roact.unmount(v20)
			ScreenGui:Destroy()
		end
	end
end
