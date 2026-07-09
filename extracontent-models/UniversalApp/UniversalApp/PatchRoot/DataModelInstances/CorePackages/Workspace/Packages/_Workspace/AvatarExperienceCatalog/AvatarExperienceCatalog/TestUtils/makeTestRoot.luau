local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(Parent.AvatarExperienceNavigation)
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local ProviderContainer = require(Parent.RoactUtils).Components.ProviderContainer
local Rodux = require(Parent.Rodux)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local DesignTokenProvider = require(Parent.Dev.Style).DesignTokenProvider
local AppStyleProvider = require(Parent.Dev.Style).AppStyleProvider
local Responsive = require(Parent.Responsive)
local AnimatedVisibilityProvider = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.AnimatedVisibilityProvider
local AvatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext

local function createLocalization() -- line: 22
	return {
		Format = function(_, s1: string) -- line: 24
			return s1 .. "-translated"
		end,
		GetLocale = function() -- line: 27
			return "locale"
		end
	}
end
local function createStore() -- line: 33
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(Rodux.createReducer({}, {}))
end
local function getProviders(t1: {[any]: any}, p2) -- line: 45
	-- upvalues: createStore (copy), createLocalization (copy), Responsive (copy), LocalizationProvider (copy), RoactRodux (copy), AppStyleProvider (copy), DesignTokenProvider (copy), AnimatedVisibilityProvider (copy), AvatarRouteContext (copy), FoundationProvider (copy)
	local v21 = t1.store or createStore()
	local v22 = t1.localization or createLocalization()
	local t2 = {}

	table.insert(t2, {
		class = Responsive.ContainerRef.Provider,
		props = {
			value = p2
		}
	})
	table.insert(t2, {
		class = LocalizationProvider,
		props = {
			localization = v22
		}
	})
	table.insert(t2, {
		class = RoactRodux.StoreProvider,
		props = {
			store = v21
		}
	})
	table.insert(t2, {
		class = AppStyleProvider,
		props = {
			style = {
				themeName = "Dark",
				fontName = "Gotham"
			}
		}
	})
	table.insert(t2, {
		class = DesignTokenProvider,
		props = {
			tokenMappers = {}
		}
	})
	table.insert(t2, {
		class = AnimatedVisibilityProvider,
		props = {
			initialRatio = 1
		}
	})
	table.insert(t2, {
		class = AvatarRouteContext.Provider,
		props = {
			value = {
				isVisible = true,
				isOverlayVisible = false,
				current = {
					name = "None",
					key = "None",
					params = {}
				},
				previousPages = {},
				opaque = {
					name = "None",
					key = "None",
					params = {}
				}
			}
		}
	})
	table.insert(t2, {
		class = FoundationProvider,
		props = {
			theme = t1.theme or "Dark"
		}
	})

	return t2
end
local function makeTestRoot(t3: {[any]: any}) -- line: 111
	-- upvalues: React (copy), getProviders (copy), ProviderContainer (copy)
	return function(t4: {[any]: any}) -- line: 112
		-- upvalues: React (copy), getProviders (copy), t3 (copy), ProviderContainer (copy)
		local v28 = React.useRef(nil)
		local v29 = getProviders(t3, v28)
		local t5 = {
			ScreenGui = React.createElement("ScreenGui", {}, {
				App = React.createElement("Frame", {
					ref = v28,
					Size = UDim2.fromOffset(t3.width or 1024, t3.height or 768)
				}, {
					TestSubject = t4.children
				})
			})
		}

		return React.createElement(ProviderContainer, {
			providers = v29
		}, t5)
	end
end

return makeTestRoot
