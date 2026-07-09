local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("DiscoveryTestHelpers").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local Promise = require(Parent.Promise)
local Responsive = require(Parent.Responsive)
local RoactRodux = require(Parent.RoactRodux)
local Style = require(Parent.Style)
local AppStyleProvider = Style.AppStyleProvider
local DesignTokenProvider = Style.DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(Parent.RobloxAppLocales).Localization
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local RoactNavigation = require(Parent.RoactNavigation)
local RoactServices = require(Parent.RoactServices).RoactServices
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking
local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, 1000, 0, 1000)

local v23 = React.createRef()

v23.current = Frame

local function wrapWithAppProviders(p1, t1: {[any]: any}?) -- line: 43
	-- upvalues: Parent (copy), React (copy), Responsive (copy), v23 (copy), RoactRodux (copy), Rodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), FoundationProvider (copy), Foundation (copy), AppStyleProvider (copy), DesignTokenProvider (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RoactServices (copy), Cryo (copy), RoactNetworking (copy), Promise (copy), RoactNavigation (copy)
	local mockApolloClient = require(Parent.Dev.GraphQLServer).ApolloClientTestUtils.mockApolloClient
	local ApolloProvider = require(Parent.Dev.ApolloClient).ApolloProvider
	local AppInteractionFeedbackProvider = require(Parent.AppInteractionFeedbackConfig).AppInteractionFeedbackProvider
	local v30 = t1 or {}

	return (React.createElement(Responsive.ContainerRef.Provider, {
		value = v23
	}, {
		StoreProvider = React.createElement(RoactRodux.StoreProvider, {
			store = v30.store or Rodux.Store.new(function(p2) -- line: 55
				return p2
			end, {
				ScreenSize = Vector2.new(1920, 1080),
				TopBar = {
					topBarHeight = 10
				},
				GlobalGuiInset = {
					bottom = 0,
					left = 0,
					right = 0,
					top = 0
				},
				GamesProductInfoKey = {},
				PlayabilityStatus = {},
				FetchingStatus = {},
				GameDetails = {},
				Personalization = {
					GameInfosKey = {}
				},
				GameIconsKey = {},
				UserGameVotes = {},
				AgeRecommendations = {},
				ShowAgeVerificationOverlay = {}
			}, {})
		}, {
			ApolloProvider = React.createElement(ApolloProvider, {
				client = mockApolloClient({})
			}, {
				RoactAppPolicy = React.createElement(RoactAppPolicy.Provider, {
					policy = { AppFeaturePolicies },
					policyData = v30.policyData
				}, {
					FoundationProvider = React.createElement(FoundationProvider, {
						theme = Foundation.Enums.Theme.Dark,
						device = Foundation.Enums.Device.Desktop,
						overlayGui = v30.overlayGui,
						preferences = {
							reducedMotion = true
						}
					}, {
						AppStyleProvider = React.createElement(AppStyleProvider, {
							style = {
								themeName = "dark",
								fontName = "gotham",
								deviceType = "Desktop"
							}
						}, {
							DesignTokenProvider = React.createElement(DesignTokenProvider, {
								tokenMappers = v30.tokenMappers or {}
							}, {
								LocalizationProvider = React.createElement(LocalizationProvider, {
									localization = Localization.new(LocalizationService.RobloxLocaleId)
								}, {
									AppInteractionFeedbackProvider = React.createElement(AppInteractionFeedbackProvider, {}, {
										RoactServices = React.createElement(RoactServices.ServiceProvider, {
											services = Cryo.Dictionary.join({
												[RoactNetworking] = function(...) -- line: 116
													-- upvalues: Promise (copy), v30 (copy)
													return Promise.resolve(if not v30.mockNetworkResponse then {
														responseBody = ""
													} else v30.mockNetworkResponse(...))
												end
											}, v30.services or {})
										}, {
											NavigationProvider = React.createElement(RoactNavigation.Provider, {
												value = {
													isFocused = function() -- line: 127
														return true
													end,
													addListener = function() -- line: 130
														return {
															remove = function() -- line: 132
															end
														}
													end,
													getParam = function(_, p4) -- line: 135
														return p4
													end,
													navigate = function() -- line: 138
													end,
													goBack = function() -- line: 139
													end,
													state = {
														routeName = v30.defaultRouteName or "DummyRoute"
													}
												}
											}, p1)
										})
									})
								})
							})
						})
					})
				})
			})
		})
	}))
end

return wrapWithAppProviders
