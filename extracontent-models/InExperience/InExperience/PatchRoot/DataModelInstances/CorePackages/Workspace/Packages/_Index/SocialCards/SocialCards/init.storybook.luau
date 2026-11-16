local SocialCards = script:FindFirstAncestor("SocialCards")

local parent = SocialCards.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local UIBlox = require(parent.Dev.UIBlox)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local v = {
	Default = Foundation.Enums.ColorMode.Dark,
	Light = Foundation.Enums.ColorMode.Light,
	Dark = Foundation.Enums.ColorMode.Dark
}

local v2 = { Default = "Desktop", Desktop = "Desktop", Console = "Console" }

return {
	name = SocialCards.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoot = SocialCards,
	mapStory = function(p)
		return function(p2)
			local colorMode = p2 and v[p2.theme] or v.Default
			return React.createElement(Foundation.FoundationProvider, {
				colorMode = colorMode,
				device = p2 and v2[p2.platform] or "Desktop"
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = { themeName = colorMode.themeName, fontName = "Gotham" }
				}, { Child = React.createElement(p, p2) })
			})
		end
	end
}
