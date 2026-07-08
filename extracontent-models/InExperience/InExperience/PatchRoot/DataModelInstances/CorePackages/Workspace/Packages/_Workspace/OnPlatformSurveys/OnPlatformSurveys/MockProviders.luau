local Parent = script:FindFirstAncestor("OnPlatformSurveys").Parent
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local RoactRodux = require(Parent.RoactRodux)
local RoactUtils = require(Parent.RoactUtils)
local Rodux = require(Parent.Rodux)
local Style = require(Parent.Style)
local UIBlox = require(Parent.UIBlox)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local LocalizationProvider = Localization.LocalizationProvider
local ProviderContainer = RoactUtils.Components.ProviderContainer
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

local function reducer(p1) -- line: 30
	return p1 or {}
end
local function MockProviders(t1: {[any]: any}) -- line: 34
	-- upvalues: Rodux (copy), reducer (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), LayerCollectorProvider (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), React (copy), ProviderContainer (copy)
	local t2 = {}
	local v21 = Rodux.Store.new(reducer, {}, { Rodux.thunkMiddleware })

	table.insert(t2, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = true
		}
	})
	table.insert(t2, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 52
					return s1
				end
			}
		}
	})
	table.insert(t2, {
		class = LayerCollectorProvider,
		props = {}
	})
	table.insert(t2, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v21
		}
	})
	table.insert(t2, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})

	return React.createElement(ProviderContainer, {
		providers = t2
	}, t1.children)
end

return MockProviders
