local parent = script.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Roact = require(parent2.Roact)
local isRoact17 = require(parent.isRoact17)

local Rect = require(parent.Rect)

local axis = { Horizontal = {}, Vertical = {}, Both = {} }

local extended = Roact.PureComponent:extend("FitFrameOnAxis")

extended.defaultProps = {
	axis = axis.Vertical,
	minimumSize = UDim2.new(UDim.new(0, 0), UDim.new(0, 0)),
	margin = Rect.square(0),
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	ImageSet = {},
	VerticalAlignment = Enum.VerticalAlignment.Top,
	contentPadding = UDim.new(0, 0),
	textProps = nil
}

function extended:init()
	self.layoutRef = Roact.createRef()

	if isRoact17() then
		self.frameRef = self.props.forwardedRef or Roact.createRef()
	else
		self.frameRef = self.props[Roact.Ref] or Roact.createRef()
	end

	function self.onResize()
		local current = self.layoutRef.current
		local current2 = self.frameRef.current

		if current2 and current then
			current2.Size = self:__getSize(current)
		end
	end
end

function extended:render()
	assert(self.props.Size == nil, "Size is not a valid property of FitFrameOnAxis. Did you mean `minimumSize`?")
	local v = self.props[Roact.Children] or {}
	local __getFilteredProps = self:__getFilteredProps()

	local v2 = self.props.onActivated and "ImageButton" or "ImageLabel"

	local v3 = Cryo.Dictionary.join(v, {
		["$layout"] = Roact.createElement("UIListLayout", {
			FillDirection = self.props.FillDirection,
			HorizontalAlignment = self.props.HorizontalAlignment,
			Padding = self.props.contentPadding,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = self.props.VerticalAlignment,
			[Roact.Change.AbsoluteContentSize] = self.onResize,
			[Roact.Ref] = self.layoutRef
		}),
		["$margin"] = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, self.props.margin.left),
			PaddingRight = UDim.new(0, self.props.margin.right),
			PaddingTop = UDim.new(0, self.props.margin.top),
			PaddingBottom = UDim.new(0, self.props.margin.bottom)
		})
	})

	if self.props.textProps then
		return Roact.createElement(v2, __getFilteredProps, {
			TextLabel = Roact.createElement(
				"TextLabel",
				Cryo.Dictionary.join(self.props.textProps, {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1)
				})
			),
			ChildFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, v3)
		})
	end

	return Roact.createElement(v2, __getFilteredProps, v3)
end

function extended.didMount(p)
	p.onResize()
end

function extended.didUpdate(p)
	p.onResize()
end

function extended:__getFilteredProps()
	local nones = Cryo.Dictionary.join(self.props.ImageSet, {
		[Roact.Ref] = self.frameRef,
		[Roact.Event.Activated] = self.props.onActivated
	})

	for k, _ in pairs(extended.defaultProps) do
		nones[k] = Cryo.None
	end

	nones.textProps = Cryo.None

	return Cryo.Dictionary.join(self.props, nones, {
		onActivated = Cryo.None,
		forwardedRef = Cryo.None,
		[Roact.Children] = Cryo.None
	})
end

function extended:__getSize(p)
	if self.props.axis == axis.Both then
		return self:__getBothAxisSize(p)
	end

	local __getAxisUDim = self:__getAxisUDim(p.AbsoluteContentSize)
	local __getOtherUDim = self:__getOtherUDim()

	if self.props.axis == axis.Vertical then
		return UDim2.new(__getOtherUDim, __getAxisUDim)
	end

	if self.props.axis == axis.Horizontal then
		return UDim2.new(__getAxisUDim, __getOtherUDim)
	end
end

function extended:__getBothAxisSize(p)
	local minimumSize = self.props.minimumSize
	local absoluteContentSize = p.AbsoluteContentSize

	local udim = UDim.new(minimumSize.X.Scale, absoluteContentSize.X + self:__getHorizontalMargin())
	local udim2 = UDim.new(minimumSize.Y.Scale, absoluteContentSize.Y + self:__getVerticalMargin())

	return UDim2.new(udim, udim2)
end

function extended:__getAxisUDim(p)
	local minimumSize = self.props.minimumSize

	local v = nil
	local v2 = nil

	if self.props.axis == axis.Vertical then
		v = minimumSize.Y
		v2 = p.Y + self:__getVerticalMargin()
	elseif self.props.axis == axis.Horizontal then
		v = minimumSize.X
		v2 = p.X + self:__getHorizontalMargin()
	end

	return UDim.new(v.Scale, (math.max(v2, v.Offset)))
end

function extended:__getVerticalMargin()
	return self.props.margin.top + self.props.margin.bottom
end

function extended:__getHorizontalMargin()
	return self.props.margin.left + self.props.margin.right
end

function extended:__getOtherUDim()
	local minimumSize = self.props.minimumSize

	if self.props.axis == axis.Vertical then
		return minimumSize.X
	end

	if self.props.axis == axis.Horizontal then
		return minimumSize.Y
	end
end

local selected

if isRoact17() then
	selected = Roact.forwardRef(function(p, forwardedRef)
		return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardedRef = forwardedRef }))
	end)
else
	selected = extended
end

selected.Axis = axis

return selected
