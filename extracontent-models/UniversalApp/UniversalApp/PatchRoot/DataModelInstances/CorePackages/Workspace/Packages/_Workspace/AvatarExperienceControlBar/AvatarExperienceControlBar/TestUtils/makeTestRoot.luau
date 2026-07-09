local Parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local FoundationProvider = require(Parent.Foundation).FoundationProvider
local createStyleProvider = require(Parent.Dev.UnitTestHelpers).createStyleProvider

local function createLocalization() -- line: 14
	return {
		Format = function(_, s1: string) -- line: 16
			return s1 .. "-translated"
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
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), createStyleProvider (copy), RoactRodux (copy), DesignTokenProvider (copy), FoundationProvider (copy)
	local v13 = t1.store or createStore()
	local v14 = t1.localization or createLocalization()

	return function(t2: {[any]: any}) -- line: 42
		-- upvalues: React (copy), LocalizationProvider (copy), v14 (copy), createStyleProvider (copy), RoactRodux (copy), v13 (copy), DesignTokenProvider (copy), FoundationProvider (copy)
		return React.createElement(LocalizationProvider, {
			localization = v14
		}, {
			StyleProvider = createStyleProvider({
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v13
				}, {
					DesignTokenProvider = React.createElement(DesignTokenProvider, {
						tokenMappers = {}
					}, React.createElement(FoundationProvider, {
						theme = "Dark"
					}, {
						TestSubject = t2.children
					}))
				})
			})
		})
	end
end

return makeTestRoot
