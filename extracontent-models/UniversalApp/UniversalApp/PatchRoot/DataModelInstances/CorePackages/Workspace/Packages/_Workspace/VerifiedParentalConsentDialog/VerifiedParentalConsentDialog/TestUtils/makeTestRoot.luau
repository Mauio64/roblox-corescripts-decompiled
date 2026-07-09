local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local VerifiedParentalConsentDialogParent = VerifiedParentalConsentDialog.Parent
local RoactRodux = require(VerifiedParentalConsentDialogParent.RoactRodux)
local React = require(VerifiedParentalConsentDialogParent.React)
local Rodux = require(VerifiedParentalConsentDialogParent.Rodux)
local DesignTokenProvider = require(VerifiedParentalConsentDialogParent.Style).DesignTokenProvider
local LocalizationProvider = require(VerifiedParentalConsentDialogParent.Localization).LocalizationProvider
local createStyleProvider = require(VerifiedParentalConsentDialogParent.Dev.UnitTestHelpers).createStyleProvider
local NetworkContext = require(VerifiedParentalConsentDialog.Hooks.NetworkContext)
local ScreenSizeContext = require(VerifiedParentalConsentDialog.Hooks.ScreenSizeContext)

local function createLocalization() -- line: 15
	return {
		Format = function(_, s1: string) -- line: 17
			return s1 .. "-translated"
		end,
		GetLocale = function() -- line: 20
			return "locale"
		end
	}
end
local function createStore() -- line: 26
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(Rodux.createReducer({}, {}))
end
local function makeTestRoot(t1: {[any]: any}) -- line: 41
	-- upvalues: createStore (copy), createLocalization (copy), React (copy), LocalizationProvider (copy), createStyleProvider (copy), NetworkContext (copy), RoactRodux (copy), DesignTokenProvider (copy), ScreenSizeContext (copy)
	local v15 = t1.store or createStore()
	local v16 = t1.network or {}
	local v17 = t1.localization or createLocalization()
	local v18 = t1.screenSize or Vector2.new(1000, 1000)

	return function(t2: {[any]: any}) -- line: 47
		-- upvalues: React (copy), LocalizationProvider (copy), v17 (copy), createStyleProvider (copy), NetworkContext (copy), v16 (copy), RoactRodux (copy), v15 (copy), DesignTokenProvider (copy), ScreenSizeContext (copy), v18 (copy)
		return React.createElement(LocalizationProvider, {
			localization = v17
		}, {
			StyleProvider = createStyleProvider({
				NetworkProvider = React.createElement(NetworkContext.Provider, {
					value = v16
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = v15
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, React.createElement(ScreenSizeContext.Provider, {
							value = v18
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
