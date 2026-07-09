local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local ReactRoblox = require(AvatarExperienceSearchParent.ReactRoblox)
local UIBlox = require(AvatarExperienceSearchParent.UIBlox)
local DesignTokenProvider = require(AvatarExperienceSearchParent.Style).DesignTokenProvider
local LocalizationProvider = require(AvatarExperienceSearchParent.Localization).LocalizationProvider
local Localization = require(AvatarExperienceSearchParent.AppLocales).Localization
local RoactRodux = require(AvatarExperienceSearchParent.RoactRodux)
local Rodux = require(AvatarExperienceSearchParent.Rodux)
local Foundation = require(AvatarExperienceSearchParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device

UIBlox.init(require(AvatarExperienceSearchParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 22
	-- upvalues: Rodux (copy)
	local v20 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v20, nil, { Rodux.makeThunkMiddleware({}) })
end

local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t2 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}
local t3 = {
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
	name = "AvatarExperienceSearch",
	storyRoot = AvatarExperienceSearch,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 59
		-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy)
		return function(p2) -- line: 60
			-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy), p1 (copy)
			local v23 = t1[p2.theme]

			return React.createElement(LocalizationProvider, {
				localization = Localization.new("en-us")
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = p2 and t3[p2.theme] or t3.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							FoundationProvider = React.createElement(FoundationProvider, {
								theme = v23,
								device = t2[p2.platform],
								preferences = p2.settings
							}, {
								Child = React.createElement(p1, p2)
							})
						})
					})
				})
			})
		end
	end
}
