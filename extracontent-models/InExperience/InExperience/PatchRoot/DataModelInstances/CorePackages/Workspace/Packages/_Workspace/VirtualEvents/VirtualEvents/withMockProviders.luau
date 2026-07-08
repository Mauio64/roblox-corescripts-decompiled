local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local ApolloClient = require(VirtualEvents.Parent.ApolloClient)
local GraphQLServer = require(VirtualEvents.Parent.GraphQLServer)
local React = require(VirtualEvents.Parent.React)
local Rodux = require(VirtualEvents.Parent.Rodux)
local RoactNavigation = require(VirtualEvents.Parent.RoactNavigation)
local RoactRodux = require(VirtualEvents.Parent.RoactRodux)
local RobloxAppLocales = require(VirtualEvents.Parent.RobloxAppLocales)
local Localization = require(VirtualEvents.Parent.Localization)
local UIBlox = require(VirtualEvents.Parent.UIBlox)
local DesignTokenProvider = require(VirtualEvents.Parent.Style).DesignTokenProvider
local VirtualEventsState = require(VirtualEvents.Parent.VirtualEventsState)
local MockContentProvider = UIBlox.UnitTestHelpers.MockContentProvider
local FoundationProvider = require(VirtualEvents.Parent.Foundation).FoundationProvider
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local ContentProvider = UIBlox.App.Context.ContentProvider
local v18 = Rodux.combineReducers({
	VirtualEvents = VirtualEventsState.installReducer()
})

local function withMockProviders(t1: {[any]: any}, t2: {[any]: any}?) -- line: 32
	-- upvalues: Rodux (copy), v18 (copy), React (copy), RoactRodux (copy), ContentProvider (copy), MockContentProvider (copy), Localization (copy), RobloxAppLocales (copy), FoundationProvider (copy), AppStyleProvider (copy), Constants (copy), RoactNavigation (copy), DesignTokenProvider (copy), GraphQLServer (copy), ApolloClient (copy)
	local v22 = ((if not t2 then nil else t2.store)) or Rodux.Store.new(v18, if not t2 then nil else t2.initialStoreState, { Rodux.thunkMiddleware })
	local t3 = {
		StoreProvider = React.createElement(RoactRodux.StoreProvider, {
			store = v22
		}, {
			ContentProvider = React.createElement(ContentProvider.Provider, {
				value = MockContentProvider.new()
			}, {
				LocalizationProvider = React.createElement(Localization.LocalizationProvider, {
					localization = RobloxAppLocales.Localization.new("en-us")
				}, {
					FoundationProvider = React.createElement(FoundationProvider, {
						theme = "Dark"
					}, {
						StyleProvider = React.createElement(AppStyleProvider, {
							style = {
								themeName = Constants.ThemeName.Dark,
								fontName = Constants.FontName.Gotham
							}
						}, {
							NavigationProvider = React.createElement(RoactNavigation.Provider, {
								value = {
									isFocused = function() -- line: 61
										return true
									end,
									goBack = function() -- line: 64
									end,
									addListener = function() -- line: 65
										return {
											remove = function() -- line: 67
											end
										}
									end
								}
							}, {
								DesignTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Children = React.createElement(React.Fragment, nil, t1)
								})
							})
						})
					})
				})
			})
		})
	}

	if t2 then
		if t2.mockResolvers then
			local v24 = GraphQLServer.GraphQLServer.new({
				mockResolvers = t2.mockResolvers
			})
			local v25 = ApolloClient.ApolloClient.new({
				cache = ApolloClient.InMemoryCache.new({}),
				link = ApolloClient.HttpLink.new({
					uri = "/api",
					fetch = function(_, p2) -- line: 95
						-- upvalues: v24 (copy)
						return v24:fetchLocal(p2)
					end
				})
			})

			t3 = {
				ApolloProvider = React.createElement(ApolloClient.ApolloProvider, {
					client = v25
				}, t3)
			}
		end

		if t2.mockNavigation then
			t3 = {
				NavigationProvider = React.createElement(RoactNavigation.Provider, {
					value = t2.mockNavigation
				}, t3)
			}
		end
	end

	return React.createElement(React.Fragment, nil, t3)
end

return withMockProviders
