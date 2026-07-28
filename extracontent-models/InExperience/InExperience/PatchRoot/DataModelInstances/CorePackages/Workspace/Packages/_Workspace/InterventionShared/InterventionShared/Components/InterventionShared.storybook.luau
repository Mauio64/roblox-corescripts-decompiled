local Parent = script:FindFirstAncestor("InterventionShared").Parent
local UIBlox = require(Parent.UIBlox)
local RobloxAppUIBloxConfig = require(Parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local React = require(Parent.React)
local Roact = require(Parent.Roact)
local Cryo = require(Parent.Cryo)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local LayerCollectorProvider = UIBlox.Core.Layout.LayerCollector.LayerCollectorProvider
local Signal = require(Parent.AppCommonLib).Signal

local function MockProviders(p1) -- line: 28
	-- upvalues: FoundationProvider (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Signal (copy), LayerCollectorProvider (copy), React (copy), ProviderContainer (copy)
	local t1 = {}

	table.insert(t1, {
		class = FoundationProvider,
		props = {}
	})
	table.insert(t1, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = true,
			withUiModeSupport = false
		}
	})
	table.insert(t1, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 48
					return s1
				end,
				changed = Signal.new()
			}
		}
	})
	table.insert(t1, {
		class = LayerCollectorProvider,
		props = {}
	})

	return React.createElement(ProviderContainer, {
		providers = t1
	}, p1.children)
end

return {
	roact = Roact,
	mapStory = function(p3) -- line: 68
		-- upvalues: Roact (copy), MockProviders (copy), Cryo (copy)
		return function(p4) -- line: 69
			-- upvalues: Roact (copy), MockProviders (copy), p3 (copy), Cryo (copy)
			local v20 = p4 and (not not p4.definition and p4.definition.props) or {}

			return Roact.createElement(MockProviders, {}, {
				story = Roact.createElement(p3, Cryo.Dictionary.union(v20, p4))
			})
		end
	end
}
