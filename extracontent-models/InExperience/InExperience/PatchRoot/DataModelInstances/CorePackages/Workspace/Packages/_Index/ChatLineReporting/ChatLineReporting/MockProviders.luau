local parent = script:FindFirstAncestor("ChatLineReporting").Parent
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local UIBlox = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider

local function MockProviders(p)
	local providers = {}

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

	return React.createElement(ProviderContainer, { providers = providers }, p.children)
end

return MockProviders
