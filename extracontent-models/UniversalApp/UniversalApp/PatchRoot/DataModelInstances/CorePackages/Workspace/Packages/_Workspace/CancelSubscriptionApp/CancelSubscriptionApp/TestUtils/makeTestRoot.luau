local Parent = script:FindFirstAncestor("CancelSubscriptionApp").Parent
local RoactRodux = require(Parent.RoactRodux)
local React = require(Parent.React)
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local NetworkContext = require(Parent.EconomyCommonCoreScriptHooks).NetworkContext
local ScreenSizeContext = require(Parent.EconomyCommonCoreScriptHooks).ScreenSizeContext
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
local function makeTestRoot(t1: {[any]: any}) -- line: 40
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), createStyleProvider (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), ScreenSizeContext (copy)
	local v14 = t1.store or createStore()
	local v15 = t1.network or {}
	local v16 = t1.localization or createLocalization()
	local v17 = t1.screenSize or Vector2.new(1000, 1000)

	return function(t2: {[any]: any}) -- line: 46
		-- upvalues: React (copy), LocalizationProvider (copy), v16 (copy), createStyleProvider (copy), NetworkContext (copy), v15 (copy), RoactRodux (copy), v14 (copy), DesignTokenProvider (copy), ScreenSizeContext (copy), v17 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v16
		}, {
			StyleProvider = createStyleProvider({
				NetworkProvider = React.createElement(NetworkContext.Provider, {
					value = v15
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = v14
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, React.createElement(ScreenSizeContext.Provider, {
							value = v17
						}, {
							TestSubject = t2.children
						}))
					})
				})
			})
		})
	end
end

return makeTestRoot
