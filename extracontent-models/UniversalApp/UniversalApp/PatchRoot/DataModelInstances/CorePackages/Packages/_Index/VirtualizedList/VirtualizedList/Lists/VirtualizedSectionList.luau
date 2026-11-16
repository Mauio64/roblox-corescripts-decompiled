local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object

local invariant = require(parent.jsUtils.invariant)
require(script.Parent.ViewabilityHelper)

local VirtualizeUtils = require(script.Parent.VirtualizeUtils)
local keyExtractor = VirtualizeUtils.keyExtractor

local View = require(parent.Components.View.View)
local VirtualizedList = require(script.Parent.VirtualizedList)

local React = require(parent2.React)

local ItemWithSeparator

local extended = React.PureComponent:extend("VirtualizedSectionList")

function extended:init()
	self._updateHighlightMap = {}
	self._updatePropsMap = {}
	self._listRef = nil
	function self._captureRef(listRef)
		self._listRef = listRef
	end

	function self._keyExtractor(_, p: number)
		local v = self:_subExtractor(p)

		if v then
			return v.key
		end

		return (tostring(p))
	end

	function self._convertViewable(p)
		invariant(p.index ~= nil, "Received a broken ViewToken")
		local v = self:_subExtractor(p.index)

		if not v then
			return nil
		end

		local keyExtractor2 = v.section.keyExtractor
		local v2

		if self.props.keyExtractor then
			v2 = self.props.keyExtractor
		else
			v2 = keyExtractor
		end

		local v3

		if keyExtractor2 == nil then
			v3 = v2(p.item, v.index == nil and 1 or v.index)
		else
			v3 = keyExtractor2(p.item, v.index)
		end

		return Object.assign({}, p, { index = v.index, key = v3, section = v.section })
	end

	function self._onViewableItemsChanged(p)
		local viewableItems = p.viewableItems
		local changed = p.changed
		local onViewableItemsChanged = self.props.onViewableItemsChanged

		if onViewableItemsChanged ~= nil then
			onViewableItemsChanged({
				viewableItems = Array.filter(Array.map(viewableItems, self._convertViewable, self), Boolean.toJSBoolean),
				changed = Array.filter(Array.map(changed, self._convertViewable, self), Boolean.toJSBoolean)
			})
		end
	end

	function self._renderItem(p: number)
		return function(p2)
			local item = p2.item
			local index = p2.index
			local v = self:_subExtractor(index)

			if not v then
				return nil
			end

			local index2 = v.index

			if index2 == nil then
				local section = v.section

				if v.header == true then
					local renderSectionHeader = self.props.renderSectionHeader

					if Boolean.toJSBoolean(renderSectionHeader) then
						return (renderSectionHeader({ section = section }))
					end

					return nil
				else
					local renderSectionFooter = self.props.renderSectionFooter

					if Boolean.toJSBoolean(renderSectionFooter) then
						return (renderSectionFooter({ section = section }))
					end

					return nil
				end
			else
				local renderItem = v.section.renderItem or self.props.renderItem
				local separatorComponent = self:_getSeparatorComponent(index, v, p)
				invariant(renderItem, "no renderItem!")
				local createElement = React.createElement
				local v2 = ItemWithSeparator
				local leadingSeparatorComponent

				if index2 == 1 then
					leadingSeparatorComponent = self.props.SectionSeparatorComponent
				end

				return createElement(v2, {
					SeparatorComponent = separatorComponent,
					LeadingSeparatorComponent = leadingSeparatorComponent,
					cellKey = v.key,
					index = index2,
					item = item,
					leadingItem = v.leadingItem,
					leadingSection = v.leadingSection,
					prevCellKey = (self:_subExtractor(index - 1) or {}).key,
					setSelfHighlightCallback = self._setUpdateHighlightFor,
					setSelfUpdatePropsCallback = self._setUpdatePropsFor,
					updateHighlightFor = self._updateHighlightFor,
					updatePropsFor = self._updatePropsFor,
					renderItem = renderItem,
					section = v.section,
					trailingItem = v.trailingItem,
					trailingSection = v.trailingSection,
					inverted = Boolean.toJSBoolean(self.props.inverted),
					horizontal = self.props.horizontal
				})
			end
		end
	end

	function self._updatePropsFor(p: string, p2)
		local updateProp = self._updatePropsMap[p]

		if updateProp ~= nil then
			updateProp(p2)
		end
	end

	function self._updateHighlightFor(p: string, flag: boolean)
		local updateHighlight = self._updateHighlightMap[p]

		if updateHighlight ~= nil then
			updateHighlight(flag)
		end
	end

	function self._setUpdateHighlightFor(p: string, callback)
		if callback == nil then
			self._updateHighlightMap[p] = nil
		else
			self._updateHighlightMap[p] = callback
		end
	end

	function self._setUpdatePropsFor(p: string, callback)
		if callback == nil then
			self._updatePropsMap[p] = nil
		else
			self._updatePropsMap[p] = callback
		end
	end
