local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array

local Object = LuauPolyfill.Object

local v = { OS = "roblox" }
local deepDiffer = require(parent.Utilities.differ.deepDiffer)
local React = require(parent2.React)

local VirtualizedList = require(parent.Lists.VirtualizedList)

local View = require(parent.Components.View.View)

local StyleSheet = require(parent.StyleSheet.StyleSheet)
local invariant = require(parent.jsUtils.invariant)

local scrollView = parent.Components.ScrollView

require(scrollView.ScrollView)

require(scrollView.ScrollViewNativeComponent)

require(parent.Lists.ViewabilityHelper)

require(parent.Lists.VirtualizedList)

local VirtualizeUtils = require(script.Parent.VirtualizeUtils)
local keyExtractor = VirtualizeUtils.keyExtractor

local function removeClippedSubviewsOrDefault(flag: boolean?)
	return flag ~= nil and flag
end

local function numColumnsOrDefault(numColumns: number?) -- 7 equivalent calls inferred from this helper
	return if numColumns == nil then 1 else numColumns
end

local extended = React.PureComponent:extend("FlatList")

function extended:init(_)
	self._virtualizedListPairs = {}
	function self._captureRef(listRef)
		self._listRef = listRef
	end

	function self._getItem(p, p2: number)
		local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call

		if not (v2 > 1) then
			return p[p2]
		end

		local result = {}

		for i = 1, v2 do
			local v3 = p[(p2 - 1) * v2 + i]

			if v3 ~= nil then
				table.insert(result, v3)
			end
		end

		return result
	end

	function self._getItemCount(list)
		if list == nil then
			return 0
		end

		local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call

		if v2 > 1 then
			return (math.ceil(#list / v2))
		end

		return #list
	end

	function self._keyExtractor(p, p2: number)
		local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call
		local v3

		if self.props.keyExtractor == nil then
			v3 = keyExtractor
		else
			v3 = self.props.keyExtractor
		end

		if not (v2 > 1) then
			return v3(p, p2)
		end

		if Array.isArray(p) then
			return Array.join(Array.map(p, function(p3, p4)
				return v3(p3, (p2 - 1) * v2 + p4)
			end), ":")
		end

		invariant(
			Array.isArray(p),
			"FlatList: Encountered internal consistency error, expected each item to consist of an array with 1-%s columns; instead, received a single item.",
			v2
		)

		return nil
	end

	function self._renderer()
		local listItemComponent = self.props.ListItemComponent
		local renderItem = self.props.renderItem
		local columnWrapperStyle = self.props.columnWrapperStyle

		local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call

		local function renderer(props) -- 1 equivalent call inferred from this helper
			if listItemComponent then
				return React.createElement(listItemComponent, props)
			end

			if renderItem then
				return renderItem(props)
			end

			return nil
		end

		return {
			[listItemComponent and "ListItemComponent" or "renderItem"] = function(props)
				if not (v2 > 1) then
					return renderer(props)
				end

				local createElement = React.createElement
				local v3 = {
					key = self.props.horizontal and "UIListVerticalLayout" or "UIListHorizontalLayout",
					Name = self.props.horizontal and "UIListVerticalLayout" or "UIListHorizontalLayout",
					FillDirection = 0,
					SortOrder = 0
				}
				local fillDirection

				if self.props.horizontal then
					fillDirection = Enum.FillDirection.Vertical
				else
					fillDirection = Enum.FillDirection.Horizontal
				end

				v3.FillDirection = fillDirection

				v3.SortOrder = Enum.SortOrder.LayoutOrder
				local element = createElement("UIListLayout", v3)

				local item = props.item
				local index = props.index

				invariant(Array.isArray(item), "Expected array of items with numColumns > 1")
				return React.createElement(
					View,
					{
						style = StyleSheet.compose(columnWrapperStyle)
					},
					Array.concat({ element }, Array.map(item, function(p, layoutOrder)
						local v4 = renderer({ -- inferred equivalent call
							item = Object.assign({}, p, { LayoutOrder = layoutOrder }),
							index = (index - 1) * v2 + layoutOrder,
							separators = props.separators
						})

						if v4 == nil then
							return nil
						end

						return (React.createElement(React.Fragment, { key = layoutOrder }, v4))
					end))
				)
			end
		}
	end

	self:_checkProps(self.props)

	if self.props.viewabilityConfigCallbackPairs then
		self._virtualizedListPairs = Array.map(self.props.viewabilityConfigCallbackPairs, function(p)
			return {
				viewabilityConfig = p.viewabilityConfig,
				onViewableItemsChanged = self:_createOnViewableItemsChanged(p.onViewableItemsChanged)
			}
		end)
	elseif self.props.onViewableItemsChanged then
		table.insert(self._virtualizedListPairs, {
			viewabilityConfig = self.props.viewabilityConfig,
			onViewableItemsChanged = self:_createOnViewableItemsChanged(self.props.onViewableItemsChanged)
		})
	end
end

function extended:scrollToEnd(p)
	if self._listRef then
		self._listRef:scrollToEnd(p)
	end
end

function extended:scrollToIndex(p)
	if self._listRef then
		self._listRef:scrollToIndex(p)
	end
end

function extended:scrollToItem(p)
	if self._listRef then
		self._listRef:scrollToItem(p)
	end
end

function extended:scrollToOffset(p)
	if self._listRef then
		self._listRef:scrollToOffset(p)
	end
end

function extended:recordInteraction()
	if self._listRef then
		self._listRef:recordInteraction()
	end
end

function extended:flashScrollIndicators()
	if self._listRef then
		self._listRef:flashScrollIndicators()
	end
end

function extended:getScrollResponder()
	if self._listRef then
		return self._listRef:getScrollResponder()
	end
end

function extended:getNativeScrollRef()
	if self._listRef then
		return self._listRef:getScrollRef()
	end
end
function extended:getScrollableNode()
	if self._listRef then
		return self._listRef:getScrollableNode()
	end
end
function extended:setNativeProps(p)
	if self._listRef then
		self._listRef:setNativeProps(p)
	end
end
function extended:componentDidUpdate(data)
	invariant(
		data.numColumns == self.props.numColumns,
		"Changing numColumns on the fly is not supported. Change the key prop on FlatList when changing the number of columns to force a fresh render of the component."
	)

	invariant(
		data.onViewableItemsChanged == self.props.onViewableItemsChanged,
		"Changing onViewableItemsChanged on the fly is not supported"
	)

	invariant(
		not deepDiffer(data.viewabilityConfig, self.props.viewabilityConfig),
		"Changing viewabilityConfig on the fly is not supported"
	)

	invariant(
		data.viewabilityConfigCallbackPairs == self.props.viewabilityConfigCallbackPairs,
		"Changing viewabilityConfigCallbackPairs on the fly is not supported"
	)

	self:_checkProps(self.props)
end
function extended:_checkProps(data)
	local getItem = data.getItem
	local getItemCount = data.getItemCount
	local horizontal = data.horizontal
	local columnWrapperStyle = data.columnWrapperStyle
	local onViewableItemsChanged = data.onViewableItemsChanged
	local viewabilityConfigCallbackPairs = data.viewabilityConfigCallbackPairs
	local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call
	invariant(not (getItem or getItemCount), "FlatList does not support custom data formats.")

	if v2 > 1 then
		invariant(not horizontal, "numColumns does not support horizontal.")
	else
		invariant(not columnWrapperStyle, "columnWrapperStyle not supported for single column lists")
	end

	invariant(
		not (onViewableItemsChanged and viewabilityConfigCallbackPairs),
		"FlatList does not support setting both onViewableItemsChanged and viewabilityConfigCallbackPairs."
	)
end
function extended:_pushMultiColumnViewable(list, p)
	local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call
	local v3

	if self.props.keyExtractor == nil then
		v3 = keyExtractor
	else
		v3 = self.props.keyExtractor
	end

	Array.forEach(p.item, function(p2, p3)
		invariant(p.index ~= nil, "Missing index!")
		local v4 = (p.index - 1) * v2 + p3
		table.insert(list, Object.assign({}, p, { item = p2, key = v3(p2, v4), index = v4 }))
	end)
end
function extended:_createOnViewableItemsChanged(callback)
	return function(p)
		local v2 = numColumnsOrDefault(self.props.numColumns) -- inferred equivalent call

		if callback ~= nil then
			if v2 > 1 then
				local changed = {}
				local viewableItems = {}
				Array.forEach(p.viewableItems, function(p2)
					return self:_pushMultiColumnViewable(viewableItems, p2)
				end)

				Array.forEach(p.changed, function(p2)
					return self:_pushMultiColumnViewable(changed, p2)
				end)

				callback({ viewableItems = viewableItems, changed = changed })
			else
				callback(p)
			end
		end
	end
end

function extended:render()
	local props = self.props

	local _numColumns = props.numColumns
	local _columnWrapperStyle = props.columnWrapperStyle
	local removeClippedSubviews = props.removeClippedSubviews
	local v2 = Object.assign({}, props, {
		numColumns = Object.None,
		columnWrapperStyle = Object.None,
		removeClippedSubviews = Object.None
	})

	local createElement = React.createElement

	local assign = Object.assign
	local v3 = {
		getItem = self._getItem,
		getItemCount = self._getItemCount,
		keyExtractor = self._keyExtractor,
		ref = self._captureRef,
		viewabilityConfigCallbackPairs = self._virtualizedListPairs,
		removeClippedSubviews = 0
	}

	if removeClippedSubviews == nil then
		removeClippedSubviews = v.OS == "android"
	end

	v3.removeClippedSubviews = removeClippedSubviews
	return createElement(VirtualizedList, assign({}, v2, v3, self._renderer()))
end

return extended
