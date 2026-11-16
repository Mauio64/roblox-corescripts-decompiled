local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy2.RoactAppPolicy
local RoactNavigation = require(parent.RoactNavigation)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local v = {
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
	push = function() end
}

local function reducer(p)
	return p
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
		class = RoactNavigation.Provider,
		props = { value = v }
	})

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
