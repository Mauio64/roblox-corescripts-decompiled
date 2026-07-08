local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Cryo = require(scriptParentParent.Cryo)
local Roact = require(scriptParentParent.Roact)
local isRoact17 = require(scriptParent.isRoact17)
local Rect = require(scriptParent.Rect)
local t1 = {
	Horizontal = {},
	Vertical = {},
	Both = {}
}
local v8 = Roact.PureComponent:extend("FitFrameOnAxis")

v8.defaultProps = {
	textProps = nil,
	axis = t1.Vertical,
	minimumSize = UDim2.new(UDim.new(0, 0), UDim.new(0, 0)),
	margin = Rect.square(0),
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	ImageSet = {},
	VerticalAlignment = Enum.VerticalAlignment.Top,
	contentPadding = UDim.new(0, 0)
}

function v8.init(p1) -- line: 31
	-- upvalues: Roact (copy), isRoact17 (copy)
	p1.layoutRef = Roact.createRef()

	if isRoact17() then
		p1.frameRef = p1.props.forwardedRef or Roact.createRef()
	else
		p1.frameRef = p1.props[Roact.Ref] or Roact.createRef()
	end

	function p1.onResize() -- line: 39
		-- upvalues: p1 (copy)
		local current = p1.layoutRef.current
		local current2 = p1.frameRef.current

		if not current2 or not current then
			return
		end

		current2.Size = p1:__getSize(current)
	end
end
function v8.render(p2) -- line: 50
	-- upvalues: Roact (copy), Cryo (copy)
	assert(p2.props.Size == nil, "Size is not a valid property of FitFrameOnAxis. Did you mean `minimumSize`?")

	local v12 = p2.props[Roact.Children] or {}
	local v13 = p2:__getFilteredProps()
	local v14 = not p2.props.onActivated and "ImageLabel" or "ImageButton"
	local v15 = Cryo.Dictionary.join(v12, {
		["$layout"] = Roact.createElement("UIListLayout", {
			FillDirection = p2.props.FillDirection,
			HorizontalAlignment = p2.props.HorizontalAlignment,
			Padding = p2.props.contentPadding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = p2.props.VerticalAlignment,
			[Roact.Change.AbsoluteContentSize] = p2.onResize,
			[Roact.Ref] = p2.layoutRef
		}),
		["$margin"] = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p2.props.margin.left),
			PaddingRight = UDim.new(0, p2.props.margin.right),
			PaddingTop = UDim.new(0, p2.props.margin.top),
			PaddingBottom = UDim.new(0, p2.props.margin.bottom)
		})
	})

	if p2.props.textProps then
		return Roact.createElement(v14, v13, {
			TextLabel = Roact.createElement("TextLabel", Cryo.Dictionary.join(p2.props.textProps, {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			})),
			ChildFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, v15)
		})
	end

	return Roact.createElement(v14, v13, v15)
end
function v8.didMount(p3) -- line: 93
	p3.onResize()
end
function v8.didUpdate(p4) -- line: 97
	p4.onResize()
end
function v8.__getFilteredProps(p5) -- line: 101
	-- upvalues: Cryo (copy), Roact (copy), v8 (copy)
	local v19 = Cryo.Dictionary.join(p5.props.ImageSet, {
		[Roact.Ref] = p5.frameRef,
		[Roact.Event.Activated] = p5.props.onActivated
	})

	for k, _ in pairs(v8.defaultProps) do
		v19[k] = Cryo.None
	end

	v19.textProps = Cryo.None

	return Cryo.Dictionary.join(p5.props, v19, {
		onActivated = Cryo.None,
		forwardedRef = Cryo.None,
		[Roact.Children] = Cryo.None
	})
end
function v8.__getSize(p6, p7) -- line: 124
	-- upvalues: t1 (copy)
	if p6.props.axis == t1.Both then
		return p6:__getBothAxisSize(p7)
	end

	local v24 = p6:__getAxisUDim(p7.AbsoluteContentSize)
	local v25 = p6:__getOtherUDim()

	if p6.props.axis == t1.Vertical then
		return UDim2.new(v25, v24)
	end

	if p6.props.axis == t1.Horizontal then
		return UDim2.new(v24, v25)
	end
end
function v8.__getBothAxisSize(p8, p9) -- line: 141
	local minimumSize = p8.props.minimumSize
	local AbsoluteContentSize = p9.AbsoluteContentSize
	local uDim = UDim.new(minimumSize.X.Scale, AbsoluteContentSize.X + p8:__getHorizontalMargin())
	local uDim2 = UDim.new(minimumSize.Y.Scale, AbsoluteContentSize.Y + p8:__getVerticalMargin())

	return UDim2.new(uDim, uDim2)
end
function v8.__getAxisUDim(p10, p11) -- line: 151
	-- upvalues: t1 (copy)
	local minimumSize = p10.props.minimumSize
	local minimumSizeY = nil
	local v36 = nil

	if p10.props.axis == t1.Vertical then
		minimumSizeY = minimumSize.Y
		v36 = p11.Y + p10:__getVerticalMargin()
	elseif p10.props.axis == t1.Horizontal then
		minimumSizeY = minimumSize.X
		v36 = p11.X + p10:__getHorizontalMargin()
	end

	return UDim.new(minimumSizeY.Scale, (math.max(v36, minimumSizeY.Offset)))
end
function v8.__getVerticalMargin(p12) -- line: 169
	return p12.props.margin.top + p12.props.margin.bottom
end
function v8.__getHorizontalMargin(p13) -- line: 173
	return p13.props.margin.left + p13.props.margin.right
end
function v8.__getOtherUDim(p14) -- line: 177
	-- upvalues: t1 (copy)
	local minimumSize = p14.props.minimumSize

	if p14.props.axis == t1.Vertical then
		return minimumSize.X
	end

	if p14.props.axis == t1.Horizontal then
		return minimumSize.Y
	end
end

local v9 = if not isRoact17() then v8 else Roact.forwardRef(function(p15, p16) -- line: 191
	-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
	return Roact.createElement(v8, Cryo.Dictionary.join(p15, {
		forwardedRef = p16
	}))
end)

v9.Axis = t1

return v9
