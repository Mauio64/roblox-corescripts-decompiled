local ToastLite = script:FindFirstAncestor("ToastLite")
local ToastLiteParent = ToastLite.Parent
local React = require(ToastLiteParent.React)
local UIBlox = require(ToastLiteParent.UIBlox)
local ReactRoblox = require(ToastLiteParent.Dev.ReactRoblox)
local RobloxAppUIBloxConfig = require(ToastLiteParent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
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
	name = "ToastLite",
	storyRoot = ToastLite,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 34
		-- upvalues: React (copy), AppStyleProvider (copy), t1 (copy)
		return function(p2) -- line: 35
			-- upvalues: React (copy), AppStyleProvider (copy), t1 (copy), p1 (copy)
			return React.createElement(AppStyleProvider, {
				style = p2 and t1[p2.theme] or t1.Default
			}, {
				Child = React.createElement(p1, p2)
			})
		end
	end
}
