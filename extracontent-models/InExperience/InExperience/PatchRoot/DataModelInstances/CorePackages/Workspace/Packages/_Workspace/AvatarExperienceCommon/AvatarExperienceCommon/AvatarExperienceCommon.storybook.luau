local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local UIBlox = require(Parent.UIBlox)

UIBlox.init(require(Parent.Dev.RobloxAppUIBloxConfig))

local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local Rodux = require(Parent.Rodux)
local DesignTokenProvider = require(Parent.Style).DesignTokenProvider
local RoactRodux = require(Parent.RoactRodux)
local AppStyleProvider = require(Parent.Style).AppStyleProvider
local AppStyleProvider2 = UIBlox.App.Style.AppStyleProvider
local ReactRoblox = require(Parent.ReactRoblox)

local function createStore() -- line: 18
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
	name = "AvatarExperienceCommon",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 47
		-- upvalues: t1 (copy), React (copy), AppStyleProvider2 (copy), t3 (copy), AppStyleProvider (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy)
		return function(p2) -- line: 48
			-- upvalues: t1 (copy), React (copy), AppStyleProvider2 (copy), t3 (copy), AppStyleProvider (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy), p1 (copy)
			local v20 = t1[p2.theme]

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
				AppStyleProvider = React.createElement(AppStyleProvider2, {
					style = p2 and t3[p2.theme] or t3.Default
				}, {
					StyleProvider = React.createElement(AppStyleProvider, {
						style = p2 and t3[p2.theme] or t3.Default
					}, {
						StoreProvider = React.createElement(RoactRodux.StoreProvider, {
							store = createStore()
						}, {
							DesignTokenProvider = React.createElement(DesignTokenProvider, {
								tokenMappers = {}
							}, {
								FoundationProvider = React.createElement(FoundationProvider, {
									theme = v20,
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
		end
	end
}
