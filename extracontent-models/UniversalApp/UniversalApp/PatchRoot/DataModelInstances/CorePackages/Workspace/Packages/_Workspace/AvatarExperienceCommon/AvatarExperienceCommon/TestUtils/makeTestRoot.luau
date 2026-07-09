local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Constants = require(script.Parent.Constants)
local createStyleProvider = require(Parent.Dev.UnitTestHelpers).createStyleProvider

local function createLocalization() -- line: 13
	-- upvalues: Constants (copy)
	return {
		Format = function(_, s1: string) -- line: 15
			-- upvalues: Constants (copy)
			return s1 .. Constants.TRANSLATION_TOKEN
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
	local v13 = t1.store or createStore()
	local v14 = t1.localization or createLocalization()

	return function(t2: {[any]: any}) -- line: 41
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
