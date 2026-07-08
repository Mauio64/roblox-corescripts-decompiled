local Parent = script:FindFirstAncestor("ChatLineReporting").Parent
local React = require(Parent.React)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local LayerCollectorProvider = require(Parent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider

local function MockProviders(t1: {[any]: any}) -- line: 22
	-- upvalues: StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), LayerCollectorProvider (copy), React (copy), ProviderContainer (copy)
	local t2 = {}

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
				Format = function(_, s1: string) -- line: 36
					return s1
				end
			}
		}
	})
	table.insert(t2, {
		class = LayerCollectorProvider,
		props = {}
	})

	return React.createElement(ProviderContainer, {
		providers = t2
	}, t1.children)
end

return MockProviders
