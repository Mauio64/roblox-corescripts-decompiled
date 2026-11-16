local parent = script:FindFirstAncestor("InterventionShared").Parent
local UIBlox = require(parent.UIBlox)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local React = require(parent.React)
local Roact = require(parent.Roact)
local Cryo = require(parent.Cryo)

local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local function MockProviders(p)
	local providers = {}

	table.insert(providers, { class = FoundationProvider, props = {} })

	table.insert(providers, {
		class = StyleProviderWithDefaultTheme,
		props = { withDarkTheme = true, withUiModeSupport = false }
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

	table.insert(providers, { class = LayerCollectorProvider, props = {} })

	return React.createElement(ProviderContainer, { providers = providers }, p.children)
end

return {
	roact = Roact,
	mapStory = function(p)
		return function(p2)
			local props = p2 and p2.definition and p2.definition.props or {}

			return Roact.createElement(MockProviders, {}, {
				story = Roact.createElement(p, Cryo.Dictionary.union(props, p2))
			})
		end
	end
}
