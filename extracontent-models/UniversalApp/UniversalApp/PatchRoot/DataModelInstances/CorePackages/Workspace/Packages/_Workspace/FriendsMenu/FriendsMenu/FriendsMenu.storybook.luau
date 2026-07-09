local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local FriendsMenuParent = FriendsMenu.Parent
local UIBlox = require(FriendsMenuParent.UIBlox)

UIBlox.init(require(FriendsMenuParent.Dev.RobloxAppUIBloxConfig))

local mockLocale = require(FriendsMenuParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local Cryo = require(FriendsMenuParent.Cryo)
local Roact = require(FriendsMenuParent.Dev.Roact)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local t1 = {
	Default = {
		themeName = "Light",
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
local t2 = {
	language = "en-us"
}

return {
	name = "FriendsMenu",
	storyRoot = FriendsMenu,
	roact = Roact,
	mapDefinition = function(p1) -- line: 39
		-- upvalues: Cryo (copy), t2 (copy)
		local v11 = Cryo.Dictionary.join(t2, p1.controls or {})

		return Cryo.Dictionary.join(p1, {
			controls = v11
		})
	end,
	mapStory = function(p2) -- line: 43
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 44
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p3 and t1[p3.theme] or t1.Default
			}, {
				Child = mockLocale(p2, p3)
			})
		end
	end
}
