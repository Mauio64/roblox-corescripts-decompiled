local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local Cryo = require(parent.Cryo)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local SocialPolicies = require(parent.SocialPolicies)

local UserProfiles = require(parent.UserProfiles)
local ApolloClient = require(parent.ApolloClient)
local GraphQLServer = require(parent.GraphQLServer)
local mockApolloClient = GraphQLServer.ApolloClientTestUtils.mockApolloClient
local MockUserData = require(AppChat.Users.MockUserData)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RealtimeProvider = RealtimeDelivery.RealtimeProvider
local InteractionFeedback = require(parent.InteractionFeedback)
local HapticFeedback = require(AppChat.Utils.HapticFeedback)
local HapticFeedbackConfig = HapticFeedback.HapticFeedbackConfig

local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)

local RoactNavigation = require(parent.RoactNavigation)

local v = { withUiModeSupport = false, withLayerCollector = true, withApolloProvider = true }

local function MockProviders(p)
	local union = Cryo.Dictionary.union(v, p)
	local providers = {}

	if union.realtime then
		table.insert(providers, {
			class = RealtimeProvider,
			props = { realtime = union.realtime }
		})
	end

	table.insert(providers, {
		class = FoundationProvider,
		props = { device = "Desktop", theme = union.themeName }
	})

	table.insert(providers, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = union.themeName ~= "Light",
			withUiModeSupport = union.withUiModeSupport
		}
	})

	table.insert(providers, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, p2: string)
					return p2
				end,
				changed = Signal.new()
			}
		}
	})

	if union.withLayerCollector then
		table.insert(providers, { class = LayerCollectorProvider, props = {} })
	end

	table.insert(providers, {
		class = RoactRodux.StoreProvider,
		props = {
			store = union.rodux and union.rodux.store or Rodux.Store.new(function()
				return union.rodux and union.rodux.state or {}
			end, union.rodux and union.rodux.state, { Rodux.thunkMiddleware })
		}
	})

	table.insert(providers, {
		class = UniversalAppPolicy.RoactAppPolicy.Provider,
		props = {
			policy = { UniversalAppPolicy.AppFeaturePolicies, SocialPolicies.ChatPolicies }
		}
	})

	table.insert(providers, {
		class = Style.DesignTokenProvider,
		props = { tokenMappers = {} }
	})

	if union.withApolloProvider then
		local client = mockApolloClient({})

		local mockApolloProfiles = MockUserData.createMockApolloProfiles()
		UserProfiles.TestUtils.writeProfileDataToCache(client, mockApolloProfiles)

		table.insert(providers, {
			class = ApolloClient.ApolloProvider,
			props = { client = client }
		})
	end

	table.insert(providers, {
		class = InteractionFeedback.InteractionFeedbackContext.Provider,
		props = { value = HapticFeedbackConfig }
	})

	table.insert(providers, {
		class = RoactNavigation.Provider,
		props = {
			value = {
				state = { params = {}, routeName = "", key = "" },
				dispatch = function() end,
				goBack = function() end,
				addListener = function()
					return {
						remove = function() end
					}
				end,
				isFocused = function() end,
				setParams = function() end,
				getParam = function() end,
				replace = function() end,
				push = function() end,
				getScreenProps = function() end
			}
		}
	})

	return React.createElement(ProviderContainer, { providers = providers }, union.children)
end

return MockProviders
