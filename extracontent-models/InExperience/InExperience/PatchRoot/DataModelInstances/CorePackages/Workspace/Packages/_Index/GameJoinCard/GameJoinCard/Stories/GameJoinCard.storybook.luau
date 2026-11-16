local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local Cryo = require(parent.Dev.Cryo)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = Style.DesignTokenProvider
local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale
local Rodux = require(parent.Dev.Rodux)
local RoactRodux = require(parent.Dev.RoactRodux)

local v = {}

local function createStore(_)
	return Rodux.Store.new(function()
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = { topBarHeight = 0 },
			GlobalGuiInset = { left = 0, top = 0, right = 0, bottom = 0 }
		}
	end, {}, { Rodux.thunkMiddleware })
end

local Storybook = {}
Storybook.name = "GameJoinCard"
Storybook.storyRoot = GameJoinCard.Stories
Storybook.roact = React
Storybook.reactRoblox = ReactRoblox

function Storybook.mapDefinition(p)
	local joined = Cryo.Dictionary.join(v, p.controls or {})
	return Cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		local withDarkTheme = p2.theme == nil or p2.theme ~= "Light"
		return React.createElement(
			StyleProviderWithDefaultTheme,
			{ withDarkTheme = withDarkTheme, withUiModeSupport = false },
			{ React.createElement(RoactRodux.StoreProvider, { store = createStore(nil) }, {
					designTokenProvider = React.createElement(DesignTokenProvider, {
						tokenMappers = {}
					}, {
						Child = mockLocale(p, p2)
					})
				}) }
		)
	end
end

return Storybook
