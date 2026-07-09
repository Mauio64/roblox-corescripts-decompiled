local Parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent
local React = require(Parent.React)
local ReactRoblox = require(Parent.ReactRoblox)
local UIBlox = require(Parent.UIBlox)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Localization = require(Parent.AppLocales).Localization
local RoactRodux = require(Parent.RoactRodux)
local Rodux = require(Parent.Rodux)

pcall(function() -- line: 13
	-- upvalues: UIBlox (copy), Parent (copy)
	UIBlox.init(require(Parent.Dev.RobloxAppUIBloxConfig))
end)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 18
	-- upvalues: Rodux (copy)
	local v13 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v13, nil, { Rodux.makeThunkMiddleware({}) })
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
	name = "RobloxSubscriptionPurchaseApp",
	storyRoot = script.Parent.Parent,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 45
		-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy)
		return function(p2) -- line: 46
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
