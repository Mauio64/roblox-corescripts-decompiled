local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Roact = require(parent.Roact)
local Dash = require(parent.Dash)
local UIBlox = require(parent.UIBlox)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)

local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale
local ApolloClient = require(parent.ApolloClient)
local GraphQLServer = require(parent.GraphQLServer)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient

local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({ elementTracing = true })

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }

local function fn(state)
	return Rodux.Store.new(function()
		return state
	end, {}, { Rodux.thunkMiddleware })
end

local Storybook = {}
Storybook.name = "UserSearch"
Storybook.storyRoot = UserSearch
Storybook.roact = Roact

function Storybook.mapDefinition(p)
	local joined = Dash.join(v2, p.controls or {})
	return Dash.join(p, {
		controls = joined,
		state = p.state or {}
	})
end

function Storybook.mapStory(p)
	return function(p2)
		local state = p2.definition.state or {}
		return Roact.createElement(AppStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, {
			storeProvider = Roact.createElement(RoactRodux.StoreProvider, { store = fn(state) }, {
				apolloClient = Roact.createElement(ApolloClient.ApolloProvider, {
					client = mockApolloClient({})
				}, {
					Child = mockLocale(p, p2)
				})
			})
		})
	end
end

return Storybook
