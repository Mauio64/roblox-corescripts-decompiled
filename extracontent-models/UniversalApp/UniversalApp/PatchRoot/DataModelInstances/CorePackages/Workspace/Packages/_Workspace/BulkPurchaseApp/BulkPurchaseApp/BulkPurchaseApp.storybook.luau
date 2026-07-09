local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local ReactRoblox = require(BulkPurchaseAppParent.ReactRoblox)
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local DesignTokenProvider = require(BulkPurchaseAppParent.Style).DesignTokenProvider
local LocalizationProvider = require(BulkPurchaseAppParent.Localization).LocalizationProvider
local Localization = require(BulkPurchaseAppParent.InExperienceLocales).Localization
local RoactRodux = require(BulkPurchaseAppParent.RoactRodux)
local Rodux = require(BulkPurchaseAppParent.Rodux)

UIBlox.init(require(BulkPurchaseAppParent.Dev.RobloxAppUIBloxConfig))

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
	name = "BulkPurchaseApp",
	storyRoot = BulkPurchaseApp,
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
