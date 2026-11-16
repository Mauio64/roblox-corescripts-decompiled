local parent = script:FindFirstAncestor("Impressions").Parent

local React = require(parent.React)

local useImpressionsTagger = require(script.Parent.useImpressionsTagger)

local function ImpressionsTagWrapper(props)
	local ref = React.useRef(nil)

	useImpressionsTagger(ref, props.impressionsTag, props.impressionsIndex)

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			LayoutOrder = props.impressionsIndex,
			ref = ref
		},
		{ ComponentWithImpressionsTag = props.renderComponent() }
	)
end

return ImpressionsTagWrapper
