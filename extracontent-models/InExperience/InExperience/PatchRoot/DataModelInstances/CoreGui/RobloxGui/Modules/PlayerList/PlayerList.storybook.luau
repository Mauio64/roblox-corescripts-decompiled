local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

return {
	name = "PlayerList (legacy)",
	storyRoot = script.Parent,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			local settings = p2.settings
			local createElement = React.createElement
			local v = { colorMode = ColorMode.Dark, preferences = settings, scale = 0 }
			local scale

			if settings then
				scale = settings.scale
			end

			v.scale = scale
			return createElement(FoundationProvider, v, {
				Style = React.createElement(AppStyleProvider, {
					style = { themeName = "Dark", fontName = "Gotham", settings = settings }
				}, { Child = React.createElement(p, p2) })
			})
		end
	end
}
