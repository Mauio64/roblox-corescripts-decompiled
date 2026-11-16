local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local RoactGamepad = require(parent2.RoactGamepad)
local isCallable = require(parent.Utility.isCallable)
local UIBloxConfig = require(parent.UIBloxConfig)

local Roact = require(parent2.Roact)
local Cryo = require(parent2.Cryo)
local t = require(parent2.t)

local isPositiveVector2 = require(parent.Utility.isPositiveVector2)

local extended = Roact.PureComponent:extend("GridView")

extended.validateProps = t.strictInterface({
	renderItem = isCallable,
	itemSize = isPositiveVector2,
	itemPadding = t.Vector2,
	items = t.table,
	maxHeight = t.numberMin(0),
	windowHeight = t.optional(t.numberMin(0)),
	LayoutOrder = t.optional(t.integer),
	onWidthChanged = t.optional(isCallable),
	onNumItemsPerRowChanged = t.optional(isCallable),
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

function extended:itemsAreVisible()
	local isInDataModel = self.state.isInDataModel

	if isInDataModel then
		if self.state.containerWidth == 0 then
			return false
		end

		return self.props.itemSize.X ~= 0
	end

	return isInDataModel
end

extended.defaultProps = {
	maxHeight = 1e999,
	restorePreviousChildFocus = true,
	isRoactGamepadEnabled = true
}

function extended:init()
	self.currentItemsPerRow = -1
	self.frameRef = Roact.createRef()
	self.isMounted = false

	self.state = { containerWidth = 0, containerYPosition = 0, isInDataModel = false }

	self.focusableRefs = self.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}

	function self.onAncestryChanged(instance)
		if instance:IsDescendantOf(game) then
			self:setState(function(p)
				if p.isInDataModel and p.containerWidth == instance.AbsoluteSize.X then
					return nil
				end

				return { isInDataModel = true, containerWidth = instance.AbsoluteSize.X }
			end)
		end
	end
end

function extended:render()
	local items = self.props.items
	local count = #items

	local itemSize = self.props.itemSize
	local itemPadding = self.props.itemPadding
	local maxHeight = self.props.maxHeight
	local containerWidth = self.state.containerWidth
	local containerYPosition = self.state.containerYPosition
	local defaultChildIndex = self.props.defaultChildIndex
	local onNumItemsPerRowChanged = self.props.onNumItemsPerRowChanged
	local v = 1
	local v2 = count
	local v3 = {}
	local v4 = 0
	local v5 = 0

	local v6 = math.max(1, itemSize.X + itemPadding.X)
	local v7 = math.max(1, itemSize.Y + itemPadding.Y)
	local currentItemsPerRow = math.floor((containerWidth + itemPadding.X) / v6)
	local v8 = math.floor((maxHeight + itemPadding.Y) / v7)

	if currentItemsPerRow ~= self.currentItemsPerRow then
		self.currentItemsPerRow = currentItemsPerRow

		if onNumItemsPerRowChanged then
			onNumItemsPerRowChanged(currentItemsPerRow)
		end
	end

	local v9 = math.min(v8, (math.ceil(count / currentItemsPerRow)))
	local v10 = v9 * itemSize.Y + math.max(v9 - 1, 0) * itemPadding.Y

	if self.props.windowHeight ~= nil then
		local v11 = math.floor((self.props.windowHeight + itemPadding.Y) / (itemSize.Y + itemPadding.Y)) + 2

		local v12 = math.floor((containerYPosition + itemPadding.Y) / (itemSize.Y + itemPadding.Y))

		local v13 = math.min(v9, v12 + v11) + 1

		v = math.max(1, v12 * currentItemsPerRow + 1)
		v2 = math.min(count, v13 * currentItemsPerRow)

		v5 = v12 * itemSize.Y + v12 * itemPadding.Y
	end

	local function getItemIndexRef(p, p2) -- 4 equivalent calls inferred from this helper
		local v11

		if p > 0 and p2 > 0 then
			v11 = p2 <= currentItemsPerRow
		else
			v11 = false
		end

		local v12 = 1 + ((p - 1) * currentItemsPerRow + (p2 - 1))
		return v <= v12 and v12 <= v2 and v11 and self.focusableRefs[v12] or nil
	end

	local function renderItem(p)
		local row = math.floor((p - 1) / currentItemsPerRow) + 1
		local column = 1 + (p - 1) % currentItemsPerRow

		local itemsAreVisible = self:itemsAreVisible()

		if not self.props.isRoactGamepadEnabled then
			self.focusableRefs[p] = self.focusableRefs[p] or Roact.createRef()
		end

		local createElement = Roact.createElement
		local v11 = not self.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
		local v12 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, v4, 0, v5),
			Size = UDim2.new(0, itemSize.X, 0, itemSize.Y),
			NextSelectionLeft = getItemIndexRef(row, column - 1), -- inferred equivalent call
			NextSelectionRight = getItemIndexRef(row, column + 1), -- inferred equivalent call
			NextSelectionUp = getItemIndexRef(row - 1, column), -- inferred equivalent call
			NextSelectionDown = getItemIndexRef(row + 1, column), -- inferred equivalent call
			[Roact.Ref] = self.focusableRefs[p]
		}
		local onFocusGained

		if self.props.isRoactGamepadEnabled then
			onFocusGained = self.props.onFocusGained
		end

		v12.onFocusGained = onFocusGained
		return createElement(v11, v12, {
			Content = itemsAreVisible and self.props.renderItem(
				items[p],
				p,
				UIBloxConfig.passRowAndColumnDataToItemInGridView and { row = row, column = column } or nil
			)
		})
	end

	if v10 < maxHeight then
		local v11 = defaultChildIndex and defaultChildIndex <= count
		local v12 = false

		for i = v, v2 do
			v12 = i == defaultChildIndex or v12

			v3[tostring(i)] = renderItem(i)

			v4 = math.floor(v4 + itemSize.X + itemPadding.X)

			if not (containerWidth < v4 + itemSize.X and i < v2) then
				continue
			end

			v4 = 0
			v5 = v5 + itemPadding.Y + itemSize.Y
		end

		if v11 and not v12 then
			v4 = (defaultChildIndex - 1) % currentItemsPerRow * (itemSize.X + itemPadding.X)
			v5 = math.floor((defaultChildIndex - 1) / currentItemsPerRow) * (itemPadding.Y + itemSize.Y)
			v3[tostring(defaultChildIndex)] = renderItem(defaultChildIndex)
		end
	end

	local createElement = Roact.createElement
	local v11 = not self.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
	local v12 = {}
	v12.BackgroundTransparency = 1
	v12.LayoutOrder = self.props.LayoutOrder
	v12.Size = UDim2.new(1, 0, 0, v10)
	local absolutePosition = Roact.Change.AbsolutePosition
	local v13

	if self.props.windowHeight ~= nil then
		v13 = function(p)
			if self.isMounted then
				self:setState({
					containerYPosition = -math.min(0, p.AbsolutePosition.Y)
				})
			end
		end or nil
	end

	v12[absolutePosition] = v13

	v12[Roact.Change.AbsoluteSize] = function(p)
		if self.isMounted then
			if self.state.isInDataModel then
				self:setState({ containerWidth = p.AbsoluteSize.X })
			end

			if self.props.onWidthChanged ~= nil then
				self.props.onWidthChanged(p.AbsoluteSize.X)
			end
		end
	end
	v12[Roact.Event.AncestryChanged] = self.onAncestryChanged
	v12[Roact.Ref] = self.props.frameRef or self.frameRef
	v12.NextSelectionLeft = self.props.NextSelectionLeft
	v12.NextSelectionRight = self.props.NextSelectionRight
	v12.NextSelectionUp = self.props.NextSelectionUp
	v12.NextSelectionDown = self.props.NextSelectionDown
	local defaultChild

	if self.props.isRoactGamepadEnabled and defaultChildIndex then
		defaultChild = self.focusableRefs[defaultChildIndex]
	end

	v12.defaultChild = defaultChild
	local restorePreviousChildFocus

	if self.props.isRoactGamepadEnabled then
		restorePreviousChildFocus = self.props.restorePreviousChildFocus
	end

	v12.restorePreviousChildFocus = restorePreviousChildFocus
	return createElement(v11, v12, v3)
end

function extended:didMount()
	self.isMounted = true

	local frameRef = self.props.frameRef or self.frameRef

	if frameRef:getValue() and frameRef:getValue().AbsoluteSize.X ~= 0 then
		if frameRef:getValue():IsDescendantOf(game) then
			self:setState(function(_)
				if frameRef:getValue() then
					return {
						isInDataModel = true,
						containerWidth = frameRef:getValue().AbsoluteSize.X
					}
				end

				return nil
			end)
		end

		if self.props.onWidthChanged ~= nil then
			delay(0, function()
				if frameRef:getValue() then
					self.props.onWidthChanged(frameRef:getValue().AbsoluteSize.X)
				end
			end)
		end
	end
end

function extended:willUnmount()
	self.isMounted = false
end

return Roact.forwardRef(function(p, frameRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { frameRef = frameRef }))
end)
