local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local AppFeaturePolicies = require(Parent.UniversalAppPolicy).AppFeaturePolicies
local React = require(Parent.React)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local RoactAppPolicy = require(Parent.UniversalAppPolicy).RoactAppPolicy
local RoactNavigation = require(Parent.RoactNavigation)
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)
local LayerCollectorProvider = require(Parent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local t1 = {
	state = {
		routeName = "",
		key = "",
		params = {}
	},
	dispatch = function() -- line: 34
	end,
	goBack = function() -- line: 35
	end,
	addListener = function() -- line: 36
		return {
			remove = function() -- line: 38
			end
		}
	end,
	isFocused = function() -- line: 41
	end,
	setParams = function() -- line: 42
	end,
	getParam = function() -- line: 43
	end,
	replace = function() -- line: 44
	end,
	push = function() -- line: 45
	end
}

local function reducer(p1) -- line: 48
	return p1
end
local function MockProviders(t2: {[any]: any}) -- line: 52
	-- upvalues: Rodux (copy), reducer (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), LayerCollectorProvider (copy), RoactNavigation (copy), t1 (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), React (copy), ProviderContainer (copy)
	local t3 = {}
	local v18 = Rodux.Store.new(reducer, {}, { Rodux.thunkMiddleware })

	table.insert(t3, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = true
		}
	})
	table.insert(t3, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 70
					return s1
				end
			}
		}
	})
	table.insert(t3, {
		class = LayerCollectorProvider,
		props = {}
	})
	table.insert(t3, {
		class = RoactNavigation.Provider,
		props = {
			value = t1
		}
	})
	table.insert(t3, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v18
		}
	})
	table.insert(t3, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})

	return React.createElement(ProviderContainer, {
		providers = t3
	}, t2.children)
end

return MockProviders
