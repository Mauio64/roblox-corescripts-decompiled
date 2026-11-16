local FriendsMenu = script:FindFirstAncestor("FriendsMenu")
local parent = FriendsMenu.Parent

local UIBlox = require(parent.UIBlox)

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))

local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

local Cryo = require(parent.Cryo)
local Roact = require(parent.Dev.Roact)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }
local Storybook = {}
Storybook.name = "FriendsMenu"
Storybook.storyRoot = FriendsMenu
Storybook.roact = Roact

function Storybook.mapDefinition(p)
	local joined = Cryo.Dictionary.join(v2, p.controls or {})
	return Cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		return Roact.createElement(AppStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, { Child = mockLocale(p, p2) })
	end
end

return Storybook
