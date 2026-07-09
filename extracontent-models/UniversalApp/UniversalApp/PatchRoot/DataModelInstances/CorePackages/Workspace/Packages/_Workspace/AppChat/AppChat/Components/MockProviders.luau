local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local ProviderContainer = require(AppChatParent.RoactUtils).Components.ProviderContainer
local Style = require(AppChatParent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local LocalizationProvider = require(AppChatParent.Localization).LocalizationProvider
local UIBlox = require(AppChatParent.UIBlox)
local FoundationProvider = require(AppChatParent.Foundation).FoundationProvider
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local Signal = require(AppChatParent.AppCommonLib).Signal
local Cryo = require(AppChatParent.Cryo)
local UniversalAppPolicy = require(AppChatParent.UniversalAppPolicy)
local SocialPolicies = require(AppChatParent.SocialPolicies)
local UserProfiles = require(AppChatParent.UserProfiles)
local ApolloClient = require(AppChatParent.ApolloClient)
local mockApolloClient = require(AppChatParent.GraphQLServer).ApolloClientTestUtils.mockApolloClient
local MockUserData = require(AppChat.Users.MockUserData)
local RealtimeProvider = require(AppChatParent.RealtimeDelivery).RealtimeProvider
local InteractionFeedback = require(AppChatParent.InteractionFeedback)
local HapticFeedbackConfig = require(AppChat.Utils.HapticFeedback).HapticFeedbackConfig
local Rodux = require(AppChatParent.Rodux)
local RoactRodux = require(AppChatParent.RoactRodux)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local t1 = {
	withUiModeSupport = false,
	withLayerCollector = true,
	withApolloProvider = true
}

local function MockProviders(t2: {[any]: any}) -- line: 57
	-- upvalues: Cryo (copy), t1 (copy), RealtimeProvider (copy), FoundationProvider (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Signal (copy), LayerCollectorProvider (copy), RoactRodux (copy), Rodux (copy), UniversalAppPolicy (copy), SocialPolicies (copy), Style (copy), mockApolloClient (copy), MockUserData (copy), UserProfiles (copy), ApolloClient (copy), InteractionFeedback (copy), HapticFeedbackConfig (copy), RoactNavigation (copy), React (copy), ProviderContainer (copy)
	local v28 = Cryo.Dictionary.union(t1, t2)
	local t3 = {}

	if v28.realtime then
		table.insert(t3, {
			class = RealtimeProvider,
			props = {
				realtime = v28.realtime
			}
		})
	end

	table.insert(t3, {
		class = FoundationProvider,
		props = {
			device = "Desktop",
			theme = v28.themeName
		}
	})
	table.insert(t3, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = v28.themeName ~= "Light",
			withUiModeSupport = v28.withUiModeSupport
		}
	})
	table.insert(t3, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 90
					return s1
				end,
				changed = Signal.new()
			}
		}
	})

	if v28.withLayerCollector then
		table.insert(t3, {
			class = LayerCollectorProvider,
			props = {}
		})
	end

	table.insert(t3, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v28.rodux and v28.rodux.store or Rodux.Store.new(function() -- line: 108
				-- upvalues: v28 (copy)
				return v28.rodux and v28.rodux.state or {}
			end, v28.rodux and v28.rodux.state, { Rodux.thunkMiddleware })
		}
	})
	table.insert(t3, {
		class = UniversalAppPolicy.RoactAppPolicy.Provider,
		props = {
			policy = {
				UniversalAppPolicy.AppFeaturePolicies,
				SocialPolicies.ChatPolicies
			}
		}
	})
	table.insert(t3, {
		class = Style.DesignTokenProvider,
		props = {
			tokenMappers = {}
		}
	})

	if v28.withApolloProvider then
		local v30 = mockApolloClient({})
		local v31 = MockUserData.createMockApolloProfiles()

		UserProfiles.TestUtils.writeProfileDataToCache(v30, v31)
		table.insert(t3, {
			class = ApolloClient.ApolloProvider,
			props = {
				client = v30
			}
		})
	end

	table.insert(t3, {
		class = InteractionFeedback.InteractionFeedbackContext.Provider,
		props = {
			value = HapticFeedbackConfig
		}
	})
	table.insert(t3, {
		class = RoactNavigation.Provider,
		props = {
			value = {
				state = {
					routeName = "",
					key = "",
					params = {}
				},
				dispatch = function() -- line: 157
				end,
				goBack = function() -- line: 158
				end,
				addListener = function() -- line: 159
					return {
						remove = function() -- line: 160
						end
					}
				end,
				isFocused = function() -- line: 162
				end,
				setParams = function() -- line: 163
				end,
				getParam = function() -- line: 164
				end,
				replace = function() -- line: 165
				end,
				push = function() -- line: 166
				end,
				getScreenProps = function() -- line: 167
				end
			}
		}
	})

	return React.createElement(ProviderContainer, {
		providers = t3
	}, v28.children)
end

return MockProviders
