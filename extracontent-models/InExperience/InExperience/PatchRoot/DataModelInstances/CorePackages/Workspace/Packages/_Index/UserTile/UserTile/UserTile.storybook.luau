local UserTile = script:FindFirstAncestor("UserTile")
local UserTileParent = UserTile.Parent
local React = require(UserTileParent.React)
local ReactRoblox = require(UserTileParent.ReactRoblox)
local Foundation = require(UserTileParent.Foundation)
local Style = require(UserTileParent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local FoundationProvider = Foundation.FoundationProvider
local DesignTokenProvider = Style.DesignTokenProvider
local Rodux = require(UserTileParent.Rodux)
local RoactNavigation = require(UserTileParent.RoactNavigation)
local RoactRodux = require(UserTileParent.RoactRodux)
local Theme = Foundation.Enums.Theme
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}

local function createStore(_) -- line: 20
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 21
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = {
				topBarHeight = 100
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
local function mockNavigation(p2) -- line: 37
	-- upvalues: React (copy), RoactNavigation (copy)
	return React.createElement(RoactNavigation.Provider, {
		value = {
			state = {
				routeName = "appPage"
			},
			isFocused = function() -- line: 43
				return true
			end,
			addListener = function() -- line: 46
				return {
					remove = function() -- line: 48
					end
				}
			end,
			getParam = function(_, p4) -- line: 51
				return p4
			end,
			navigate = function() -- line: 54
			end
		}
	}, {
		Child = p2
	})
end

return {
	name = "UserTile",
	storyRoot = UserTile.Stories,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p5) -- line: 66
		-- upvalues: t1 (copy), React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), mockNavigation (copy), FoundationProvider (copy), DesignTokenProvider (copy)
		return function(p6) -- line: 67
			-- upvalues: t1 (copy), React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), mockNavigation (copy), FoundationProvider (copy), DesignTokenProvider (copy), p5 (copy)
			local v23 = t1[p6.theme]

			return React.createElement(StyleProviderWithDefaultTheme, {
				withDarkTheme = true,
				withUiModeSupport = false
			}, { React.createElement(RoactRodux.StoreProvider, {
				store = createStore(nil)
			}, {
				navigationProvider = mockNavigation(React.createElement(FoundationProvider, {
					theme = v23
				}, {
					designTokenProvider = React.createElement(DesignTokenProvider, {
						tokenMappers = {}
					}, {
						Child = p5(p6)
					})
				}))
			}) })
		end
	end
}
