local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local function withCommonProps(data, p)
	if type(p) ~= "table" then
		return p
	end

	p.AnchorPoint = data.AnchorPoint

	p.LayoutOrder = data.LayoutOrder

	p.Position = data.Position

	p.Visible = data.Visible

	p.ZIndex = data.ZIndex

	p.onAbsoluteSizeChanged = data.onAbsoluteSizeChanged

	p.onAbsolutePositionChanged = data.onAbsolutePositionChanged

	p.testId = data.testId

	return p
end

return withCommonProps
