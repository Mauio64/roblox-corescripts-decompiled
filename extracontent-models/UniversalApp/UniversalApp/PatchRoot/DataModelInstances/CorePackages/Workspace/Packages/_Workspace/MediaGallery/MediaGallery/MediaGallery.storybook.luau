local MediaGallery = script:FindFirstAncestor("MediaGallery")
local MediaGalleryParent = MediaGallery.Parent
local React = require(MediaGalleryParent.React)
local ReactRoblox = require(MediaGalleryParent.ReactRoblox)
local Rodux = require(MediaGalleryParent.Dev.Rodux)
local RoactRodux = require(MediaGalleryParent.Dev.RoactRodux)
local RoactNavigation = require(MediaGalleryParent.Dev.RoactNavigation)
local UIBlox = require(MediaGalleryParent.UIBlox)

UIBlox.init(require(MediaGalleryParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Foundation = require(MediaGalleryParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local v15 = Rodux.Store.new(function(p1) -- line: 23
	return p1
end, {
	ScreenSize = Vector2.new(1920, 1080),
	TopBar = {
		topBarHeight = 0
	},
	GlobalGuiInset = {
		bottom = 0,
		left = 0,
		right = 0,
		top = 0
	}
}, {})
local t2 = {
	isFocused = function() -- line: 32
		return true
	end,
	addListener = function(_, _, _) -- line: 35
		return {
			remove = function() -- line: 36
			end
		}
	end
}

return {
	name = MediaGallery.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p5) -- line: 40
		-- upvalues: React (copy), RoactRodux (copy), v15 (copy), RoactNavigation (copy), t2 (copy), FoundationProvider (copy), t1 (copy), Device (copy), AppStyleProvider (copy)
		return function(p6) -- line: 41
			-- upvalues: React (copy), RoactRodux (copy), v15 (copy), RoactNavigation (copy), t2 (copy), FoundationProvider (copy), t1 (copy), Device (copy), AppStyleProvider (copy), p5 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				}),
				StoreProvider = React.createElement(RoactRodux.StoreProvider, {
					store = v15
				}, {
					NavigationContext = React.createElement(RoactNavigation.Context.Provider, {
						value = t2
					}, {
						FoundationContext = React.createElement(FoundationProvider, {
							theme = t1[p6.theme],
							device = Device[p6.platform],
							preferences = p6.settings,
							scale = p6.settings and p6.settings.scale
						}, {
							StyleProvider = React.createElement(AppStyleProvider, {
								style = {
									themeName = "Dark",
									fontName = "Gotham"
								}
							}, {
								Child = React.createElement(p5, p6)
							})
						})
					})
				})
			})
		end
	end,
	storyRoots = { MediaGallery }
}
