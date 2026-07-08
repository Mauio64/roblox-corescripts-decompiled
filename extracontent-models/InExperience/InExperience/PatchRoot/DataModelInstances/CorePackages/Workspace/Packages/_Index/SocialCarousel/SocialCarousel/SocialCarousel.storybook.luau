local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local Roact = require(SocialCarouselParent.Dev.Roact)
local RoactRodux = require(SocialCarouselParent.RoactRodux)
local Rodux = require(SocialCarouselParent.Rodux)
local UIBlox = require(SocialCarouselParent.UIBlox)
local Cryo = require(SocialCarouselParent.Cryo)
local Style = require(SocialCarouselParent.Style)
local ApolloClient = require(SocialCarouselParent.ApolloClient)
local Foundation = require(SocialCarouselParent.Foundation)
local RoactNavigation = require(SocialCarouselParent.RoactNavigation)
local mockLocale = require(SocialCarouselParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(SocialCarouselParent.Dev.RobloxAppUIBloxConfig)
local UniversalAppPolicy = require(SocialCarouselParent.UniversalAppPolicy).UniversalAppPolicy

UIBlox.init(RobloxAppUIBloxConfig)

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = require(SocialCarouselParent.Style).DesignTokenProvider
local mockApolloClient = require(SocialCarouselParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device

Roact.setGlobalConfig({
	elementTracing = true
})

local t1 = {
	language = "en-us"
}
local t2 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t3 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}

local function v24(p1) -- line: 44
	-- upvalues: Rodux (copy), Cryo (copy)
	return Rodux.Store.new(function() -- line: 45
		-- upvalues: Cryo (copy), p1 (copy)
		return Cryo.Dictionary.join(p1, {
			ScreenSize = Vector2.new(600, 600),
			TopBar = {
				topBarHeight = 0
			},
			GlobalGuiInset = {
				left = 0,
				top = 0,
				right = 0,
				bottom = 0
			}
		})
	end, {}, { Rodux.thunkMiddleware })
end

return {
	name = "SocialCarousel",
	storyRoot = SocialCarousel,
	roact = Roact,
	roactRodux = RoactRodux,
	mapDefinition = function(p2) -- line: 66
		-- upvalues: Cryo (copy), t1 (copy)
		local v27 = Cryo.Dictionary.join(t1, p2.controls or {})

		return Cryo.Dictionary.join(p2, {
			controls = v27
		})
	end,
	mapStory = function(p3) -- line: 70
		-- upvalues: t2 (copy), Roact (copy), StyleProviderWithDefaultTheme (copy), UniversalAppPolicy (copy), RoactNavigation (copy), RoactRodux (copy), v24 (copy), ApolloClient (copy), mockApolloClient (copy), FoundationProvider (copy), t3 (copy), DesignTokenProvider (copy), mockLocale (copy)
		return function(p4) -- line: 71
			-- upvalues: t2 (copy), Roact (copy), StyleProviderWithDefaultTheme (copy), UniversalAppPolicy (copy), RoactNavigation (copy), RoactRodux (copy), v24 (copy), ApolloClient (copy), mockApolloClient (copy), FoundationProvider (copy), t3 (copy), DesignTokenProvider (copy), mockLocale (copy), p3 (copy)
			local v30 = t2[p4.theme]
			local v31 = p4.definition.state or {}

			return Roact.createElement(StyleProviderWithDefaultTheme, {
				withDarkTheme = true,
				withUiModeSupport = false
			}, { Roact.createElement(UniversalAppPolicy.Provider, {
				policy = { function() -- line: 80
					return {
						useGridPageLayout = function() -- line: 82
							return true
						end
					}
				end }
			}, {
				navigationProvider = Roact.createElement(RoactNavigation.Provider, {
					value = {
						state = {
							routeName = "appPage"
						},
						isFocused = function() -- line: 94
							return false
						end,
						addListener = function() -- line: 97
							return {
								remove = function() -- line: 99
								end
							}
						end,
						getParam = function(_, p6) -- line: 102
							return p6
						end,
						navigate = function() -- line: 105
						end
					}
				}, {
					storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
						store = v24(v31)
					}, {
						apolloClient = Roact.createElement(ApolloClient.ApolloProvider, {
							client = mockApolloClient({})
						}, {
							foundationProvider = Roact.createElement(FoundationProvider, {
								theme = v30,
								device = t3[p4.platform],
								preferences = p4.settings
							}, {
								designTokenProvider = Roact.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Child = mockLocale(p3, p4)
								})
							})
						})
					})
				})
			}) })
		end
	end
}
