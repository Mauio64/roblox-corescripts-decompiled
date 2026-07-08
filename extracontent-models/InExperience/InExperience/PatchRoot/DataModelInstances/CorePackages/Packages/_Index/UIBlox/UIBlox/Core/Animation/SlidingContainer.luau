local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParent.Parent.t)
local SlidingDirection = require(scriptParent.Enum.SlidingDirection)
local SpringAnimatedItem = require(ParentParent.Utility.SpringAnimatedItem)
local t1 = {
	dampingRatio = 1,
	frequency = 4
}
local v9 = Roact.PureComponent:extend("SlidingContainer")
local t2 = {
	[SlidingDirection.Up] = UDim2.new(0, 0, 1, 0),
	[SlidingDirection.Down] = UDim2.new(0, 0, -1, 0),
	[SlidingDirection.Left] = UDim2.new(1, 0, 0, 0),
	[SlidingDirection.Right] = UDim2.new(-1, 0, 0, 0)
}

v9.validateProps = t.strictInterface({
	layoutOrder = t.optional(t.integer),
	onComplete = t.optional(t.callback),
	show = t.optional(t.boolean),
	slidingDirection = SlidingDirection.isEnumValue,
	springOptions = t.optional(t.table),
	[Roact.Children] = t.optional(t.table)
})
v9.defaultProps = {
	springOptions = t1
}

function v9.render(p1) -- line: 45
	-- upvalues: Roact (copy), SpringAnimatedItem (copy), t2 (copy)
	local show = p1.props.show
	local slidingDirection = p1.props.slidingDirection

	return Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
		springOptions = p1.props.springOptions,
		animatedValues = {
			step = not show and 1 or 0
		},
		mapValuesToProps = function(p2) -- line: 54
			-- upvalues: t2 (copy), slidingDirection (copy)
			local v15 = t2[slidingDirection]

			return {
				Position = UDim2.new(v15.X.Scale * p2.step, 0, v15.Y.Scale * p2.step, 0)
			}
		end,
		regularProps = {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			Position = show and t2[slidingDirection] or UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0)
		},
		onComplete = p1.props.onComplete,
		[Roact.Children] = p1.props[Roact.Children]
	})
end

return v9
