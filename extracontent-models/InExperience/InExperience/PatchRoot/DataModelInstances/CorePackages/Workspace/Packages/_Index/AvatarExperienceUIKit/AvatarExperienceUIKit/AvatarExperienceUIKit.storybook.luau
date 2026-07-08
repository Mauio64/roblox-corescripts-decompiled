local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local UIBlox = require(Parent.UIBlox)

UIBlox.init(require(Parent.Dev.RobloxAppUIBloxConfig))

local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local Rodux = require(Parent.Dev.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local RoactRodux = require(Parent.Dev.RoactRodux)
local AppStyleProvider = require(Parent.Style).AppStyleProvider
local AppStyleProvider2 = UIBlox.App.Style.AppStyleProvider
local ReactRoblox = require(Parent.Dev.ReactRoblox)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider

local function createLocalization() -- line: 19
	return {
		Format = function(_, s1: string) -- line: 21
			return s1
		end,
		GetLocale = function() -- line: 24
			return "locale"
		end
	}
end
local function createStore() -- line: 30
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
	name = "UIKit",
	group = "AvatarExperience",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p2) -- line: 59
		-- upvalues: t1 (copy), React (copy), RoactRodux (copy), createStore (copy), FoundationProvider (copy), t2 (copy), AppStyleProvider2 (copy), t3 (copy), AppStyleProvider (copy), DesignTokenProvider (copy), LocalizationProvider (copy), createLocalization (copy)
		return function(p3) -- line: 60
			-- upvalues: t1 (copy), React (copy), RoactRodux (copy), createStore (copy), FoundationProvider (copy), t2 (copy), p2 (copy), AppStyleProvider2 (copy), t3 (copy), AppStyleProvider (copy), DesignTokenProvider (copy), LocalizationProvider (copy), createLocalization (copy)
			local v24 = t1[p3.theme]
			local v25 = if not p3.definition.foundationOnly then {
				AppStyleProvider = React.createElement(AppStyleProvider2, {
					style = p3 and t3[p3.theme] or t3.Default
				}, {
					StyleProvider = React.createElement(AppStyleProvider, {
						style = p3 and t3[p3.theme] or t3.Default
					}, {
						StoreProvider = React.createElement(RoactRodux.StoreProvider, {
							store = createStore()
						}, {
							DesignTokenProvider = React.createElement(DesignTokenProvider, {
								tokenMappers = {}
							}, {
								FoundationProvider = React.createElement(FoundationProvider, {
									theme = v24,
									device = t2[p3.platform],
									preferences = p3.settings,
									scale = p3.settings and p3.settings.scale
								}, {
									Child = React.createElement(p2, p3)
								})
							})
						})
					})
				})
			} else {
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = createStore()
				}, {
					FoundationProvider = React.createElement(FoundationProvider, {
						theme = v24,
						device = t2[p3.platform],
						preferences = p3.settings,
						scale = p3.settings and p3.settings.scale
					}, {
						Child = React.createElement(p2, p3)
					})
				})
			}

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
					localization = createLocalization()
				}, v25)
			})
		end
	end
}
