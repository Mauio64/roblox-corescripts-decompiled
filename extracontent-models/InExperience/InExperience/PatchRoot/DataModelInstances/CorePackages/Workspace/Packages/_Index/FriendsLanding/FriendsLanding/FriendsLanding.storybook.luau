local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local Logger = require(FriendsLanding.Logger)
local dependencies = require(FriendsLanding.dependencies)
local appStyleProvider = dependencies.UIBlox.App.Style.AppStyleProvider
local roact = dependencies.Roact
local universalAppPolicy = dependencies.UniversalAppPolicy
local llama = dependencies.llama

local parent = FriendsLanding.Parent
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode

local logger = dependencies.Lumberyak.Logger.new()

logger:addSink({
	maxLevel = logger.Levels.fromString("info"),
	log = function(_, p, _)
		print(p)
	end
})

Logger:setParent(logger)

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v3 = { language = "en-us" }
local Storybook = {}

function Storybook.mapDefinition(p)
	local joined = llama.Dictionary.join(v3, p.controls or {})
	return llama.Dictionary.join(p, { controls = joined })
end

Storybook.roact = roact

function Storybook.mapStory(p)
	return function(p2)
		local style = p2 and v[p2.theme] or v.Default

		return roact.createElement(FoundationProvider, { colorMode = v2[style.themeName] }, {
			AppStyle = roact.createElement(appStyleProvider, { style = style }, {
				roact.createElement(universalAppPolicy.Provider, {
					policy = { function()
							return {
								getShowDisplayName = function()
									return p2.controls.getShowDisplayName
								end
							}
						end }
				}, { Child = mockLocale(p, p2) })
			})
		})
	end
end

return Storybook