end

function extended:scrollToLocation(data)
	local itemIndex = data.itemIndex
	local v = 1

	while v < data.sectionIndex do
		itemIndex += self.props.getItemCount(self.props.sections[v].data) + 2
		v += 1
	end

	local viewOffset = data.viewOffset or 0

	if self._listRef == nil then
		return
	end

	if data.itemIndex > 1 and self.props.stickySectionHeadersEnabled then
		viewOffset += self._listRef.__getFrameMetricsApprox(itemIndex - data.itemIndex).length
	end

	local v2 = Object.assign({}, data, { viewOffset = viewOffset, index = itemIndex })
	self._listRef:scrollToIndex(v2)
end

function extended:getListRef()
	return self._listRef
end

function extended:render()
	local _renderItem = self.props.renderItem
	local _sections = self.props.sections
	local v = Object.assign({}, self.props, {
		ItemSeparatorComponent = Object.None,
		SectionSeparatorComponent = Object.None,
		renderItem = Object.None,
		renderSectionFooter = Object.None,
		renderSectionHeader = Object.None,
		sections = Object.None,
		stickySectionHeadersEnabled = Object.None
	})

	local v2 = self.props.ListHeaderComponent and 1 or 0

	local stickyHeaderIndices = self.props.stickySectionHeadersEnabled and {} or nil
	local itemCount = 0

	for _, section in ipairs(self.props.sections) do
		if stickyHeaderIndices ~= nil then
			table.insert(stickyHeaderIndices, itemCount + v2)
		end

		itemCount = itemCount + 2 + self.props.getItemCount(section.data)
	end

	local item = self._renderItem(itemCount)

	local createElement = React.createElement

	local assign = Object.assign
	local v3 = {
		keyExtractor = self._keyExtractor,
		stickyHeaderIndices = stickyHeaderIndices,
		renderItem = item,
		data = self.props.sections,
		getItem = function(p, p2)
			return self:_getItem(self.props, p, p2)
		end,
		getItemCount = function()
			return itemCount
		end,
		onViewableItemsChanged = 0,
		ref = 0
	}
	local onViewableItemsChanged

	if self.props.onViewableItemsChanged then
		onViewableItemsChanged = self._onViewableItemsChanged
	end

	v3.onViewableItemsChanged = onViewableItemsChanged
	v3.ref = self._captureRef
	return createElement(VirtualizedList, assign({}, v, v3))
end

function extended:_getItem(p, list, p2: number)
	if not list then
		return nil
	end

	local v = p2 - 1
	local v2 = 1

	while v2 <= #list do
		local item = list[v2]
		local data = item.data
		local itemCount = p.getItemCount(data)

		if v == 0 or v == itemCount + 1 then
			return item
		end

		if v <= itemCount then
			return p.getItem(data, v)
		end

		v -= itemCount + 2

		v2 += 1
	end

	return nil
end

function extended:_subExtractor(p: number)
	local props = self.props
	local getItem = props.getItem
	local getItemCount = props.getItemCount
	local keyExtractor2 = props.keyExtractor
	local sections = props.sections
	local v = 1

	while v <= #sections do
		local section = sections[v]
		local data = section.data
		local v2

		if Boolean.toJSBoolean(section.key) then
			v2 = tostring(section.key)
		else
			v2 = tostring(v)
		end

		local v3 = p - 1

		if getItemCount(data) + 1 < v3 then
			p = v3 - (getItemCount(data) + 1)

			v += 1
		else
			if v3 == 0 then
				return {
					section = section,
					key = v2 .. ":header",
					index = nil,
					header = true,
					trailingSection = sections[v + 1]
				}
			end

			if v3 == getItemCount(data) + 1 then
				return {
					section = section,
					key = v2 .. ":footer",
					index = nil,
					header = false,
					trailingSection = sections[v + 1]
				}
			end

			return {
				section = section,
				key = v2 .. ":" .. tostring((section.keyExtractor or keyExtractor2 or keyExtractor)(
					getItem(data, v3),
					v3
				)),
				index = v3,
				leadingItem = getItem(data, v3 - 1),
				leadingSection = sections[v - 1],
				trailingItem = getItem(data, v3 + 1),
				trailingSection = sections[v + 1]
			}
		end
	end

	return nil
