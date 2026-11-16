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
local Style = require(VirtualEvents.Parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local VirtualEventsState = require(VirtualEvents.Parent.VirtualEventsState)
local MockContentProvider = UIBlox.UnitTestHelpers.MockContentProvider
local Foundation = require(VirtualEvents.Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local ContentProvider = UIBlox.App.Context.ContentProvider

local combineReducers = Rodux.combineReducers({
	VirtualEvents = VirtualEventsState.installReducer()
})

local function withMockProviders(p, props)
	local store

	if props then
		store = props.store
	end

	if not store then
		local new = Rodux.Store.new
		local v

		if props then
			v = props.initialStoreState
		end

		store = new(combineReducers, v, { Rodux.thunkMiddleware })
	end

	local v = {
		StoreProvider = React.createElement(RoactRodux.StoreProvider, { store = store }, {
			ContentProvider = React.createElement(ContentProvider.Provider, {
				value = MockContentProvider.new()
			}, {
				LocalizationProvider = React.createElement(
					Localization.LocalizationProvider,
					{
						localization = RobloxAppLocales.Localization.new("en-us")
					},
					{
						FoundationProvider = React.createElement(FoundationProvider, {
							colorMode = ColorMode.Dark
						}, {
							StyleProvider = React.createElement(AppStyleProvider, {
								style = {
									themeName = ColorMode.Dark,
									fontName = Constants.FontName.Gotham
								}
							}, {
								NavigationProvider = React.createElement(RoactNavigation.Provider, {
									value = {
										isFocused = function(): boolean
											return true
										end,
										goBack = function() end,
										addListener = function()
											return {
												remove = function() end
											}
										end
									}
								}, {
									DesignTokenProvider = React.createElement(
										DesignTokenProvider,
										{ tokenMappers = {} },
										{
											Children = React.createElement(React.Fragment, nil, p)
										}
									)
								})
							})
						})
					}
				)
			})
		})
	}

	if props then
		if props.mockResolvers then
			local graphQLServer = GraphQLServer.GraphQLServer.new({
				mockResolvers = props.mockResolvers
			})

			local apolloClient = ApolloClient.ApolloClient.new({
				cache = ApolloClient.InMemoryCache.new({}),
				link = ApolloClient.HttpLink.new({
					uri = "/api",
					fetch = function(_, p2)
						return graphQLServer:fetchLocal(p2)
					end
				})
			})

			v = {
				ApolloProvider = React.createElement(ApolloClient.ApolloProvider, {
					client = apolloClient
				}, v)
			}
		end

		v = props.mockNavigation and {
			NavigationProvider = React.createElement(RoactNavigation.Provider, {
				value = props.mockNavigation
			}, v)
		} or v
	end

	return React.createElement(React.Fragment, nil, v)
end

return withMockProviders
