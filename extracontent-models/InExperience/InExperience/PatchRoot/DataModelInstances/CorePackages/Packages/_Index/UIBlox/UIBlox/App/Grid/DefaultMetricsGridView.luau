local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local Roact = require(ParentParent.Roact)
local Cryo = require(ParentParent.Cryo)
local t = require(ParentParent.t)
local GridView = require(scriptParent.GridView)

local function validateWindowHeight(p1) -- line: 15
	if p1.windowHeight ~= nil and p1.windowHeight > p1.maxHeight then
		return false, ("windowHeight must be less than or equal to maxHeight\nmaxHeight: %f\nwindowHeight: %f"):format(p1.maxHeight, p1.windowHeight)
	end

	return true
end

local v8 = Roact.PureComponent:extend("DefaultMetricsGridView")

v8.validateProps = t.strictInterface({
	getItemHeight = t.callback,
	getItemMetrics = t.callback,
	windowHeight = t.optional(t.numberMin(0)),
	renderItem = t.callback,
	itemPadding = t.Vector2,
	items = t.table,
	maxHeight = t.numberMin(0),
	LayoutOrder = t.optional(t.integer),
	onNumItemsPerRowChanged = t.optional(t.callback),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	frameRef = t.optional(t.table),
	restorePreviousChildFocus = t.optional(t.boolean),
	onFocusGained = t.optional(t.callback),
	defaultChildIndex = t.optional(t.numberMin(1)),
	isRoactGamepadEnabled = t.optional(t.boolean)
})
v8.defaultProps = {
	maxHeight = 1e999,
	isRoactGamepadEnabled = true
}

function v8.init(p2) -- line: 75
	-- upvalues: Roact (copy)
	p2.isMounted = false
	p2.state = {
		containerWidth = 0
	}
	p2.initialSizeCheckerRef = Roact.createRef()
end
function v8.render(p3) -- line: 85
	-- upvalues: validateWindowHeight (copy), Roact (copy), GridView (copy)
	assert(validateWindowHeight(p3.props))

	local v12 = p3.props.getItemMetrics(p3.state.containerWidth, p3.props.itemPadding.X)
	local v13 = p3.props.getItemHeight(v12.itemWidth)
	local vector2 = Vector2.new(math.max(0, v12.itemWidth), (math.max(0, v13)))

	return Roact.createElement(GridView, {
		renderItem = p3.props.renderItem,
		windowHeight = p3.props.windowHeight,
		maxHeight = p3.props.maxHeight,
		itemSize = vector2,
		itemPadding = p3.props.itemPadding,
		items = p3.props.items,
		LayoutOrder = p3.props.LayoutOrder,
		onNumItemsPerRowChanged = p3.props.onNumItemsPerRowChanged,
		NextSelectionLeft = p3.props.NextSelectionLeft,
		NextSelectionRight = p3.props.NextSelectionRight,
		NextSelectionUp = p3.props.NextSelectionUp,
		NextSelectionDown = p3.props.NextSelectionDown,
		[Roact.Ref] = p3.props.frameRef,
		defaultChildIndex = if not p3.props.isRoactGamepadEnabled then nil else p3.props.defaultChildIndex,
		restorePreviousChildFocus = if not p3.props.isRoactGamepadEnabled then nil else p3.props.restorePreviousChildFocus,
		onFocusGained = if not p3.props.isRoactGamepadEnabled then nil else p3.props.onFocusGained,
		isRoactGamepadEnabled = p3.props.isRoactGamepadEnabled,
		onWidthChanged = function(p4) -- line: 117
			-- upvalues: p3 (copy)
			if p3.isMounted then
				p3:setState({
					containerWidth = p4
				})
			end
		end
	})
end
function v8.didMount(p5) -- line: 127
	p5.isMounted = true
end
function v8.willUnmount(p6) -- line: 131
	p6.isMounted = false
end

return Roact.forwardRef(function(p7, p8) -- line: 135
	-- upvalues: Roact (copy), v8 (copy), Cryo (copy)
	return Roact.createElement(v8, Cryo.Dictionary.join(p7, {
		frameRef = p8
	}))
end)
