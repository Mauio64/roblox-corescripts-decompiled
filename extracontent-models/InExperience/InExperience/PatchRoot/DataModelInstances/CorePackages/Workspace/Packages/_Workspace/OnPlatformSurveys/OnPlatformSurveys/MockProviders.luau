local parent = script:FindFirstAncestor("OnPlatformSurveys").Parent

local Localization = require(parent.Localization)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local RoactUtils = require(parent.RoactUtils)
local Rodux = require(parent.Rodux)
local Style = require(parent.Style)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationProvider = Localization.LocalizationProvider
local ProviderContainer = RoactUtils.Components.ProviderContainer
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local function reducer(options)
	return options or {}
end

local function MockProviders(p)
	local providers = {}

	local store = Rodux.Store.new(reducer, {}, { Rodux.thunkMiddleware })

	table.insert(providers, {
		class = StyleProviderWithDefaultTheme,
		props = { withDarkTheme = true }
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

	table.insert(providers, { class = LayerCollectorProvider, props = {} })

	table.insert(providers, {
		class = RoactRodux.StoreProvider,
		props = { store = store }
	})

	table.insert(providers, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})

	return React.createElement(ProviderContainer, { providers = providers }, p.children)
end

return MockProviders
