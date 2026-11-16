local UserTile = script:FindFirstAncestor("UserTile")
local parent = UserTile.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local FoundationProvider = Foundation.FoundationProvider
local DesignTokenProvider = Style.DesignTokenProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local Rodux = require(parent.Rodux)
local RoactNavigation = require(parent.RoactNavigation)
local RoactRodux = require(parent.RoactRodux)
local ColorMode = Foundation.Enums.ColorMode

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local function createStore(_)
	return Rodux.Store.new(function()
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = { topBarHeight = 100 },
			GlobalGuiInset = { left = 0, top = 0, right = 0, bottom = 0 }
		}
	end, {}, { Rodux.thunkMiddleware })
end

local localization = {
	Format = function(_, p: string)
		return p
	end,
	GetLocale = function(): string
		return "en-us"
	end,
	changed = {
		connect = function(_, _)
			return {
				disconnect = function() end
			}
		end
	}
}

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
	name = "UserTile",
	storyRoot = UserTile.Stories,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(callback)
		return function(p)
			local colorMode = v[p.theme]
			return React.createElement(LocalizationProvider, { localization = localization }, {
				StyleProvider = React.createElement(
					StyleProviderWithDefaultTheme,
					{ withDarkTheme = true, withUiModeSupport = false },
					{ React.createElement(RoactRodux.StoreProvider, { store = createStore(nil) }, {
							navigationProvider = mockNavigation(React.createElement(
								FoundationProvider,
								{ colorMode = colorMode },
								{
									designTokenProvider = React.createElement(
										DesignTokenProvider,
										{ tokenMappers = {} },
										{ Child = callback(p) }
									)
								}
							))
						}) }
				)
			})
		end
	end
}
