local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Roact = require(parent.Dev.Roact)

local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)
local Style = require(parent.Style)
local ApolloClient = require(parent.ApolloClient)
local Foundation = require(parent.Foundation)
local RoactNavigation = require(parent.RoactNavigation)
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local universalAppPolicy = UniversalAppPolicy.UniversalAppPolicy

UIBlox.init(RobloxAppUIBloxConfig)

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Style2 = require(parent.Style)
local DesignTokenProvider = Style2.DesignTokenProvider
local GraphQLServer = require(parent.GraphQLServer)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

Roact.setGlobalConfig({ elementTracing = true })

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
Storybook.name = "SocialCarousel"
Storybook.storyRoot = SocialCarousel
Storybook.roact = Roact
Storybook.roactRodux = RoactRodux

function Storybook.mapDefinition(p)
	local joined = Cryo.Dictionary.join(v, p.controls or {})
	return Cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(props)
		local colorMode = v2[props.theme]
		local state = props.definition.state or {}
		return Roact.createElement(StyleProviderWithDefaultTheme, {
			withDarkTheme = true,
			withUiModeSupport = false
		}, {
			Roact.createElement(universalAppPolicy.Provider, {
				policy = { function()
						return {
							useGridPageLayout = function(): boolean
								return true
							end
						}
					end }
			}, {
				navigationProvider = Roact.createElement(RoactNavigation.Provider, {
					value = {
						state = { routeName = "appPage" },
						isFocused = function(): boolean
							return false
						end,
						addListener = function()
							return {
								remove = function() end
							}
						end,
						getParam = function(_, p2)
							return p2
						end,
						navigate = function() end
					}
				}, {
					storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
						store = fn(state)
					}, {
						apolloClient = Roact.createElement(
							ApolloClient.ApolloProvider,
							{ client = mockApolloClient({}) },
							{
								foundationProvider = Roact.createElement(
									FoundationProvider,
									{
										colorMode = colorMode,
										device = v3[props.platform],
										preferences = props.settings
									},
									{
										designTokenProvider = Roact.createElement(
											DesignTokenProvider,
											{ tokenMappers = {} },
											{ Child = mockLocale(p, props) }
										)
									}
								)
							}
						)
					})
				})
			})
		})
	end
end

return Storybook
