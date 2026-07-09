local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local ShimmerPanel = require(Modules.LuaApp.Components.ShimmerPanel)
local v5 = Roact.PureComponent:extend("LoadingSkeleton")

function v5.render(p1) -- line: 10
	-- upvalues: Roact (copy), ShimmerPanel (copy), FitChildren (copy)
	local propsSize = p1.props.Size
	local propsPosition = p1.props.Position
	local propsAnchorPoint = p1.props.AnchorPoint
	local propsLayoutOrder = p1.props.LayoutOrder
	local panels = p1.props.panels
	local createLayout = p1.props.createLayout
	local t1 = {}

	if createLayout then
		t1.Layout = createLayout()
	end

	for i, v in ipairs(panels) do
		t1[i] = Roact.createElement(ShimmerPanel, {
			Size = v.Size,
			Position = v.Position,
			LayoutOrder = i
		})
	end

	if propsSize then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = propsSize,
			Position = propsPosition,
			AnchorPoint = propsAnchorPoint,
			LayoutOrder = propsLayoutOrder
		}, t1)
	end

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = propsPosition,
		AnchorPoint = propsAnchorPoint,
		LayoutOrder = propsLayoutOrder,
		fitAxis = FitChildren.FitAxis.Both
	}, t1)
end

return v5
