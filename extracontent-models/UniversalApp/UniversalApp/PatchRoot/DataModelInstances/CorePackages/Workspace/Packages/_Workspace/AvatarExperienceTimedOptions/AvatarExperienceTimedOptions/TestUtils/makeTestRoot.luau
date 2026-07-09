local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local createStyleProvider = require(Parent.Dev.UnitTestHelpers).createStyleProvider
local Constants = require(script.Parent.Constants)

local function createLocalization() -- line: 14
	-- upvalues: Constants (copy)
	return {
		Format = function(_, s1: string) -- line: 16
			-- upvalues: Constants (copy)
			return s1 .. Constants.TRANSLATION_TOKEN
		end,
		GetLocale = function() -- line: 19
			return "locale"
		end
	}
end
local function createStore() -- line: 25
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(Rodux.createReducer({}, {}))
end
local function makeTestRoot(t1: {[any]: any}) -- line: 38
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), createStyleProvider (copy), RoactRodux (copy), DesignTokenProvider (copy)
	local v13 = t1.store or createStore()
	local v14 = t1.localization or createLocalization()

	return function(t2: {[any]: any}) -- line: 42
		-- upvalues: React (copy), LocalizationProvider (copy), v14 (copy), createStyleProvider (copy), RoactRodux (copy), v13 (copy), DesignTokenProvider (copy)
		return React.createElement(LocalizationProvider, {
			localization = v14
		}, {
			StyleProvider = createStyleProvider({
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v13
				}, {
					DesignTokenProvider = React.createElement(DesignTokenProvider, {
						tokenMappers = {}
					}, {
						TestSubject = t2.children
					})
				})
			})
		})
	end
end

return makeTestRoot
