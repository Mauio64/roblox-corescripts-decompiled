local parent = script.Parent.Parent
local Foundation = require(parent.Foundation)

local React = require(parent.React)

local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device

local function StoryMiddleware(p)
	return function(props)
		local theme = Theme[props.theme]
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
				FoundationContext = React.createElement(
					FoundationProvider,
					{ theme = theme, device = Device[props.platform], preferences = props.settings },
					{ Child = React.createElement(p, props) }
				)
			}
		)
	end
end

return StoryMiddleware
