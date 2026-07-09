local Parent = script:FindFirstAncestor("AvatarExperienceSearch").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local RoactNavigation = require(Parent.RoactNavigation)
local createStyleProvider = require(Parent.Dev.UnitTestHelpers).createStyleProvider

local function createLocalization() -- line: 13
	return {
		Format = function(_, s1: string) -- line: 15
			return s1 .. "-translated"
		end,
		GetLocale = function() -- line: 18
			return "locale"
		end
	}
end
local function createStore() -- line: 24
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(Rodux.createReducer({}, {}))
end
local function makeTestRoot(t1: {[any]: any}) -- line: 38
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), RoactNavigation (copy), createStyleProvider (copy), RoactRodux (copy), DesignTokenProvider (copy)
	local v13 = t1.store or createStore()
	local v14 = t1.localization or createLocalization()
	local v15 = t1.navigation or {
		getParam = function(p2) -- line: 43
			return p2
		end,
		getScreenProps = function(_) -- line: 46
			return 0
		end,
		navigate = function() -- line: 49
		end,
		pop = function() -- line: 50
		end,
		isFocused = function() -- line: 51
		end,
		addListener = function() -- line: 52
			return {
				remove = function() -- line: 54
				end
			}
		end
	}

	return function(t2: {[any]: any}) -- line: 59
		-- upvalues: React (copy), LocalizationProvider (copy), v14 (copy), RoactNavigation (copy), v15 (copy), createStyleProvider (copy), RoactRodux (copy), v13 (copy), DesignTokenProvider (copy)
		return React.createElement(LocalizationProvider, {
			localization = v14
		}, {
			NavigationProvider = React.createElement(RoactNavigation.Provider, {
				value = v15
			}, {
				StyleProvider = createStyleProvider({
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = v13
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, t2.children)
					})
				})
			})
		})
	end
end

return makeTestRoot
