local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local Cryo = require(NotApprovedPageParent.Cryo)
local React = require(NotApprovedPageParent.React)
local ReactRoblox = require(NotApprovedPageParent.Dev.ReactRoblox)
local ProviderContainer = require(NotApprovedPageParent.RoactUtils).Components.ProviderContainer
local FoundationProvider = require(NotApprovedPageParent.Foundation).FoundationProvider
local LocalizationProvider = require(NotApprovedPageParent.Localization).LocalizationProvider
local Signal = require(NotApprovedPageParent.AppCommonLib).Signal
local RoactRodux = require(NotApprovedPageParent.Dev.RoactRodux)
local Rodux = require(NotApprovedPageParent.Rodux)
local StyleProviderWithDefaultTheme = require(NotApprovedPageParent.Dev.Style).StyleProviderWithDefaultTheme
local LayerCollectorProvider = require(NotApprovedPageParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local UniversalAppPolicy = require(NotApprovedPageParent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local ResponsiveProvider = require(NotApprovedPageParent.Responsive).ResponsiveProvider
local Dictionary = Cryo.Dictionary

local function reducer(p1) -- line: 43
	return p1 or {}
end
local function MockProviders(p2) -- line: 47
	-- upvalues: Rodux (copy), reducer (copy), StyleProviderWithDefaultTheme (copy), LocalizationProvider (copy), Signal (copy), LayerCollectorProvider (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), ResponsiveProvider (copy), React (copy), ProviderContainer (copy)
	local t1 = {}
	local v24 = Rodux.Store.new(reducer, {}, { Rodux.thunkMiddleware })

	table.insert(t1, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = true
		}
	})
	table.insert(t1, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 68
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
	table.insert(t1, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v24
		}
	})
	table.insert(t1, {
		class = RoactAppPolicy.Provider,
		props = {
			policy = { AppFeaturePolicies }
		}
	})
	table.insert(t1, {
		class = ResponsiveProvider,
		props = {}
	})

	return React.createElement(ProviderContainer, {
		providers = t1
	}, p2.children)
end

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p4) -- line: 112
		-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), FoundationProvider (copy)
		return function(p5) -- line: 113
			-- upvalues: Dictionary (copy), React (copy), MockProviders (copy), FoundationProvider (copy), p4 (copy)
			local v29 = Dictionary.union(p5, p5.definition and p5.definition.props or {})

			return React.createElement(MockProviders, {}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = "Dark",
					preferences = p5.settings,
					overlayGui = p5.focus
				}, {
					story = React.createElement(p4, v29)
				})
			})
		end
	end,
	storyRoots = { NotApprovedPage }
}
