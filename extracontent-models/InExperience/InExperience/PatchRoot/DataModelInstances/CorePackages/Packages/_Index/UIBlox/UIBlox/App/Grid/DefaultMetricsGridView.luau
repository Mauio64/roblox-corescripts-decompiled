local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)

local GridView = require(parent.GridView)

local function validateWindowHeight(props)
	if props.windowHeight == nil or not (props.windowHeight > props.maxHeight) then
		return true
	end

	return
		false,
		("windowHeight must be less than or equal to maxHeight\nmaxHeight: %f\nwindowHeight: %f"):format(
			props.maxHeight,
			props.windowHeight
		)
end

local extended = Roact.PureComponent:extend("DefaultMetricsGridView")

extended.validateProps = t.strictInterface({
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

extended.defaultProps = { maxHeight = 1e999, isRoactGamepadEnabled = true }

function extended:init()
	self.isMounted = false

	self.state = { containerWidth = 0 }

	self.initialSizeCheckerRef = Roact.createRef()
end

function extended.render(props)
	assert(validateWindowHeight(props.props))

	local itemMetrics = props.props.getItemMetrics(props.state.containerWidth, props.props.itemPadding.X)
	local itemHeight = props.props.getItemHeight(itemMetrics.itemWidth)

	local vector2 = Vector2.new(math.max(0, itemMetrics.itemWidth), (math.max(0, itemHeight)))

	local createElement = Roact.createElement
	local frameRefsByRef = {
		["renderItem"] = nil,
		["renderItem"] = nil,
		["renderItem"] = nil,
		["renderItem"] = nil,
		renderItem = props.props.renderItem,
		windowHeight = props.props.windowHeight,
		maxHeight = props.props.maxHeight,
		itemSize = vector2,
		itemPadding = props.props.itemPadding,
		items = props.props.items,
		LayoutOrder = props.props.LayoutOrder,
		onNumItemsPerRowChanged = props.props.onNumItemsPerRowChanged,
		NextSelectionLeft = props.props.NextSelectionLeft,
		NextSelectionRight = props.props.NextSelectionRight,
		NextSelectionUp = props.props.NextSelectionUp,
		NextSelectionDown = props.props.NextSelectionDown,
		[Roact.Ref] = props.props.frameRef
	}
	local defaultChildIndex

	if props.props.isRoactGamepadEnabled then
		defaultChildIndex = props.props.defaultChildIndex
	end

	frameRefsByRef.defaultChildIndex = defaultChildIndex
	local restorePreviousChildFocus

	if props.props.isRoactGamepadEnabled then
		restorePreviousChildFocus = props.props.restorePreviousChildFocus
	end

	frameRefsByRef.restorePreviousChildFocus = restorePreviousChildFocus
	local onFocusGained

	if props.props.isRoactGamepadEnabled then
		onFocusGained = props.props.onFocusGained
	end

	frameRefsByRef.onFocusGained = onFocusGained
	frameRefsByRef.isRoactGamepadEnabled = props.props.isRoactGamepadEnabled

	function frameRefsByRef.onWidthChanged(containerWidth)
		if props.isMounted then
			props:setState({ containerWidth = containerWidth })
		end
	end

	return createElement(GridView, frameRefsByRef)
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

return Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
