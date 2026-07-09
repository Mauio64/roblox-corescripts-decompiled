local Parent = script:FindFirstAncestor("InAppIntervention").Parent
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local LayerCollectorProvider = require(Parent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local RoactRodux = require(Parent.RoactRodux)

local function staticReducer(p1) -- line: 26
	return p1
end
local function MockProviders(t1: {[any]: any}) -- line: 30
	-- upvalues: RoactRodux (copy), Rodux (copy), staticReducer (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), LayerCollectorProvider (copy), FoundationProvider (copy), React (copy), ProviderContainer (copy)
	local t2 = {}

	table.insert(t2, {
		class = RoactRodux.StoreProvider,
		props = {
			store = Rodux.Store.new(staticReducer, {
				ScreenSize = Vector2.new(2400, 1800)
			}, { Rodux.thunkMiddleware })
		}
	})
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
				Format = function(_, s1: string) -- line: 51
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
		class = FoundationProvider,
		props = {
			theme = "Dark"
		}
	})

	return React.createElement(ProviderContainer, {
		providers = t2
	}, t1.children)
end

return MockProviders
