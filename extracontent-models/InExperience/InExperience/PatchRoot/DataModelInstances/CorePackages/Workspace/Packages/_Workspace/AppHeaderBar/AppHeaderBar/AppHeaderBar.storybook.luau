local AppHeaderBar = script:FindFirstAncestor("AppHeaderBar")
local AppHeaderBarParent = AppHeaderBar.Parent
local RoactCompat = require(AppHeaderBarParent.Dev.RoactCompat)
local React = require(AppHeaderBarParent.React)
local RobloxAppUIBloxConfig = require(AppHeaderBarParent.Dev.RobloxAppUIBloxConfig)
local UIBlox = require(AppHeaderBarParent.UIBlox)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Light = Constants.ThemeName.Light
local Dark = Constants.ThemeName.Dark
local Gotham = Constants.FontName.Gotham

RoactCompat.setGlobalConfig({
	elementTracing = true
})

local t1 = {
	Default = {
		themeName = Light,
		fontName = Gotham
	},
	Light = {
		themeName = Light,
		fontName = Gotham
	},
	Dark = {
		themeName = Dark,
		fontName = Gotham
	}
}
local t2 = {
	Console = Constants.DeviceType.Console,
	Desktop = Constants.DeviceType.Desktop
}

return {
	name = "AppHeaderBar",
	storyRoots = { AppHeaderBar },
	roact = RoactCompat,
	mapStory = function(p1) -- line: 45
		-- upvalues: t1 (copy), React (copy), AppStyleProvider (copy), t2 (copy)
		return function(p2) -- line: 46
			-- upvalues: t1 (copy), React (copy), AppStyleProvider (copy), t2 (copy), p1 (copy)
			local v16 = t1[p2.theme]

			return React.createElement(AppStyleProvider, {
				style = {
					themeName = v16.themeName,
					fontName = v16.fontName,
					deviceType = t2[p2.platform],
					settings = p2.settings
				}
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end
}