end

function extended:_getSeparatorComponent(p: number, p2, p3: number)
	p2 = p2 or self:_subExtractor(p)

	if not p2 then
		return nil
	end

	local itemSeparatorComponent = Boolean.toJSBoolean(p2.section.ItemSeparatorComponent)
		and p2.section.ItemSeparatorComponent
		or self.props.ItemSeparatorComponent
	local sectionSeparatorComponent = self.props.SectionSeparatorComponent
	local v = p == p3
	local v2 = p2.index == self.props.getItemCount(p2.section.data)

	if sectionSeparatorComponent and v2 then
		return sectionSeparatorComponent
	end

	if itemSeparatorComponent and not (v2 or v) then
		return itemSeparatorComponent
	end

	return nil
end

ItemWithSeparator = function(props)
	local leadingSeparatorComponent = props.LeadingSeparatorComponent
	local separatorComponent = props.SeparatorComponent
	local cellKey = props.cellKey
	local prevCellKey = props.prevCellKey
	local setSelfHighlightCallback = props.setSelfHighlightCallback
	local updateHighlightFor = props.updateHighlightFor
	local setSelfUpdatePropsCallback = props.setSelfUpdatePropsCallback
	local updatePropsFor = props.updatePropsFor
	local item = props.item
	local index = props.index
	local section = props.section
	local inverted = props.inverted

	local state, setState = React.useState(false)

	local state2, setState2 = React.useState(false)

	local state3, setState3 = React.useState({
		leadingItem = props.leadingItem,
		leadingSection = props.leadingSection,
		section = props.section,
		trailingItem = props.item,
		trailingSection = props.trailingSection,
		LayoutOrder = -1
	})

	local state4, setState4 = React.useState({
		leadingItem = props.item,
		leadingSection = props.leadingSection,
		section = props.section,
		trailingItem = props.trailingItem,
		trailingSection = props.trailingSection,
		LayoutOrder = 1
	})

	React.useEffect(function()
		setSelfHighlightCallback(cellKey, setState2)
		setSelfUpdatePropsCallback(cellKey, setState4)
		return function()
			setSelfUpdatePropsCallback(cellKey, nil)
			setSelfHighlightCallback(cellKey, nil)
		end
	end, { cellKey, setSelfHighlightCallback, setState4, setSelfUpdatePropsCallback })

	local item2 = props.renderItem({
		item = item,
		index = index,
		section = section,
		separators = {
			highlight = function()
				setState(true)
				setState2(true)

				if prevCellKey ~= nil then
					updateHighlightFor(prevCellKey, true)
				end
			end,
			unhighlight = function()
				setState(false)
				setState2(false)

				if prevCellKey ~= nil then
					updateHighlightFor(prevCellKey, false)
				end
			end,
			updateProps = function(p: string, p2)
				if p == "leading" then
					if leadingSeparatorComponent ~= nil then
						setState3(Object.assign({}, state3, p2))
					elseif prevCellKey ~= nil then
						updatePropsFor(prevCellKey, Object.assign({}, state3, p2))
					end
				elseif p == "trailing" and separatorComponent ~= nil then
					setState4(Object.assign({}, state4, p2))
				end
			end
		}
	})
	local v

	if leadingSeparatorComponent == nil then
		v = false
	else
		v = React.createElement(leadingSeparatorComponent, Object.assign({ highlighted = state }, state3))
	end

	local v2

	if separatorComponent == nil then
		v2 = false
	else
		v2 = React.createElement(separatorComponent, Object.assign({ highlighted = state2 }, state4))
	end

	if not (v or v2) then
		return item2
	end

	local createElement = React.createElement
	local size

	if props.horizontal then
		size = UDim2.new(0, 0, 1, 0)
	else
		size = UDim2.new(1, 0, 0, 0)
	end

	local automaticSize

	if props.horizontal then
		automaticSize = Enum.AutomaticSize.X
	else
		automaticSize = Enum.AutomaticSize.Y
	end

	local createElement2 = React.createElement
	local v3 = { SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = 0 }
	local fillDirection

	if props.horizontal then
		fillDirection = Enum.FillDirection.Horizontal
	else
		fillDirection = Enum.FillDirection.Vertical
	end

	v3.FillDirection = fillDirection
	local element = createElement2("UIListLayout", v3)

	local v4 = if inverted == false then v else v2

	if inverted == false then
		v = v2
	end

	return (createElement(View, { Size = size, AutomaticSize = automaticSize }, element, v4, item2, v))
end

return extended
