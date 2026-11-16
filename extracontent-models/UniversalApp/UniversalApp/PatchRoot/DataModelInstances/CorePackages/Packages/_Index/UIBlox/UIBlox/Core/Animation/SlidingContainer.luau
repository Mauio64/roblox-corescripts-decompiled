local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent
local Roact = require(parent3.Roact)
local t = require(parent2.Parent.t)
local SlidingDirection = require(parent.Enum.SlidingDirection)
local SpringAnimatedItem = require(parent2.Utility.SpringAnimatedItem)

local extended = Roact.PureComponent:extend("SlidingContainer")

local udims = {
	[SlidingDirection.Up] = UDim2.new(0, 0, 1, 0),
	[SlidingDirection.Down] = UDim2.new(0, 0, -1, 0),
	[SlidingDirection.Left] = UDim2.new(1, 0, 0, 0),
	[SlidingDirection.Right] = UDim2.new(-1, 0, 0, 0)
}

extended.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	onComplete = t.optional(t.callback),
	show = t.optional(t.boolean),
	slidingDirection = SlidingDirection.isEnumValue,
	springOptions = t.optional(t.table),
	[Roact.Children] = t.optional(t.table)
})
extended.defaultProps = {
	springOptions = { dampingRatio = 1, frequency = 4 }
}

function extended.render(p)
	local show = p.props.show
	local slidingDirection = p.props.slidingDirection

	return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
		springOptions = p.props.springOptions,
		animatedValues = {
			step = show and 0 or 1
		},
		mapValuesToProps = function(p2)
			local v = udims[slidingDirection]
			return {
				Position = UDim2.new(v.X.Scale * p2.step, 0, v.Y.Scale * p2.step, 0)
			}
		end,
		regularProps = {
			BackgroundTransparency = 1,
			LayoutOrder = p.props.layoutOrder,
			Position = show and udims[slidingDirection] or UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		},
		onComplete = p.props.onComplete,
		[Roact.Children] = p.props[Roact.Children]
	})
end

return extended
