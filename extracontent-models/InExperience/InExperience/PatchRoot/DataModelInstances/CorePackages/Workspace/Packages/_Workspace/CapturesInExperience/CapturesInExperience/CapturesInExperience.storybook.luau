local parent = script.Parent
local parent2 = parent.Parent

local Dash = require(parent2.Dash)
local Roact = require(parent2.Roact)
local SocialTestHelpers = require(parent2.Dev.SocialTestHelpers)
local UIBlox = require(parent2.UIBlox)
local RobloxAppUIBloxConfig = require(parent2.Dev.RobloxAppUIBloxConfig)

local CapturesContext = require(parent.Context.CapturesContext)
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
Storybook.name = "CapturesInExperience"
Storybook.storyRoot = parent
Storybook.roact = Roact

function Storybook.mapDefinition(p)
	local joined = Dash.join(v2, p.controls)
	return Dash.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		return Roact.createElement(CapturesContext.Provider, {
			value = { fireAnalyticsEvent = Dash.noop }
		}, {
			Element = Roact.createElement(AppStyleProvider, {
				style = p2 and v[p2.theme] or v.Default
			}, { Child = mockLocale(p, p2) })
		})
	end
end

return Storybook
