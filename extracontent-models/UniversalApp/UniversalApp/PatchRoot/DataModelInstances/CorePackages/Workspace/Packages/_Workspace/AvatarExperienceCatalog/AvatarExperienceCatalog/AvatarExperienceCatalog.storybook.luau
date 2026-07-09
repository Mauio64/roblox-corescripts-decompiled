local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local Rodux = require(Parent.Rodux)
local RoactRodux = require(Parent.RoactRodux)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local AppStyleProvider = require(Parent.UIBlox).App.Style.AppStyleProvider
local DesignTokenProvider = require(Parent.Dev.Style).DesignTokenProvider
local ReactRoblox = require(Parent.Dev.ReactRoblox)
local Localization = require(Parent.Dev.AppLocales).Localization
local AppStyleProvider2 = require(Parent.Dev.Style).AppStyleProvider

local function createStore() -- line: 19
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(Rodux.createReducer({}, {}))
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
	name = "AvatarExperienceCatalog",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 48
		-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), AppStyleProvider2 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy)
		return function(p2) -- line: 49
			-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), AppStyleProvider2 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy), p1 (copy)
			local v21 = t1[p2.theme]

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				}),
				LocalizationProvider = React.createElement(LocalizationProvider, {
					localization = Localization.new("en-us")
				}, {
					AppStyleProvider = React.createElement(AppStyleProvider, {
						style = p2 and t3[p2.theme] or t3.Default
					}, {
						StyleProvider = React.createElement(AppStyleProvider2, {
							style = p2 and t3[p2.theme] or t3.Default
						}, {
							StoreProvider = React.createElement(RoactRodux.StoreProvider, {
								store = createStore()
							}, {
								DesignTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									FoundationProvider = React.createElement(FoundationProvider, {
										theme = v21,
										device = t2[p2.platform],
										preferences = p2.settings
									}, {
										Child = React.createElement(p1, p2)
									})
								})
							})
						})
					})
				})
			})
		end
	end
}
