local Parent = script:FindFirstAncestor("AvatarExperienceHeadRefinement").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
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
local function makeTestRoot(t1: {[any]: any}) -- line: 37
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), createStyleProvider (copy), RoactRodux (copy), DesignTokenProvider (copy)
	local v12 = t1.store or createStore()
	local v13 = t1.localization or createLocalization()

	return function(t2: {[any]: any}) -- line: 41
		-- upvalues: React (copy), LocalizationProvider (copy), v13 (copy), createStyleProvider (copy), RoactRodux (copy), v12 (copy), DesignTokenProvider (copy)
		return React.createElement(LocalizationProvider, {
			localization = v13
		}, {
			StyleProvider = createStyleProvider({
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v12
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
