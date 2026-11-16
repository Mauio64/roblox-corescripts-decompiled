local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local ReactRoblox = require(parent.ReactRoblox)

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

return {
	name = "SduiSharedUtilities",
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
					FoundationContext = React.createElement(FoundationProvider, {
						colorMode = v[props.theme],
						device = Device[props.platform],
						preferences = props.settings,
						scale = props.settings and props.settings.scale
					}, { Child = React.createElement(p, props) })
				}
			)
		end
	end
}
