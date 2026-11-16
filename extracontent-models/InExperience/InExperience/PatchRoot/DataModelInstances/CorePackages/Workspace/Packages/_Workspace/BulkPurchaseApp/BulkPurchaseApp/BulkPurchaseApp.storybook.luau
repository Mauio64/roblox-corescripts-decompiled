local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local InExperienceLocales = require(parent.InExperienceLocales)
local localization = InExperienceLocales.Localization
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore()
	local reducer = Rodux.createReducer({}, {})
	return Rodux.Store.new(reducer, nil, { Rodux.makeThunkMiddleware({}) })
end

local v = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	name = "BulkPurchaseApp",
	storyRoot = BulkPurchaseApp,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			return React.createElement(LocalizationProvider, {
				localization = localization.new("en-us")
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = p2 and v[p2.theme] or v.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							Child = React.createElement(p, p2)
						})
					})
				})
			})
		end
	end
}
