local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local RoactRodux = require(parent.RoactRodux)
local Rodux = require(parent.Rodux)
local Style = require(parent.Style)
local Foundation = require(parent.Foundation)
local RoactNavigation = require(parent.RoactNavigation)

local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = Style.DesignTokenProvider

local function createStore(_)
	return Rodux.Store.new(function()
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = { topBarHeight = 100 },
			GlobalGuiInset = { left = 0, top = 0, right = 0, bottom = 34 }
		}
	end, {}, { Rodux.thunkMiddleware })
end

local function mockNavigation(child)
	return React.createElement(RoactNavigation.Provider, {
		value = {
			state = { routeName = "appPage" },
			isFocused = function(): boolean
				return true
			end,
			addListener = function()
				return {
					remove = function() end
				}
			end,
			getParam = function(_, p)
				return p
			end,
			navigate = function() end
		}
	}, { Child = child })
end

return {
	name = "UserList",
	storyRoot = UserList,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(callback)
		return function(p)
			return React.createElement(
				StyleProviderWithDefaultTheme,
				{ withDarkTheme = true, withUiModeSupport = false },
				{ React.createElement(RoactRodux.StoreProvider, { store = createStore(nil) }, {
						navigationProvider = mockNavigation(React.createElement(
							FoundationProvider,
							{ colorMode = Foundation.Enums.ColorMode.Light },
							{
								designTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Child = callback(p)
								})
							}
						))
					}) }
			)
		end
	end
}
