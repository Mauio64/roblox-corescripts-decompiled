local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local t = require(ParentParent2.t)
local Cryo = require(ParentParent2.Cryo)
local Roact = require(ParentParent2.Roact)
local FitFrame = require(ParentParent2.FitFrame)
local bindingValidator = require(ParentParent.Utility.bindingValidator)
local v8 = Roact.PureComponent:extend("ThreeSectionBar")

v8.validateProps = t.strictInterface({
	BackgroundColor3 = t.optional(t.Color3),
	BackgroundTransparency = t.optional(t.union(t.number, bindingValidator(t.number))),
	barHeight = t.optional(t.number),
	contentPaddingLeft = t.optional(t.UDim),
	contentPaddingRight = t.optional(t.UDim),
	estimatedCenterWidth = t.optional(t.number),
	marginLeft = t.optional(t.number),
	marginRight = t.optional(t.number),
	onWidthChange = t.optional(t.callback),
	renderCenter = t.optional(t.callback),
	renderLeft = t.optional(t.callback),
	renderRight = t.optional(t.callback),
	automaticHeight = t.optional(t.boolean),
	sectionSpacing = t.optional(t.number)
})
v8.defaultProps = {
	barHeight = 32,
	BackgroundTransparency = 0,
	marginLeft = 0,
	marginRight = 0,
	renderLeft = nil,
	renderRight = nil,
	renderCenter = nil,
	estimatedCenterWidth = 1e999,
	automaticHeight = false,
	sectionSpacing = 8,
	contentPaddingLeft = UDim.new(0, 0),
	contentPaddingRight = UDim.new(0, 0),
	onWidthChange = function() -- line: 46
		return nil
	end
}

function v8.init(p1) -- line: 55
	-- upvalues: Roact (copy)
	local v10, v11 = Roact.createBinding(0)

	p1.leftWidth = v10
	p1.updateLeftWidth = v11

	local v12, v13 = Roact.createBinding(0)

	p1.rightWidth = v12
	p1.updateRightWidth = v13

	local v14, v15 = Roact.createBinding(0)

	p1.fullWidth = v14
	p1.updateFullWidth = v15

	function p1.computeCenteredSize(p2) -- line: 60
		-- upvalues: p1 (copy)
		local v21 = p2[1]
		local v22 = p2[2]
		local v23 = p2[3]
		local v24 = math.max(v21, v22)
		local magnitude = (Vector2.new(v23 / 2, 0) - Vector2.new(v24, 0)).magnitude

		if not p1.props.renderLeft or not p1.props.renderRight then
			return UDim2.new(1, -v24, 1, 0)
		end

		return UDim2.new(0, magnitude * 2, 1, 0)
	end
	function p1.computeBumpedPosition(p3) -- line: 78
		local v27 = p3[1]
		local v28 = p3[2]
		local v29 = (p3[3] - v27 - v28) / 2

		return UDim2.new(0, v27 + v29, 0.5, 0)
	end
	function p1.computeBumpedSize(p4) -- line: 86
		local v31 = p4[1]
		local v32 = p4[2]

		return UDim2.new(1, -v31 - v32, 1, 0)
	end
end
function v8.didUpdate(p5) -- line: 93
	if not p5.props.renderLeft then
		p5.updateLeftWidth(0)
	end

	if not p5.props.renderRight then
		p5.updateRightWidth(0)
	end
end
function v8.render(p6) -- line: 104
	-- upvalues: Roact (copy), FitFrame (copy), Cryo (copy)
	local vector2 = Vector2.new(0.5, 0.5)
	local u19 = if p6.props.renderLeft or not p6.props.renderRight then if not p6.props.renderLeft or p6.props.renderRight then UDim2.fromScale(0.5, 0.5) else UDim2.fromScale(1, 0.5) else UDim2.fromScale(0, 0.5)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, p6.props.barHeight),
		BackgroundColor3 = p6.props.BackgroundColor3,
		BackgroundTransparency = p6.props.BackgroundTransparency,
		BorderSizePixel = 0,
		AutomaticSize = if not p6.props.automaticHeight then nil else Enum.AutomaticSize.Y,
		[Roact.Change.AbsoluteSize] = function(p7) -- line: 123
			-- upvalues: p6 (copy)
			p6.props.onWidthChange(p7.AbsoluteSize.X)
			p6.updateFullWidth(p7.AbsoluteSize.X)
		end
	}, {
		leftFrame = p6.props.renderLeft and Roact.createElement(FitFrame.FitFrameHorizontal, {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			minimumSize = UDim.new(0, 200),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = p6.props.contentPaddingLeft,
			margin = {
				top = 0,
				bottom = 0,
				left = p6.props.marginLeft,
				right = p6.props.sectionSpacing
			},
			[Roact.Change.AbsoluteSize] = function(p8) -- line: 144
				-- upvalues: p6 (copy)
				p6.updateLeftWidth(p8.AbsoluteSize.X)
			end
		}, {
			leftContent = p6.props.renderLeft(Cryo.Dictionary.join(p6.props, {
				[Roact.Children] = {
					sizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Roact.joinBindings({
							p6.leftWidth,
							p6.rightWidth,
							p6.fullWidth
						}):map(function(p9) -- line: 153
							-- upvalues: p6 (copy)
							local _ = p9[1]
							local v37 = p9[2]
							local v38 = math.max(0, p9[3] - v37 - p6.props.marginLeft)

							return Vector2.new(v38, 1e999)
						end)
					})
				}
			}))
		}),
		centerFrame = p6.props.renderCenter and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = vector2,
			Position = Roact.joinBindings({
				p6.leftWidth,
				p6.rightWidth,
				p6.fullWidth
			}):map(function(p10) -- line: 169
				-- upvalues: p6 (copy), u19 (ref)
				if math.abs(p6.computeCenteredSize(p10).X.Offset) <= p6.props.estimatedCenterWidth then
					return p6.computeBumpedPosition(p10)
				end

				return u19
			end),
			Size = Roact.joinBindings({
				p6.leftWidth,
				p6.rightWidth,
				p6.fullWidth
			}):map(function(p11) -- line: 178
				-- upvalues: p6 (copy)
				local v41 = p6.computeCenteredSize(p11)

				if math.abs(v41.X.Offset) <= p6.props.estimatedCenterWidth then
					return p6.computeBumpedSize(p11)
				end

				return v41
			end)
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = p6.props.renderLeft and UDim.new(0, 0) or UDim.new(0, p6.props.marginLeft),
				PaddingRight = p6.props.renderRight and UDim.new(0, 0) or UDim.new(0, p6.props.marginRight)
			}),
			["$layout"] = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			centerContent = p6.props.renderCenter(p6.props)
		}),
		rightFrame = p6.props.renderRight and Roact.createElement(FitFrame.FitFrameHorizontal, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			minimumSize = UDim.new(0, 200),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = p6.props.contentPaddingRight,
			margin = {
				top = 0,
				bottom = 0,
				left = p6.props.sectionSpacing,
				right = p6.props.marginRight
			},
			[Roact.Change.AbsoluteSize] = function(p12) -- line: 216
				-- upvalues: p6 (copy)
				p6.updateRightWidth(p12.AbsoluteSize.X)
			end
		}, {
			rightContent = p6.props.renderRight(p6.props)
		})
	})
end

return v8
