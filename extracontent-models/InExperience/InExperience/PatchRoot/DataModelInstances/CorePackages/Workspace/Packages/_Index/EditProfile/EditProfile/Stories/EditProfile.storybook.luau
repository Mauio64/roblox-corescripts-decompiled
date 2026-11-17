local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent

local UIBlox = require(parent.UIBlox)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Cryo = require(parent.Cryo)
local Style = require(parent.Style)
local ApolloClient = require(parent.ApolloClient)
local Foundation = require(parent.Foundation)
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Style2 = require(parent.Style)
local DesignTokenProvider = Style2.DesignTokenProvider
local GraphQLServer = require(parent.GraphQLServer)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local v = { language = "en-us" }

local v2 = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v3 = { Console = Device.Console, Desktop = Device.Desktop }

local function fn(state)
	return Rodux.Store.new(function()
		return Cryo.Dictionary.join(state, {
			ScreenSize = Vector2.new(600, 600),
			TopBar = { topBarHeight = 0 },
			GlobalGuiInset = { left = 0, top = 0, right = 0, bottom = 0 }
		})
	end, {}, { Rodux.thunkMiddleware })
end

local Storybook = {}
Storybook.name = "EditProfile"
Storybook.storyRoot = EditProfile
Storybook.roact = React
Storybook.reactRoblox = ReactRoblox
Storybook.roactRodux = RoactRodux

function Storybook.mapDefinition(p)
	local joined = Cryo.Dictionary.join(v, p.controls or {})
	return Cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(props)
		local colorMode = v2[props.theme]
		local state = props.definition.state or {}
		return React.createElement(StyleProviderWithDefaultTheme, {
			withDarkTheme = true,
			withUiModeSupport = false
		}, {
			storeProvider = React.createElement(RoactRodux.StoreProvider, { store = fn(state) }, {
				policyProvider = React.createElement(UniversalAppPolicy.RoactAppPolicy.Provider, {
					policy = { UniversalAppPolicy.AppFeaturePolicies }
				}, {
					apolloClient = React.createElement(ApolloClient.ApolloProvider, {
						client = mockApolloClient({})
					}, {
						foundationProvider = React.createElement(
							FoundationProvider,
							{
								colorMode = colorMode,
								device = v3[props.platform],
								preferences = props.settings
							},
							{
								designTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Child = mockLocale(p, props)
								})
							}
						)
					})
				})
			})
		})
	end
end

return Storybook
