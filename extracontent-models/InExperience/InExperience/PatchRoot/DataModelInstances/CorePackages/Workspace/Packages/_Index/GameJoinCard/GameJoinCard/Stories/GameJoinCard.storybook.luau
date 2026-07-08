local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local GameJoinCardParent = GameJoinCard.Parent
local React = require(GameJoinCardParent.React)
local ReactRoblox = require(GameJoinCardParent.Dev.ReactRoblox)
local Cryo = require(GameJoinCardParent.Dev.Cryo)
local Style = require(GameJoinCardParent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = Style.DesignTokenProvider
local mockLocale = require(GameJoinCardParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local Rodux = require(GameJoinCardParent.Dev.Rodux)
local RoactRodux = require(GameJoinCardParent.Dev.RoactRodux)
local t1 = {}

local function createStore(_) -- line: 15
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 16
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = {
				topBarHeight = 0
			},
			GlobalGuiInset = {
				left = 0,
				top = 0,
				right = 0,
				bottom = 0
			}
		}
	end, {}, { Rodux.thunkMiddleware })
end

return {
	name = "GameJoinCard",
	storyRoot = GameJoinCard.Stories,
	roact = React,
	reactRoblox = ReactRoblox,
	mapDefinition = function(p2) -- line: 37
		-- upvalues: Cryo (copy), t1 (copy)
		local v16 = Cryo.Dictionary.join(t1, p2.controls or {})

		return Cryo.Dictionary.join(p2, {
			controls = v16
		})
	end,
	mapStory = function(p3) -- line: 41
		-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), mockLocale (copy)
		return function(p4) -- line: 42
			-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), mockLocale (copy), p3 (copy)
			local v19 = p4.theme == nil or p4.theme ~= "Light"

			return React.createElement(StyleProviderWithDefaultTheme, {
				withUiModeSupport = false,
				withDarkTheme = v19
			}, { React.createElement(RoactRodux.StoreProvider, {
				store = createStore(nil)
			}, {
				designTokenProvider = React.createElement(DesignTokenProvider, {
					tokenMappers = {}
				}, {
					Child = mockLocale(p3, p4)
				})
			}) })
		end
	end
}
