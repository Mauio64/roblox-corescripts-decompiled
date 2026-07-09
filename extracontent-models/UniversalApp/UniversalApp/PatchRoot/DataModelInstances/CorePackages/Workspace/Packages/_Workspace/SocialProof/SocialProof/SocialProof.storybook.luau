local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local React = require(SocialProofParent.React)
local ReactRoblox = require(SocialProofParent.ReactRoblox)
local RoactRodux = require(SocialProofParent.RoactRodux)
local Rodux = require(SocialProofParent.Rodux)
local Style = require(SocialProofParent.Style)
local Foundation = require(SocialProofParent.Foundation)
local RoactNavigation = require(SocialProofParent.RoactNavigation)
local FoundationProvider = Foundation.FoundationProvider
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme
local DesignTokenProvider = Style.DesignTokenProvider

local function createStore(_) -- line: 18
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 19
		return {
			ScreenSize = Vector2.new(600, 600),
			TopBar = {
				topBarHeight = 100
			},
			GlobalGuiInset = {
				left = 0,
				top = 0,
				right = 0,
				bottom = 34
			}
		}
	end, {}, { Rodux.thunkMiddleware })
end
local function mockNavigation(p2) -- line: 35
	-- upvalues: React (copy), RoactNavigation (copy)
	return React.createElement(RoactNavigation.Provider, {
		value = {
			state = {
				routeName = "appPage"
			},
			isFocused = function() -- line: 41
				return true
			end,
			addListener = function() -- line: 44
				return {
					remove = function() -- line: 46
					end
				}
			end,
			getParam = function(_, p4) -- line: 49
				return p4
			end,
			navigate = function() -- line: 52
			end
		}
	}, {
		Child = p2
	})
end

return {
	name = "SocialProof",
	storyRoot = SocialProof,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p5) -- line: 64
		-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), mockNavigation (copy), FoundationProvider (copy), Foundation (copy), DesignTokenProvider (copy)
		return function(p6) -- line: 65
			-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy), RoactRodux (copy), createStore (copy), mockNavigation (copy), FoundationProvider (copy), Foundation (copy), DesignTokenProvider (copy), p5 (copy)
			return React.createElement(StyleProviderWithDefaultTheme, {
				withDarkTheme = true,
				withUiModeSupport = false
			}, { React.createElement(RoactRodux.StoreProvider, {
				store = createStore(nil)
			}, {
				navigationProvider = mockNavigation(React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Light
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
