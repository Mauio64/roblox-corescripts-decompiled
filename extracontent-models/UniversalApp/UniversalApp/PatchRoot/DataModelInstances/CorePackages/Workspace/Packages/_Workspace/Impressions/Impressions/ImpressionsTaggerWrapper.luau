local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local useImpressionsTagger = require(script.Parent.useImpressionsTagger)

local function ImpressionsTagWrapper(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), useImpressionsTagger (copy)
	local v6 = React.useRef(nil)

	useImpressionsTagger(v6, t1.impressionsTag, t1.impressionsIndex)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = t1.impressionsIndex,
		ref = v6
	}, {
		ComponentWithImpressionsTag = t1.renderComponent()
	})
end

return ImpressionsTagWrapper
