local ToastLite = script:FindFirstAncestor("ToastLite")
local parent = ToastLite.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local ReactRoblox = require(parent.Dev.ReactRoblox)
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local v = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	name = "ToastLite",
	storyRoot = ToastLite,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			return React.createElement(AppStyleProvider, {
				style = p2 and v[p2.theme] or v.Default
			}, { Child = React.createElement(p, p2) })
		end
	end
}
