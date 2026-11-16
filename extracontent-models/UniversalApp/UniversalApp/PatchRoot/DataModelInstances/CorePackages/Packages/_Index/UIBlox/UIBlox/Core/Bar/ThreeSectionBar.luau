local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent

local t = require(parent2.t)
local Cryo = require(parent2.Cryo)
local Roact = require(parent2.Roact)
local FitFrame = require(parent2.FitFrame)
local bindingValidator = require(parent.Utility.bindingValidator)

local extended = Roact.PureComponent:extend("ThreeSectionBar")
extended.validateProps = t.strictInterface({
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

extended.defaultProps = {
	barHeight = 32,
	BackgroundTransparency = 0,
	marginLeft = 0,
	marginRight = 0,
	contentPaddingLeft = UDim.new(0, 0),
	contentPaddingRight = UDim.new(0, 0),
	renderLeft = nil,
	renderRight = nil,
	renderCenter = nil,
	onWidthChange = function(): nil
		return nil
	end,
	estimatedCenterWidth = 1e999,
	automaticHeight = false,
	sectionSpacing = 8
}

function extended:init()
	local binding, updateLeftWidth = Roact.createBinding(0)
	self.leftWidth = binding
	self.updateLeftWidth = updateLeftWidth
	local binding2, updateRightWidth = Roact.createBinding(0)
	self.rightWidth = binding2
	self.updateRightWidth = updateRightWidth
	local binding3, updateFullWidth = Roact.createBinding(0)
	self.fullWidth = binding3
	self.updateFullWidth = updateFullWidth

	function self.computeCenteredSize(list)
		local item = list[1]
		local item2 = list[2]
		local item3 = list[3]

		local v = math.max(item, item2)

		local magnitude = (Vector2.new(item3 / 2, 0) - Vector2.new(v, 0)).magnitude

		if self.props.renderLeft and self.props.renderRight then
			return UDim2.new(0, magnitude * 2, 1, 0)
		end

		return UDim2.new(1, -v, 1, 0)
	end

	function self.computeBumpedPosition(list)
		local item = list[1]
		local item2 = list[2]
		local v = (list[3] - item - item2) / 2

		return UDim2.new(0, item + v, 0.5, 0)
	end

	function self.computeBumpedSize(list)
		local item = list[1]
		local item2 = list[2]

		return UDim2.new(1, -item - item2, 1, 0)
	end
end

function extended.didUpdate(data)
	if not data.props.renderLeft then
		data.updateLeftWidth(0)
	end

	if not data.props.renderRight then
		data.updateRightWidth(0)
	end
end

function extended.render(props)
	local vector2 = Vector2.new(0.5, 0.5)
	local udim

	if props.props.renderLeft or not props.props.renderRight then
		if props.props.renderLeft and not props.props.renderRight then
			udim = UDim2.fromScale(1, 0.5)
		else
			udim = UDim2.fromScale(0.5, 0.5)
		end
	else
		udim = UDim2.fromScale(0, 0.5)
	end

	local createElement = Roact.createElement
	local v = {}
	v.Size = UDim2.new(1, 0, 0, props.props.barHeight)
	v.BackgroundColor3 = props.props.BackgroundColor3
	v.BackgroundTransparency = props.props.BackgroundTransparency
	v.BorderSizePixel = 0
	local automaticSize

	if props.props.automaticHeight then
		automaticSize = Enum.AutomaticSize.Y
	end

	v.AutomaticSize = automaticSize

	v[Roact.Change.AbsoluteSize] = function(p)
		props.props.onWidthChange(p.AbsoluteSize.X)
		props.updateFullWidth(p.AbsoluteSize.X)
	end

	local leftFrame = props.props.renderLeft

	if leftFrame then
		leftFrame = Roact.createElement(FitFrame.FitFrameHorizontal, {
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.fromScale(0, 0),
			BackgroundTransparency = 1,
			minimumSize = UDim.new(0, 200),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = props.props.contentPaddingLeft,
			margin = {
				top = 0,
				left = props.props.marginLeft,
				right = props.props.sectionSpacing,
				bottom = 0
			},
			[Roact.Change.AbsoluteSize] = function(p)
				props.updateLeftWidth(p.AbsoluteSize.X)
			end
		}, {
			leftContent = props.props.renderLeft(Cryo.Dictionary.join(props.props, {
				[Roact.Children] = {
					sizeConstraint = Roact.createElement("UISizeConstraint", {
						MaxSize = Roact.joinBindings({ props.leftWidth, props.rightWidth, props.fullWidth }):map(function(list)
							local _ = list[1]
							local item = list[2]
							local v2 = math.max(0, list[3] - item - props.props.marginLeft)

							return Vector2.new(v2, 1e999)
						end)
					})
				}
			}))
		})
	end

	local v2 = {
		leftFrame = leftFrame,
		centerFrame = props.props.renderCenter and Roact.createElement("Frame", {
			AnchorPoint = vector2,
			BackgroundTransparency = 1,
			Position = Roact.joinBindings({ props.leftWidth, props.rightWidth, props.fullWidth }):map(function(p)
				if math.abs(props.computeCenteredSize(p).X.Offset) <= props.props.estimatedCenterWidth then
					return props.computeBumpedPosition(p)
				end

				return udim
			end),
			Size = Roact.joinBindings({ props.leftWidth, props.rightWidth, props.fullWidth }):map(function(p)
				local centeredSize = props.computeCenteredSize(p)

				if math.abs(centeredSize.X.Offset) <= props.props.estimatedCenterWidth then
					return props.computeBumpedSize(p)
				end

				return centeredSize
			end)
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = props.props.renderLeft and UDim.new(0, 0) or UDim.new(0, props.props.marginLeft),
				PaddingRight = props.props.renderRight and UDim.new(0, 0) or UDim.new(0, props.props.marginRight)
			}),
			["$layout"] = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			centerContent = props.props.renderCenter(props.props)
		}),
		rightFrame = 0
	}

	local rightFrame = props.props.renderRight

	if rightFrame then
		rightFrame = Roact.createElement(FitFrame.FitFrameHorizontal, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			minimumSize = UDim.new(0, 200),
			height = UDim.new(1, 0),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			contentPadding = props.props.contentPaddingRight,
			margin = {
				top = 0,
				left = props.props.sectionSpacing,
				right = props.props.marginRight,
				bottom = 0
			},
			[Roact.Change.AbsoluteSize] = function(p)
				props.updateRightWidth(p.AbsoluteSize.X)
			end
		}, {
			rightContent = props.props.renderRight(props.props)
		})
	end

	v2.rightFrame = rightFrame
	return createElement("Frame", v, v2)
end

return extended
