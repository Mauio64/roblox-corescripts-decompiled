local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local t1 = {
	OS = "roblox"
}
local deepDiffer = require(ParentParent.Utilities.differ.deepDiffer)
local React = require(ParentParentParent.React)
local VirtualizedList = require(ParentParent.Lists.VirtualizedList)
local View = require(ParentParent.Components.View.View)
local StyleSheet = require(ParentParent.StyleSheet.StyleSheet)
local invariant = require(ParentParent.jsUtils.invariant)
local ScrollView = ParentParent.Components.ScrollView

require(ScrollView.ScrollView)
require(ScrollView.ScrollViewNativeComponent)
require(ParentParent.Lists.ViewabilityHelper)
require(ParentParent.Lists.VirtualizedList)

local keyExtractor = require(script.Parent.VirtualizeUtils).keyExtractor

local function removeClippedSubviewsOrDefault(b1: boolean?) -- line: 188
	if b1 ~= nil then
		return b1
	end

	return false
end
local function numColumnsOrDefault(n1: number?) -- line: 193
	if n1 ~= nil then
		return n1
	end

	return 1
end

local v17 = React.PureComponent:extend("FlatList")

function v17.init(p1, _) -- line: 382
	-- upvalues: keyExtractor (copy), Array (copy), invariant (copy), React (copy), View (copy), StyleSheet (copy), Object (copy)
	p1._virtualizedListPairs = {}

	function p1._captureRef(p3) -- line: 384
		-- upvalues: p1 (copy)
		p1._listRef = p3
	end
	function p1._getItem(p4, n2: number) -- line: 388
		-- upvalues: p1 (copy)
		local numColumns = p1.props.numColumns
		local v67 = numColumns == nil and 1 or numColumns

		if v67 > 1 then
			local t2 = {}

			for i = 1, v67 do
				local v70 = p4[(n2 - 1) * v67 + i]

				if v70 ~= nil then
					table.insert(t2, v70)
				end
			end

			return t2
		end

		return p4[n2]
	end
	function p1._getItemCount(p5) -- line: 404
		-- upvalues: p1 (copy)
		if p5 ~= nil then
			local numColumns = p1.props.numColumns
			local v73 = numColumns == nil and 1 or numColumns

			if v73 > 1 then
				return (math.ceil(#p5 / v73))
			end

			return #p5
		end

		return 0
	end
	function p1._keyExtractor(p6, n3: number) -- line: 414
		-- upvalues: p1 (copy), keyExtractor (copy), Array (copy), invariant (copy)
		local numColumns = p1.props.numColumns
		local v77 = numColumns == nil and 1 or numColumns
		local v78 = if p1.props.keyExtractor == nil then keyExtractor else p1.props.keyExtractor

		if v77 > 1 then
			if Array.isArray(p6) then
				return Array.join(Array.map(p6, function(p7, p8) -- line: 421
					-- upvalues: v78 (copy), n3 (copy), v77 (copy)
					return v78(p7, (n3 - 1) * v77 + p8)
				end), ":")
			end

			invariant(Array.isArray(p6), "FlatList: Encountered internal consistency error, expected each item to consist of an array with 1-%s columns; instead, received a single item.", v77)

			return nil
		end

		return v78(p6, n3)
	end
	function p1._renderer() -- line: 445
		-- upvalues: p1 (copy), React (copy), invariant (copy), Array (copy), View (copy), StyleSheet (copy), Object (copy)
		local ListItemComponent = p1.props.ListItemComponent
		local renderItem = p1.props.renderItem
		local columnWrapperStyle = p1.props.columnWrapperStyle
		local numColumns = p1.props.numColumns
		local v83 = numColumns == nil and 1 or numColumns

		local function renderer(p9) -- line: 451
			-- upvalues: ListItemComponent (copy), React (copy), renderItem (copy)
			if ListItemComponent then
				return React.createElement(ListItemComponent, p9)
			end

			if renderItem then
				return renderItem(p9)
			end

			return nil
		end

		return {
			[not ListItemComponent and "renderItem" or "ListItemComponent"] = function(p10) -- line: 468
				-- upvalues: v83 (copy), React (copy), p1 (copy), invariant (copy), Array (copy), View (copy), StyleSheet (copy), columnWrapperStyle (copy), Object (copy), ListItemComponent (copy), renderItem (copy), renderer (copy)
				if v83 > 1 then
					local v98 = React.createElement("UIListLayout", {
						key = not p1.props.horizontal and "UIListHorizontalLayout" or "UIListVerticalLayout",
						Name = not p1.props.horizontal and "UIListHorizontalLayout" or "UIListVerticalLayout",
						FillDirection = if not p1.props.horizontal then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
					local item = p10.item
					local index = p10.index

					invariant(Array.isArray(item), "Expected array of items with numColumns > 1")

					return React.createElement(View, {
						style = StyleSheet.compose(columnWrapperStyle)
					}, Array.concat({ v98 }, Array.map(item, function(p11, p12) -- line: 491
						-- upvalues: Object (copy), index (copy), v83 (copy), p10 (copy), ListItemComponent (copy), React (copy), renderItem (copy)
						local t3 = {
							item = Object.assign({}, p11, {
								LayoutOrder = p12
							}),
							index = (index - 1) * v83 + p12,
							separators = p10.separators
						}
						local v106 = if not ListItemComponent then if not renderItem then nil else renderItem(t3) else React.createElement(ListItemComponent, t3)

						if v106 ~= nil then
							return (React.createElement(React.Fragment, {
								key = p12
							}, v106))
						end

						return nil
					end)))
				end

				return renderer(p10)
			end
		}
	end

	p1:_checkProps(p1.props)

	if p1.props.viewabilityConfigCallbackPairs then
		p1._virtualizedListPairs = Array.map(p1.props.viewabilityConfigCallbackPairs, function(p13) -- line: 512
			-- upvalues: p1 (copy)
			return {
				viewabilityConfig = p13.viewabilityConfig,
				onViewableItemsChanged = p1:_createOnViewableItemsChanged(p13.onViewableItemsChanged)
			}
		end)

		return
	end

	if p1.props.onViewableItemsChanged then
		table.insert(p1._virtualizedListPairs, {
			viewabilityConfig = p1.props.viewabilityConfig,
			onViewableItemsChanged = p1:_createOnViewableItemsChanged(p1.props.onViewableItemsChanged)
		})
	end
end
function v17.scrollToEnd(t4: {[any]: any}, t5: {[any]: any}?) -- line: 530
	if t4._listRef then
		t4._listRef:scrollToEnd(t5)
	end
end
function v17.scrollToIndex(t6: {[any]: any}, t7: {[any]: any}) -- line: 546
	if t6._listRef then
		t6._listRef:scrollToIndex(t7)
	end
end
function v17.scrollToItem(t8: {[any]: any}, t9: {[any]: any}) -- line: 565
	if t8._listRef then
		t8._listRef:scrollToItem(t9)
	end
end
function v17.scrollToOffset(t10: {[any]: any}, t11: {[any]: any}) -- line: 580
	if t10._listRef then
		t10._listRef:scrollToOffset(t11)
	end
end
function v17.recordInteraction(p14) -- line: 594
	if p14._listRef then
		p14._listRef:recordInteraction()
	end
end
function v17.flashScrollIndicators(p15) -- line: 605
	if p15._listRef then
		p15._listRef:flashScrollIndicators()
	end
end
function v17.getScrollResponder(p16) -- line: 614
	if p16._listRef then
		return p16._listRef:getScrollResponder()
	end
end
function v17.getNativeScrollRef(p17) -- line: 623
	if p17._listRef then
		return p17._listRef:getScrollRef()
	end
end
function v17.getScrollableNode(p18) -- line: 630
	if p18._listRef then
		return p18._listRef:getScrollableNode()
	end
end
function v17.setNativeProps(t12: {[any]: any}, t13: {[any]: any}) -- line: 635
	if t12._listRef then
		t12._listRef:setNativeProps(t13)
	end
end
function v17.componentDidUpdate(p19, p20) -- line: 642
	-- upvalues: invariant (copy), deepDiffer (copy)
	invariant(p20.numColumns == p19.props.numColumns, "Changing numColumns on the fly is not supported. Change the key prop on FlatList when changing the number of columns to force a fresh render of the component.")
	invariant(p20.onViewableItemsChanged == p19.props.onViewableItemsChanged, "Changing onViewableItemsChanged on the fly is not supported")
	invariant(not deepDiffer(p20.viewabilityConfig, p19.props.viewabilityConfig), "Changing viewabilityConfig on the fly is not supported")
	invariant(p20.viewabilityConfigCallbackPairs == p19.props.viewabilityConfigCallbackPairs, "Changing viewabilityConfigCallbackPairs on the fly is not supported")
	p19:_checkProps(p19.props)
end
function v17._checkProps(p21, p22) -- line: 664
	-- upvalues: invariant (copy)
	local getItem = p22.getItem
	local getItemCount = p22.getItemCount
	local horizontal = p22.horizontal
	local columnWrapperStyle = p22.columnWrapperStyle
	local onViewableItemsChanged = p22.onViewableItemsChanged
	local viewabilityConfigCallbackPairs = p22.viewabilityConfigCallbackPairs
	local numColumns = p21.props.numColumns
	local v48 = numColumns == nil and 1 or numColumns

	invariant(not getItem and not getItemCount, "FlatList does not support custom data formats.")

	if v48 > 1 then
		invariant(not horizontal, "numColumns does not support horizontal.")
	else
		invariant(not columnWrapperStyle, "columnWrapperStyle not supported for single column lists")
	end

	invariant(not (onViewableItemsChanged and viewabilityConfigCallbackPairs), "FlatList does not support setting both onViewableItemsChanged and viewabilityConfigCallbackPairs.")
end
function v17._pushMultiColumnViewable(p23, p24, p25) -- line: 684
	-- upvalues: keyExtractor (copy), Array (copy), invariant (copy), Object (copy)
	local numColumns = p23.props.numColumns
	local v53 = numColumns == nil and 1 or numColumns
	local v54 = if p23.props.keyExtractor == nil then keyExtractor else p23.props.keyExtractor

	Array.forEach(p25.item, function(p26, p27) -- line: 687
		-- upvalues: invariant (copy), p25 (copy), v53 (copy), p24 (copy), Object (copy), v54 (copy)
		invariant(p25.index ~= nil, "Missing index!")

		local v88 = (p25.index - 1) * v53 + p27

		table.insert(p24, Object.assign({}, p25, {
			item = p26,
			key = v54(p26, v88),
			index = v88
		}))
	end)
end
function v17._createOnViewableItemsChanged(t14: {[any]: any}, p28: ((...any) -> ...any)?) -- line: 693
	-- upvalues: Array (copy)
	return function(t15: {[any]: any}) -- line: 701
		-- upvalues: t14 (copy), p28 (copy), Array (copy)
		local numColumns = t14.props.numColumns
		local v91 = numColumns == nil and 1 or numColumns

		if p28 ~= nil then
			if v91 > 1 then
				local t16 = {}
				local t17 = {}

				Array.forEach(t15.viewableItems, function(p29) -- line: 710
					-- upvalues: t14 (copy), t17 (copy)
					return t14:_pushMultiColumnViewable(t17, p29)
				end)
				Array.forEach(t15.changed, function(p30) -- line: 713
					-- upvalues: t14 (copy), t16 (copy)
					return t14:_pushMultiColumnViewable(t16, p30)
				end)
				p28({
					viewableItems = t17,
					changed = t16
				})

				return
			end

			p28(t15)
		end
	end
end
function v17.render(p31) -- line: 724
	-- upvalues: Object (copy), React (copy), VirtualizedList (copy), t1 (copy)
	local props = p31.props
	local _ = props.numColumns
	local _ = props.columnWrapperStyle
	local removeClippedSubviews = props.removeClippedSubviews
	local v62 = Object.assign({}, props, {
		numColumns = Object.None,
		columnWrapperStyle = Object.None,
		removeClippedSubviews = Object.None
	})

	return React.createElement(VirtualizedList, Object.assign({}, v62, {
		getItem = p31._getItem,
		getItemCount = p31._getItemCount,
		keyExtractor = p31._keyExtractor,
		ref = p31._captureRef,
		viewabilityConfigCallbackPairs = p31._virtualizedListPairs,
		removeClippedSubviews = if removeClippedSubviews == nil then t1.OS == "android" else removeClippedSubviews
	}, p31._renderer()))
end

return v17
