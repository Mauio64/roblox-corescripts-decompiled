local Parent = script:FindFirstAncestor("InlineRichText").Parent
local React = require(Parent.React)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local Style = require(Parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local Cryo = require(Parent.Cryo)
local Rodux = require(Parent.Rodux)
local RoactRodux = require(Parent.RoactRodux)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local NavigationRodux = require(Parent.NavigationRodux)
local t1 = {
	withUiModeSupport = false
}

local function MockProviders(t2: {[any]: any}) -- line: 31
	-- upvalues: Cryo (copy), t1 (copy), FoundationProvider (copy), RoactRodux (copy), Rodux (copy), NavigationRodux (copy), StyleProviderWithDefaultTheme (copy), Style (copy), LocalizationProvider (copy), React (copy), ProviderContainer (copy)
	local v15 = Cryo.Dictionary.union(t1, t2)
	local t3 = {}

	table.insert(t3, {
		class = FoundationProvider,
		props = {
			device = "Desktop",
			theme = v15.themeName
		}
	})
	table.insert(t3, {
		class = RoactRodux.StoreProvider,
		props = {
			store = Rodux.Store.new(function(p1, _) -- line: 47
				return p1
			end, {
				Navigation = {
					lockNavigationActions = false
				}
			}, {
				Rodux.thunkMiddleware,
				NavigationRodux.Thunks.RNAdapterThunk.middleware(function(p3) -- line: 55
					print(`[Mock Providers Debug] Navigating to { p3.routeName } with detail { p3.params.detail }`)
				end)
			})
		}
	})
	table.insert(t3, {
		class = StyleProviderWithDefaultTheme,
		props = {
			withDarkTheme = v15.themeName ~= "Light",
			withUiModeSupport = v15.withUiModeSupport
		}
	})
	table.insert(t3, {
		class = Style.DesignTokenProvider,
		props = {
			tokenMappers = {}
		}
	})
	table.insert(t3, {
		class = LocalizationProvider,
		props = {
			localization = {
				Format = function(_, s1: string) -- line: 81
					return s1
				end
			}
		}
	})

	return React.createElement(ProviderContainer, {
		providers = t3
	}, v15.children)
end

return MockProviders
