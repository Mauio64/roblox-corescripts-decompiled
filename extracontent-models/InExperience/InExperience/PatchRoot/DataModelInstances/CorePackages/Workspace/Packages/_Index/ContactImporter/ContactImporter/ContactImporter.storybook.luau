local parent = script.Parent
local parent2 = parent.Parent

local UIBlox = require(parent2.UIBlox)

UIBlox.init(require(parent2.Dev.RobloxAppUIBloxConfig))

local dependencies = require(parent.dependencies)
local roact = dependencies.Roact
local llama = dependencies.llama

local SocialTestHelpers = require(parent2.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

roact.setGlobalConfig({ propValidation = true, elementTracing = true })

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }
local Storybook = {}
Storybook.name = "ContactImporter"
Storybook.storyRoot = parent
Storybook.roact = roact

function Storybook.mapDefinition(p)
	local joined = llama.Dictionary.join(v2, p.controls or {})
	return llama.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		return roact.createElement(AppStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, { Child = mockLocale(p, p2) })
	end
end

return Storybook
