local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(Foundation.Enums.ColorNamespace)
local React = require(parent.React)
local useTokens = require(Foundation.Providers.Style.useTokens)

local forwardRef = React.forwardRef(function(props, ref)
	local v = useTokens()
	local colorNamespace = props.colorNamespace

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(-props.offset, -props.offset),
		Size = UDim2.new(1, props.offset * 2, 1, props.offset * 2),
		ref = ref
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = props.cornerRadius }),
		UIStroke = React.createElement(
			"UIStroke",
			{
				Color = v[colorNamespace].Selection.Start.Color3,
				Transparency = v[colorNamespace].Selection.Start.Transparency,
				Thickness = props.borderWidth
			},
			{}
		)
	})
end)

return React.memo(forwardRef)
