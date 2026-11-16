local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Roact = require(parent.Dev.Roact)

local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(parent.Dev.RobloxAppUIBloxConfig)

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({ elementTracing = true })

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }

local function fn(state)
	return Rodux.Store.new(function()
		return Cryo.Dictionary.join(state, { ScreenSize = Vector2.new(600, 600) })
	end, {}, { Rodux.thunkMiddleware })
end

local Storybook = {}
Storybook.name = "ProfilePlatform"
Storybook.storyRoot = ProfilePlatform
Storybook.roact = Roact
Storybook.roactRodux = RoactRodux

function Storybook.mapDefinition(p)
	local joined = Cryo.Dictionary.join(v2, p.controls or {})
	return Cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		local state = p2.definition.state or {}
		return Roact.createElement(AppStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, {
			storeProvider = Roact.createElement(RoactRodux.StoreProvider, { store = fn(state) }, {
				Child = mockLocale(p, p2)
			})
		})
	end
end

return Storybook
