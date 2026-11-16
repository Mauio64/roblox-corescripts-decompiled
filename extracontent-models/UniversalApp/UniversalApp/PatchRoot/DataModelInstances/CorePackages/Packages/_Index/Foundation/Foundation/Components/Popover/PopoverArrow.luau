local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

local function PopoverArrow(props)
	return React.createElement(View, {
		Size = UDim2.fromOffset(props.size, props.size),
		Position = props.position,
		Rotation = 45,
		ZIndex = props.ZIndex,
		backgroundStyle = props.backgroundStyle,
		tag = "anchor-center-center",
		testId = props.testId
	})
end

return PopoverArrow
