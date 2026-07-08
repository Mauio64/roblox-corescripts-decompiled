local VerifiedParentalConsentDialog = script:FindFirstAncestor("VerifiedParentalConsentDialog")
local VerifiedParentalConsentDialogParent = VerifiedParentalConsentDialog.Parent
local React = require(VerifiedParentalConsentDialogParent.React)
local ReactRoblox = require(VerifiedParentalConsentDialogParent.ReactRoblox)
local UIBlox = require(VerifiedParentalConsentDialogParent.UIBlox)
local DesignTokenProvider = require(VerifiedParentalConsentDialogParent.Style).DesignTokenProvider
local LocalizationProvider = require(VerifiedParentalConsentDialogParent.Localization).LocalizationProvider
local Localization = require(VerifiedParentalConsentDialogParent.RobloxAppLocales).Localization
local RoactRodux = require(VerifiedParentalConsentDialogParent.RoactRodux)
local Rodux = require(VerifiedParentalConsentDialogParent.Rodux)

UIBlox.init(require(VerifiedParentalConsentDialogParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 16
	-- upvalues: Rodux (copy)
	local v14 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v14, nil, { Rodux.makeThunkMiddleware({}) })
end

local t1 = {
	Default = {
		themeName = "Dark",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}

return {
	name = "VerifiedParentalConsentDialog",
	storyRoot = VerifiedParentalConsentDialog,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 43
		-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy)
		return function(p2) -- line: 44
			-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), p1 (copy)
			return React.createElement(LocalizationProvider, {
				localization = Localization.new("en-us")
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = p2 and t1[p2.theme] or t1.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							Child = React.createElement(p1, p2)
						})
					})
				})
			})
		end
	end
}
