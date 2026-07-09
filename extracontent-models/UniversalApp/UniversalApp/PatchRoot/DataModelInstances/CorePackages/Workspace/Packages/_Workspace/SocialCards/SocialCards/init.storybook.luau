local SocialCards = script:FindFirstAncestor("SocialCards")
local SocialCardsParent = SocialCards.Parent
local Foundation = require(SocialCardsParent.Foundation)
local React = require(SocialCardsParent.React)
local ReactRoblox = require(SocialCardsParent.Dev.ReactRoblox)
local AppStyleProvider = require(SocialCardsParent.Dev.UIBlox).App.Style.AppStyleProvider
local t1 = {
	Default = Foundation.Enums.Theme.Dark,
	Light = Foundation.Enums.Theme.Light,
	Dark = Foundation.Enums.Theme.Dark
}
local t2 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}

return {
	name = SocialCards.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoot = SocialCards,
	mapStory = function(p1) -- line: 29
		-- upvalues: t1 (copy), React (copy), Foundation (copy), t2 (copy), AppStyleProvider (copy)
		return function(p2) -- line: 30
			-- upvalues: t1 (copy), React (copy), Foundation (copy), t2 (copy), AppStyleProvider (copy), p1 (copy)
			local v11 = p2 and t1[p2.theme] or t1.Default

			return React.createElement(Foundation.FoundationProvider, {
				theme = v11,
				device = p2 and t2[p2.platform] or t2.Default
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = {
						fontName = "Gotham",
						themeName = v11.themeName
					}
				}, {
					Child = React.createElement(p1, p2)
				})
			})
		end
	end
}
