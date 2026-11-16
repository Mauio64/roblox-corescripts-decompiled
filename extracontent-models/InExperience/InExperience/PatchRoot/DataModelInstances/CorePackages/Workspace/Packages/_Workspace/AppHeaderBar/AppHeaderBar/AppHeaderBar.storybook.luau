local AppHeaderBar = script:FindFirstAncestor("AppHeaderBar")
local parent = AppHeaderBar.Parent
local RoactCompat = require(parent.Dev.RoactCompat)
local React = require(parent.React)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)
local UIBlox = require(parent.UIBlox)

UIBlox.init(RobloxAppUIBloxConfig)

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Light = ColorMode.Light
local Dark = ColorMode.Dark
local Gotham = Constants.FontName.Gotham

RoactCompat.setGlobalConfig({ elementTracing = true })

local v = {
	Default = { themeName = Light, fontName = Gotham },
	Light = { themeName = Light, fontName = Gotham },
	Dark = { themeName = Dark, fontName = Gotham }
}

local v2 = { Console = Constants.DeviceType.Console, Desktop = Constants.DeviceType.Desktop }

return {
	name = "AppHeaderBar",
	storyRoots = { AppHeaderBar },
	roact = RoactCompat,
	mapStory = function(p)
		return function(props)
			local v3 = v[props.theme]
			return React.createElement(AppStyleProvider, {
				style = {
					themeName = v3.themeName,
					fontName = v3.fontName,
					deviceType = v2[props.platform],
					settings = props.settings
				}
			}, { Child = React.createElement(p, props) })
		end
	end
}
