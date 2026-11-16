local MediaGallery = script:FindFirstAncestor("MediaGallery")

local parent = MediaGallery.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Rodux = require(parent.Dev.Rodux)
local RoactRodux = require(parent.Dev.RoactRodux)
local RoactNavigation = require(parent.Dev.RoactNavigation)
local UIBlox = require(parent.UIBlox)
UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Foundation = require(parent.Foundation)

local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local store = Rodux.Store.new(function(p)
	return p
end, {
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = { topBarHeight = 0 },
	GlobalGuiInset = { bottom = 0, left = 0, right = 0, top = 0 }
}, {})

local v2 = {
	isFocused = function(): boolean
		return true
	end,
	addListener = function(_, _, _)
		return {
			remove = function() end
		}
	end
}

return {
	name = MediaGallery.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			return React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 10),
						PaddingBottom = UDim.new(0, 10),
						PaddingLeft = UDim.new(0, 10),
						PaddingRight = UDim.new(0, 10)
					}),
					StoreProvider = React.createElement(RoactRodux.StoreProvider, { store = store }, {
						NavigationContext = React.createElement(RoactNavigation.Context.Provider, {
							value = v2
						}, {
							FoundationContext = React.createElement(FoundationProvider, {
								colorMode = v[props.theme],
								device = Device[props.platform],
								preferences = props.settings,
								scale = props.settings and props.settings.scale
							}, {
								StyleProvider = React.createElement(AppStyleProvider, {
									style = { themeName = "Dark", fontName = "Gotham" }
								}, { Child = React.createElement(p, props) })
							})
						})
					})
				}
			)
		end
	end,
	storyRoots = { MediaGallery }
}
