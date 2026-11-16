local DiscoverabilityModal = script:FindFirstAncestor("DiscoverabilityModal")
local parent = DiscoverabilityModal.Parent
local dependencies = require(DiscoverabilityModal.dependencies)
local roact = dependencies.Roact
local dash = dependencies.Dash
local uiBlox = dependencies.UIBlox
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

uiBlox.init(RobloxAppUIBloxConfig)

local appStyleProvider = uiBlox.App.Style.AppStyleProvider

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }
local Storybook = {}
Storybook.name = "DiscoverabilityModal"
Storybook.storyRoot = DiscoverabilityModal
Storybook.roact = roact

function Storybook.mapDefinition(p)
	local joined = dash.join(v2, p.controls or {})
	return dash.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		return roact.createElement(appStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, { Child = mockLocale(p, p2) })
	end
end

return Storybook
