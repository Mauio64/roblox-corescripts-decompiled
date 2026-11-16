local parent = script:FindFirstAncestor("InlineRichText").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local RoactRodux = require(parent.RoactRodux)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local NavigationRodux = require(parent.NavigationRodux)

local v = { withUiModeSupport = false }

local function MockProviders(p)
	local union = Cryo.Dictionary.union(v, p)
	local providers = {}

	table.insert(providers, {
		class = FoundationProvider,
		props = { device = "Desktop", theme = union.themeName }
	})

	table.insert(providers, {
		class = RoactRodux.StoreProvider,
		props = {
			store = Rodux.Store.new(function(p2, _)
				return p2
			end, {
				Navigation = { lockNavigationActions = false }
			}, {
				Rodux.thunkMiddleware,
				NavigationRodux.Thunks.RNAdapterThunk.middleware(function(p2)
					print(`[Mock Providers Debug] Navigating to {p2.routeName} with detail {p2.params.detail}`)
				end)
			})
		}
	})

	table.insert(providers, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = union.themeName ~= "Light",
			withUiModeSupport = union.withUiModeSupport
		}
	})

	table.insert(providers, {
		class = Style.DesignTokenProvider,
		props = { tokenMappers = {} }
	})

	table.insert(providers, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, p2: string)
					return p2
				end
			}
		}
	})

	return React.createElement(ProviderContainer, { providers = providers }, union.children)
end

return MockProviders
