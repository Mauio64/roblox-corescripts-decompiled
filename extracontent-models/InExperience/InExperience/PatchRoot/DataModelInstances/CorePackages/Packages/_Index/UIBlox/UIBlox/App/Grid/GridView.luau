local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local RoactGamepad = require(ParentParentParent.RoactGamepad)
local isCallable = require(ParentParent.Utility.isCallable)
local UIBloxConfig = require(ParentParent.UIBloxConfig)
local Roact = require(ParentParentParent.Roact)
local Cryo = require(ParentParentParent.Cryo)
local t = require(ParentParentParent.t)
local isPositiveVector2 = require(ParentParent.Utility.isPositiveVector2)
local v10 = Roact.PureComponent:extend("GridView")

v10.validateProps = t.strictInterface({
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

function v10.itemsAreVisible(p1) -- line: 60
	return p1.state.isInDataModel and (p1.state.containerWidth ~= 0 and p1.props.itemSize.X ~= 0)
end

v10.defaultProps = {
	maxHeight = 1e999,
	restorePreviousChildFocus = true,
	isRoactGamepadEnabled = true
}

function v10.init(p2) -- line: 74
	-- upvalues: Roact (copy), RoactGamepad (copy)
	p2.currentItemsPerRow = -1
	p2.frameRef = Roact.createRef()
	p2.isMounted = false
	p2.state = {
		containerWidth = 0,
		containerYPosition = 0,
		isInDataModel = false
	}
	p2.focusableRefs = p2.props.isRoactGamepadEnabled and RoactGamepad.createRefCache() or {}

	function p2.onAncestryChanged(p3) -- line: 87
		-- upvalues: p2 (copy)
		if p3:IsDescendantOf(game) then
			p2:setState(function(p4) -- line: 89
				-- upvalues: p3 (copy)
				if not p4.isInDataModel or p4.containerWidth ~= p3.AbsoluteSize.X then
					return {
						isInDataModel = true,
						containerWidth = p3.AbsoluteSize.X
					}
				end

				return nil
			end)
		end
	end
end
function v10.render(p5) -- line: 102
	-- upvalues: Roact (copy), RoactGamepad (copy), UIBloxConfig (copy)
	local items = p5.props.items
	local v15 = #items
	local itemSize = p5.props.itemSize
	local itemPadding = p5.props.itemPadding
	local maxHeight = p5.props.maxHeight
	local containerWidth = p5.state.containerWidth
	local containerYPosition = p5.state.containerYPosition
	local defaultChildIndex = p5.props.defaultChildIndex
	local onNumItemsPerRowChanged = p5.props.onNumItemsPerRowChanged
	local n1 = 1
	local u24 = v15
	local t1 = {}
	local n2 = 0
	local n3 = 0
	local v28 = math.max(1, itemSize.X + itemPadding.X)
	local v29 = math.max(1, itemSize.Y + itemPadding.Y)
	local u30 = math.floor((containerWidth + itemPadding.X) / v28)
	local v31 = math.floor((maxHeight + itemPadding.Y) / v29)

	if u30 ~= p5.currentItemsPerRow then
		p5.currentItemsPerRow = u30

		if onNumItemsPerRowChanged then
			onNumItemsPerRowChanged(u30)
		end
	end

	local v32 = math.min(v31, (math.ceil(v15 / u30)))
	local v33 = v32 * itemSize.Y + math.max(v32 - 1, 0) * itemPadding.Y

	if p5.props.windowHeight ~= nil then
		local v34 = math.floor((p5.props.windowHeight + itemPadding.Y) / (itemSize.Y + itemPadding.Y)) + 2
		local v35 = math.floor((containerYPosition + itemPadding.Y) / (itemSize.Y + itemPadding.Y))
		local v36 = math.min(v32, v35 + v34) + 1

		n1 = math.max(1, v35 * u30 + 1)
		u24 = math.min(v15, v36 * u30)
		n3 = v35 * itemSize.Y + v35 * itemPadding.Y
	end

	local function getItemIndexRef(p6, p7) -- line: 152
		-- upvalues: u30 (ref), n1 (ref), u24 (ref), p5 (copy)
		local v50 = p6 > 0 and (p7 > 0 and p7 <= u30)
		local v51 = 1 + ((p6 - 1) * u30 + (p7 - 1))

		return v51 >= n1 and v51 <= u24 and (not not v50 and p5.focusableRefs[v51]) or nil
	end
	local function renderItem(p8) -- line: 161
		-- upvalues: u30 (ref), p5 (copy), Roact (copy), RoactGamepad (copy), n2 (ref), n3 (ref), itemSize (copy), n1 (ref), u24 (ref), items (copy), UIBloxConfig (copy)
		local v53 = math.floor((p8 - 1) / u30) + 1
		local v54 = 1 + (p8 - 1) % u30
		local v55 = p5:itemsAreVisible()

		if not p5.props.isRoactGamepadEnabled then
			p5.focusableRefs[p8] = p5.focusableRefs[p8] or Roact.createRef()
		end

		local createElement = Roact.createElement
		local v57 = not p5.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame
		local t2 = {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, n2, 0, n3),
			Size = UDim2.new(0, itemSize.X, 0, itemSize.Y)
		}
		local v59 = v54 - 1
		local v60 = v53 > 0 and (v59 > 0 and v59 <= u30)
		local v61 = 1 + ((v53 - 1) * u30 + (v59 - 1))

		t2.NextSelectionLeft = v61 >= n1 and v61 <= u24 and (not not v60 and p5.focusableRefs[v61]) or nil

		local v62 = v54 + 1
		local v63 = v53 > 0 and (v62 > 0 and v62 <= u30)
		local v64 = 1 + ((v53 - 1) * u30 + (v62 - 1))

		t2.NextSelectionRight = v64 >= n1 and v64 <= u24 and (not not v63 and p5.focusableRefs[v64]) or nil

		local v65 = v53 - 1
		local v66 = v65 > 0 and (v54 > 0 and v54 <= u30)
		local v67 = 1 + ((v65 - 1) * u30 + (v54 - 1))

		t2.NextSelectionUp = v67 >= n1 and v67 <= u24 and (not not v66 and p5.focusableRefs[v67]) or nil

		local v68 = v53 + 1
		local v69 = v68 > 0 and (v54 > 0 and v54 <= u30)
		local v70 = 1 + ((v68 - 1) * u30 + (v54 - 1))

		t2.NextSelectionDown = v70 >= n1 and v70 <= u24 and (not not v69 and p5.focusableRefs[v70]) or nil
		t2[Roact.Ref] = p5.focusableRefs[p8]
		t2.onFocusGained = if not p5.props.isRoactGamepadEnabled then nil else p5.props.onFocusGained

		return createElement(v57, t2, {
			Content = v55 and p5.props.renderItem(items[p8], p8, if not UIBloxConfig.passRowAndColumnDataToItemInGridView then nil else {
				row = v53,
				column = v54
			})
		})
	end

	if v33 < maxHeight then
		local v39 = false
		local v40 = defaultChildIndex and defaultChildIndex <= v15

		for i = n1, u24 do
			if i == defaultChildIndex then
				v39 = true
			end

			t1[tostring(i)] = renderItem(i)
			n2 = math.floor(n2 + itemSize.X + itemPadding.X)

			if containerWidth < n2 + itemSize.X and i < u24 then
				n2 = 0
				n3 = n3 + itemPadding.Y + itemSize.Y
			end
		end

		if v40 and not v39 then
			n2 = (defaultChildIndex - 1) % u30 * (itemSize.X + itemPadding.X)
			n3 = math.floor((defaultChildIndex - 1) / u30) * (itemPadding.Y + itemSize.Y)
			t1[tostring(defaultChildIndex)] = renderItem(defaultChildIndex)
		end
	end

	return Roact.createElement(not p5.props.isRoactGamepadEnabled and "Frame" or RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		LayoutOrder = p5.props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, v33),
		[Roact.Change.AbsolutePosition] = p5.props.windowHeight ~= nil and function(p9) -- line: 238
			-- upvalues: p5 (copy)
			if p5.isMounted then
				p5:setState({
					containerYPosition = -math.min(0, p9.AbsolutePosition.Y)
				})
			end
		end or nil,
		[Roact.Change.AbsoluteSize] = function(p10) -- line: 245
			-- upvalues: p5 (copy)
			if p5.isMounted then
				if p5.state.isInDataModel then
					p5:setState({
						containerWidth = p10.AbsoluteSize.X
					})
				end

				if p5.props.onWidthChanged ~= nil then
					p5.props.onWidthChanged(p10.AbsoluteSize.X)
				end
			end
		end,
		[Roact.Event.AncestryChanged] = p5.onAncestryChanged,
		[Roact.Ref] = p5.props.frameRef or p5.frameRef,
		NextSelectionLeft = p5.props.NextSelectionLeft,
		NextSelectionRight = p5.props.NextSelectionRight,
		NextSelectionUp = p5.props.NextSelectionUp,
		NextSelectionDown = p5.props.NextSelectionDown,
		defaultChild = if not p5.props.isRoactGamepadEnabled or not defaultChildIndex then nil else p5.focusableRefs[defaultChildIndex],
		restorePreviousChildFocus = if not p5.props.isRoactGamepadEnabled then nil else p5.props.restorePreviousChildFocus
	}, t1)
end
function v10.didMount(p11) -- line: 273
	p11.isMounted = true

	local v43 = p11.props.frameRef or p11.frameRef

	if v43:getValue() and v43:getValue().AbsoluteSize.X ~= 0 then
		if v43:getValue():IsDescendantOf(game) then
			p11:setState(function(_) -- line: 283
				-- upvalues: v43 (copy)
				if v43:getValue() then
					return {
						isInDataModel = true,
						containerWidth = v43:getValue().AbsoluteSize.X
					}
				end

				return nil
			end)
		end

		if p11.props.onWidthChanged ~= nil then
			delay(0, function() -- line: 296
				-- upvalues: v43 (copy), p11 (copy)
				if v43:getValue() then
					p11.props.onWidthChanged(v43:getValue().AbsoluteSize.X)
				end
			end)
		end
	end
end
function v10.willUnmount(p13) -- line: 305
	p13.isMounted = false
end

return Roact.forwardRef(function(p14, p15) -- line: 309
	-- upvalues: Roact (copy), v10 (copy), Cryo (copy)
	return Roact.createElement(v10, Cryo.Dictionary.join(p14, {
		frameRef = p15
	}))
end)
