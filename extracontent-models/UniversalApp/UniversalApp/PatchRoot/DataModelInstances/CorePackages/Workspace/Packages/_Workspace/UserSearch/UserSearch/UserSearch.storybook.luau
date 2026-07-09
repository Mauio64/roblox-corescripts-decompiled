local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local Roact = require(UserSearchParent.Roact)
local Dash = require(UserSearchParent.Dash)
local UIBlox = require(UserSearchParent.UIBlox)
local RoactRodux = require(UserSearchParent.RoactRodux)
local Rodux = require(UserSearchParent.Rodux)
local mockLocale = require(UserSearchParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local ApolloClient = require(UserSearchParent.ApolloClient)
local mockApolloClient = require(UserSearchParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local RobloxAppUIBloxConfig = require(UserSearchParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({
	elementTracing = true
})

local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}
local t2 = {
	language = "en-us"
}

local function v15(p1) -- line: 44
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 45
		-- upvalues: p1 (copy)
		return p1
	end, {}, { Rodux.thunkMiddleware })
end

return {
	name = "UserSearch",
	storyRoot = UserSearch,
	roact = Roact,
	mapDefinition = function(t3: {[any]: any}) -- line: 54
		-- upvalues: Dash (copy), t2 (copy)
		local v18 = Dash.join(t2, t3.controls or {})

		return Dash.join(t3, {
			controls = v18,
			state = t3.state or {}
		})
	end,
	mapStory = function(p2) -- line: 61
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), v15 (copy), ApolloClient (copy), mockApolloClient (copy), mockLocale (copy)
		return function(p3) -- line: 62
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), v15 (copy), ApolloClient (copy), mockApolloClient (copy), mockLocale (copy), p2 (copy)
			local v21 = p3.definition.state or {}

			return Roact.createElement(AppStyleProvider, {
				style = p3 and t1[p3.theme] or t1.Default
			}, {
				storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
					store = v15(v21)
				}, {
					apolloClient = Roact.createElement(ApolloClient.ApolloProvider, {
						client = mockApolloClient({})
					}, {
						Child = mockLocale(p2, p3)
					})
				})
			})
		end
	end
}
