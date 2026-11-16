local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")

local parent = PlayerContextualMenu.Parent

local Dash = require(parent.Dash)
local Roact = require(parent.Dev.Roact)
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local UIBlox = require(parent.UIBlox)

local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({ elementTracing = true })

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }
local Storybook = {}
Storybook.name = "PlayerContextualMenu"
Storybook.storyRoot = PlayerContextualMenu
Storybook.roact = Roact

function Storybook.mapDefinition(p)
	local joined = Dash.join(v2, p.controls)
	return Dash.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		return Roact.createElement(AppStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, { Child = mockLocale(p, p2) })
	end
end

return Storybook
