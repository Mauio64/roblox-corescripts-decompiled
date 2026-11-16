local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")

local useImpressionsTagger = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/useImpressionsTagger")

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
