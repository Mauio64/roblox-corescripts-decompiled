local module = require("@luauforge/bundled/ecR")
local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local module3 = require("@luauforge/deferred/fXh")

local extended = module.PureComponent:extend("LoadingSkeleton")

function extended.render(p2)
	local size = p2.props.Size
	local position = p2.props.Position
	local anchorPoint = p2.props.AnchorPoint
	local layoutOrder = p2.props.LayoutOrder
	local panels = p2.props.panels
	local createLayout = p2.props.createLayout

	local children = {}

	if createLayout then
		children.Layout = createLayout()
	end

	for i, panel in ipairs(panels) do
		children[i] = module.createElement(module3, {
			Size = panel.Size,
			Position = panel.Position,
			LayoutOrder = i
		})
	end

	if size then
		return module.createElement("Frame", {
			Size = size,
			Position = position,
			AnchorPoint = anchorPoint,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1
		}, children)
	end

	return module.createElement(FitChildren.FitFrame, {
		Size = UDim2.new(1, 0, 1, 0),
		Position = position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		fitAxis = FitChildren.FitAxis.Both
	}, children)
end

return extended
