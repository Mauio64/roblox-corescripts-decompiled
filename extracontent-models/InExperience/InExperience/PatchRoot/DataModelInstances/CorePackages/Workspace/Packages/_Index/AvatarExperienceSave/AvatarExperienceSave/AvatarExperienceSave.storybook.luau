local parent = script:FindFirstAncestor("AvatarExperienceSave").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local ReactRoblox = require(parent.Dev.ReactRoblox)

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v2 = { Console = Device.Console, Desktop = Device.Desktop }

local styleTable = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

return {
	name = "AvatarExperienceSave",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			local colorMode = v[p2.theme]

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
					FoundationProvider = React.createElement(
						FoundationProvider,
						{
							styleTable = styleTable,
							colorMode = colorMode,
							device = v2[p2.platform],
							DONOTUSE_colorUpdate = true
						},
						{ Child = React.createElement(p, p2) }
					)
				}
			)
		end
	end
}
