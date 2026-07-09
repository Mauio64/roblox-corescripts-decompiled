local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local Immutable = require(Parent.AppCommonLib).Immutable
local v4 = Roact.PureComponent:extend("FitFrameVertical")

v4.defaultProps = {
	marginTop = 0,
	marginBottom = 0,
	marginLeft = 0,
	marginRight = 0,
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(0, 0, 0, 0),
	width = UDim.new(0, 0),
	contentPadding = UDim.new(0, 0),
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Top
}

function v4.init(p1) -- line: 22
	-- upvalues: Roact (copy)
	p1.layoutRef = Roact.createRef()
	p1.frameRef = Roact.createRef()

	function p1.onResize() -- line: 26
		-- upvalues: p1 (copy)
		local current = p1.layoutRef.current
		local current2 = p1.frameRef.current

		if not current2 or not current then
			return
		end

		local width = p1.props.width
		local AbsoluteContentSizeY = current.AbsoluteContentSize.Y

		current2.Size = UDim2.new(width, UDim.new(0, AbsoluteContentSizeY + p1.props.marginTop + p1.props.marginBottom))
	end
end
function v4.render(p2) -- line: 41
	-- upvalues: Roact (copy), Immutable (copy)
	local propsBackgroundColor3 = p2.props.BackgroundColor3
	local v8 = p2.props[Roact.Children] or {}
	local width = p2.props.width
	local HorizontalAlignment = p2.props.HorizontalAlignment
	local propsBackgroundTransparency = p2.props.BackgroundTransparency
	local contentPadding = p2.props.contentPadding
	local propsLayoutOrder = p2.props.LayoutOrder
	local FillDirection = p2.props.FillDirection
	local VerticalAlignment = p2.props.VerticalAlignment
	local n1 = 0

	if p2.layoutRef.current then
		n1 = p2.layoutRef.current.AbsoluteContentSize.Y
	end

	return Roact.createElement("Frame", {
		AnchorPoint = p2.props.AnchorPoint,
		Position = p2.props.Position,
		BackgroundColor3 = propsBackgroundColor3,
		BackgroundTransparency = propsBackgroundTransparency,
		Size = UDim2.new(width.Scale, width.Offset, 0, n1),
		LayoutOrder = propsLayoutOrder,
		[Roact.Ref] = p2.frameRef,
		Visible = p2.props.Visible,
		BorderSizePixel = 0
	}, Immutable.JoinDictionaries(v8, {
		layout = Roact.createElement("UIListLayout", {
			Padding = contentPadding,
			FillDirection = FillDirection,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = HorizontalAlignment,
			VerticalAlignment = VerticalAlignment,
			[Roact.Ref] = p2.layoutRef,
			[Roact.Change.AbsoluteContentSize] = p2.onResize
		}),
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p2.props.marginLeft),
			PaddingRight = UDim.new(0, p2.props.marginRight),
			PaddingTop = UDim.new(0, p2.props.marginTop),
			PaddingBottom = UDim.new(0, p2.props.marginBottom)
		})
	}))
end
function v4.didMount(p3) -- line: 90
	p3.onResize()
end
function v4.didUpdate(p4) -- line: 94
	p4.onResize()
end

return v4
