local AvatarExperienceFavoritesManager = script:FindFirstAncestor("AvatarExperienceFavoritesManager")
local AvatarExperienceFavoritesManagerParent = AvatarExperienceFavoritesManager.Parent
local React = require(AvatarExperienceFavoritesManagerParent.React)
local Foundation = require(AvatarExperienceFavoritesManagerParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local ReactRoblox = require(AvatarExperienceFavoritesManagerParent.Dev.ReactRoblox)
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t2 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}
local t3 = {
	Default = {
		themeName = "Dark",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}

return {
	name = "AvatarExperienceFavoritesManager",
	storyRoot = AvatarExperienceFavoritesManager,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 36
		-- upvalues: t1 (copy), React (copy), FoundationProvider (copy), t3 (copy), t2 (copy)
		return function(p2) -- line: 37
			-- upvalues: t1 (copy), React (copy), FoundationProvider (copy), t3 (copy), t2 (copy), p1 (copy)
			local v14 = t1[p2.theme]

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
				FoundationProvider = React.createElement(FoundationProvider, {
					DONOTUSE_colorUpdate = true,
					styleTable = t3,
					theme = v14,
					device = t2[p2.platform]
				}, {
					Child = React.createElement(p1, p2)
				})
			})
		end
	end
}
