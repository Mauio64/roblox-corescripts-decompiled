local parent = script:FindFirstAncestor("AvatarExperienceControlBar").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local AppLocales = require(parent.Dev.AppLocales)
local localization = AppLocales.Localization
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
	name = "AvatarExperienceControlBar",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local colorMode = v[props.theme]

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
					LocalizationProvider = React.createElement(
						LocalizationProvider,
						{ localization = localization.new("en-us") },
						{
							FoundationProvider = React.createElement(FoundationProvider, {
								styleTable = styleTable,
								colorMode = colorMode,
								device = v2[props.platform],
								preferences = props.settings,
								DONOTUSE_colorUpdate = true
							}, { Child = React.createElement(p, props) })
						}
					)
				}
			)
		end
	end
}
