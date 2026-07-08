local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean
local Object = LuauPolyfill.Object
local invariant = require(ParentParent.jsUtils.invariant)

require(script.Parent.ViewabilityHelper)

local keyExtractor = require(script.Parent.VirtualizeUtils).keyExtractor
local View = require(ParentParent.Components.View.View)
local VirtualizedList = require(script.Parent.VirtualizedList)
local React = require(ParentParentParent.React)
local ItemWithSeparator = nil
local v13 = React.PureComponent:extend("VirtualizedSectionList")

function v13.init(p1) -- line: 206
	-- upvalues: invariant (copy), keyExtractor (copy), Object (copy), Array (copy), Boolean (copy), React (copy), ItemWithSeparator (ref)
	p1._updateHighlightMap = {}
	p1._updatePropsMap = {}
	p1._listRef = nil

	function p1._captureRef(p2) -- line: 210
		-- upvalues: p1 (copy)
		p1._listRef = p2
	end
	function p1._keyExtractor(_, n1: number) -- line: 214
		-- upvalues: p1 (copy)
		local v90 = p1:_subExtractor(n1)

		if v90 then
			return v90.key
		end

		return (tostring(n1))
	end
	function p1._convertViewable(p4) -- line: 219
		-- upvalues: invariant (copy), p1 (copy), keyExtractor (copy), Object (copy)
		invariant(p4.index ~= nil, "Received a broken ViewToken")

		local v92 = p1:_subExtractor(p4.index)

		if not v92 then
			return nil
		end

		local keyExtractor2 = v92.section.keyExtractor
		local v94 = if not p1.props.keyExtractor then keyExtractor else p1.props.keyExtractor
		local v95 = if keyExtractor2 == nil then v94(p4.item, if v92.index ~= nil then v92.index else 1) else keyExtractor2(p4.item, v92.index)

		return Object.assign({}, p4, {
			index = v92.index,
			key = v95,
			section = v92.section
		})
	end
	function p1._onViewableItemsChanged(t1: {[any]: any}) -- line: 242
		-- upvalues: p1 (copy), Array (copy), Boolean (copy)
		local viewableItems = t1.viewableItems
		local changed = t1.changed
		local onViewableItemsChanged = p1.props.onViewableItemsChanged

		if onViewableItemsChanged ~= nil then
			onViewableItemsChanged({
				viewableItems = Array.filter(Array.map(viewableItems, p1._convertViewable, p1), Boolean.toJSBoolean),
				changed = Array.filter(Array.map(changed, p1._convertViewable, p1), Boolean.toJSBoolean)
			})
		end
	end
	function p1._renderItem(n2: number) -- line: 259
		-- upvalues: p1 (copy), Boolean (copy), invariant (copy), React (copy), ItemWithSeparator (ref)
		return function(t2: {[any]: any}) -- line: 260
			-- upvalues: p1 (copy), Boolean (copy), n2 (copy), invariant (copy), React (copy), ItemWithSeparator (ref)
			local item = t2.item
			local index = t2.index
			local v118 = p1:_subExtractor(index)

			if not v118 then
				return nil
			end

			local index2 = v118.index

			if index2 == nil then
				local section = v118.section

				if v118.header == true then
					local renderSectionHeader = p1.props.renderSectionHeader

					if Boolean.toJSBoolean(renderSectionHeader) then
						return (renderSectionHeader({
							section = section
						}))
					end

					return nil
				end

				local renderSectionFooter = p1.props.renderSectionFooter

				if Boolean.toJSBoolean(renderSectionFooter) then
					return (renderSectionFooter({
						section = section
					}))
				end

				return nil
			end

			local v123 = v118.section.renderItem or p1.props.renderItem
			local v124 = p1:_getSeparatorComponent(index, v118, n2)

			invariant(v123, "no renderItem!")

			return React.createElement(ItemWithSeparator, {
				SeparatorComponent = v124,
				LeadingSeparatorComponent = if index2 ~= 1 then nil else p1.props.SectionSeparatorComponent,
				cellKey = v118.key,
				index = index2,
				item = item,
				leadingItem = v118.leadingItem,
				leadingSection = v118.leadingSection,
				prevCellKey = (p1:_subExtractor(index - 1) or {}).key,
				setSelfHighlightCallback = p1._setUpdateHighlightFor,
				setSelfUpdatePropsCallback = p1._setUpdatePropsFor,
				updateHighlightFor = p1._updateHighlightFor,
				updatePropsFor = p1._updatePropsFor,
				renderItem = v123,
				section = v118.section,
				trailingItem = v118.trailingItem,
				trailingSection = v118.trailingSection,
				inverted = Boolean.toJSBoolean(p1.props.inverted),
				horizontal = p1.props.horizontal
			})
		end
	end
	function p1._updatePropsFor(s1: string, p5) -- line: 312
		-- upvalues: p1 (copy)
		local v103 = p1._updatePropsMap[s1]

		if v103 ~= nil then
			v103(p5)
		end
	end
	function p1._updateHighlightFor(s2: string, b1: boolean) -- line: 319
		-- upvalues: p1 (copy)
		local v106 = p1._updateHighlightMap[s2]

		if v106 ~= nil then
			v106(b1)
		end
	end
	function p1._setUpdateHighlightFor(s3: string, p6: ((...any) -> ...any)?) -- line: 326
		-- upvalues: p1 (copy)
		if p6 ~= nil then
			p1._updateHighlightMap[s3] = p6

			return
		end

		p1._updateHighlightMap[s3] = nil
	end
	function p1._setUpdatePropsFor(s4: string, p7: ((...any) -> ...any)?) -- line: 334
		-- upvalues: p1 (copy)
		if p7 ~= nil then
			p1._updatePropsMap[s4] = p7

			return
		end

		p1._updatePropsMap[s4] = nil
	end
end
function v13.scrollToLocation(t3: {[any]: any}, t4: {[any]: any}) -- line: 343
	-- upvalues: Object (copy)
	local itemIndex = t4.itemIndex
	local n3 = 1

	while n3 < t4.sectionIndex do
		itemIndex += t3.props.getItemCount(t3.props.sections[n3].data) + 2
		n3 += 1
	end

	local v19 = t4.viewOffset or 0

	if t3._listRef == nil then
		return
	end

	if t4.itemIndex > 1 and t3.props.stickySectionHeadersEnabled then
		v19 += t3._listRef.__getFrameMetricsApprox(itemIndex - t4.itemIndex).length
	end

	local v20 = Object.assign({}, t4, {
		viewOffset = v19,
		index = itemIndex
	})

	t3._listRef:scrollToIndex(v20)
end
function v13.getListRef(p8) -- line: 365
	return p8._listRef
end
function v13.render(p9) -- line: 369
	-- upvalues: Object (copy), React (copy), VirtualizedList (copy)
	local _ = p9.props.renderItem
	local _ = p9.props.sections
	local v25 = Object.assign({}, p9.props, {
		ItemSeparatorComponent = Object.None,
		SectionSeparatorComponent = Object.None,
		renderItem = Object.None,
		renderSectionFooter = Object.None,
		renderSectionHeader = Object.None,
		sections = Object.None,
		stickySectionHeadersEnabled = Object.None
	})
	local v26 = not p9.props.ListHeaderComponent and 0 or 1
	local v27 = if not p9.props.stickySectionHeadersEnabled then nil else {}
	local n4 = 0

	for _, v in ipairs(p9.props.sections) do
		if v27 ~= nil then
			table.insert(v27, n4 + v26)
		end

		n4 = n4 + 2 + p9.props.getItemCount(v.data)
	end

	local v31 = p9._renderItem(n4)

	return React.createElement(VirtualizedList, Object.assign({}, v25, {
		keyExtractor = p9._keyExtractor,
		stickyHeaderIndices = v27,
		renderItem = v31,
		data = p9.props.sections,
		getItem = function(p10, p11) -- line: 406
			-- upvalues: p9 (copy)
			return p9:_getItem(p9.props, p10, p11)
		end,
		getItemCount = function() -- line: 409
			-- upvalues: n4 (ref)
			return n4
		end,
		onViewableItemsChanged = if not p9.props.onViewableItemsChanged then nil else p9._onViewableItemsChanged,
		ref = p9._captureRef
	}))
end
function v13._getItem(_: {[any]: any}, p12, p13, n5: number) -- line: 418
	if not p13 then
		return nil
	end

	local v36 = n5 - 1
	local n6 = 1

	while n6 <= #p13 do
		local v38 = p13[n6]
		local data = v38.data
		local v40 = p12.getItemCount(data)

		if v36 == 0 or v36 == v40 + 1 then
			return v38
		end

		if v36 <= v40 then
			return p12.getItem(data, v36)
		end

		v36 -= v40 + 2
		n6 += 1
	end

	return nil
end
function v13._subExtractor(t6: {[any]: any}, n7: number) -- line: 449
	-- upvalues: Boolean (copy), keyExtractor (copy)
	local props = t6.props
	local getItem = props.getItem
	local getItemCount = props.getItemCount
	local keyExtractor3 = props.keyExtractor
	local sections = props.sections
	local n8 = 1

	while n8 <= #sections do
		local v49 = sections[n8]
		local data = v49.data
		local v51 = if not Boolean.toJSBoolean(v49.key) then tostring(n8) else tostring(v49.key)
		local v52 = n7 - 1

		if not (v52 > getItemCount(data) + 1) then
			if v52 == 0 then
				return {
					index = nil,
					header = true,
					section = v49,
					key = v51 .. ":header",
					trailingSection = sections[n8 + 1]
				}
			end

			if v52 == getItemCount(data) + 1 then
				return {
					index = nil,
					header = false,
					section = v49,
					key = v51 .. ":footer",
					trailingSection = sections[n8 + 1]
				}
			end

			local v53 = v49.keyExtractor or (keyExtractor3 or keyExtractor)

			return {
				section = v49,
				key = v51 .. ":" .. tostring(v53(getItem(data, v52), v52)),
				index = v52,
				leadingItem = getItem(data, v52 - 1),
				leadingSection = sections[n8 - 1],
				trailingItem = getItem(data, v52 + 1),
				trailingSection = sections[n8 + 1]
			}
		end

		n7 = v52 - (getItemCount(data) + 1)
		n8 += 1
	end

	return nil
end
function v13._getSeparatorComponent(t7: {[any]: any}, n9: number, p14, n10: number) -- line: 511
	-- upvalues: Boolean (copy)
	if not p14 then
		p14 = t7:_subExtractor(n9)
	end

	if not p14 then
		return nil
	end

	local v58 = Boolean.toJSBoolean(p14.section.ItemSeparatorComponent) and p14.section.ItemSeparatorComponent or t7.props.ItemSeparatorComponent
	local SectionSeparatorComponent = t7.props.SectionSeparatorComponent
	local v60 = n9 == n10
	local v61 = p14.index == t7.props.getItemCount(p14.section.data)

	if SectionSeparatorComponent and v61 then
		return SectionSeparatorComponent
	end

	if v58 and not v61 and not v60 then
		return v58
	end

	return nil
end
function ItemWithSeparator(p15) -- line: 563
	-- upvalues: React (copy), Object (copy), View (copy)
	local LeadingSeparatorComponent = p15.LeadingSeparatorComponent
	local SeparatorComponent = p15.SeparatorComponent
	local cellKey = p15.cellKey
	local prevCellKey = p15.prevCellKey
	local setSelfHighlightCallback = p15.setSelfHighlightCallback
	local updateHighlightFor = p15.updateHighlightFor
	local setSelfUpdatePropsCallback = p15.setSelfUpdatePropsCallback
	local updatePropsFor = p15.updatePropsFor
	local item = p15.item
	local index = p15.index
	local section = p15.section
	local inverted = p15.inverted
	local v75, v76 = React.useState(false)
	local v77, v78 = React.useState(false)
	local v79, v80 = React.useState({
		LayoutOrder = -1,
		leadingItem = p15.leadingItem,
		leadingSection = p15.leadingSection,
		section = p15.section,
		trailingItem = p15.item,
		trailingSection = p15.trailingSection
	})
	local v81, v82 = React.useState({
		LayoutOrder = 1,
		leadingItem = p15.item,
		leadingSection = p15.leadingSection,
		section = p15.section,
		trailingItem = p15.trailingItem,
		trailingSection = p15.trailingSection
	})

	React.useEffect(function() -- line: 601
		-- upvalues: setSelfHighlightCallback (copy), cellKey (copy), v78 (copy), setSelfUpdatePropsCallback (copy), v82 (copy)
		setSelfHighlightCallback(cellKey, v78)
		setSelfUpdatePropsCallback(cellKey, v82)

		return function() -- line: 604
			-- upvalues: setSelfUpdatePropsCallback (copy), cellKey (copy), setSelfHighlightCallback (copy)
			setSelfUpdatePropsCallback(cellKey, nil)
			setSelfHighlightCallback(cellKey, nil)
		end
	end, {
		cellKey,
		setSelfHighlightCallback,
		v82,
		setSelfUpdatePropsCallback
	})

	local t8 = {
		highlight = function() -- line: 611
			-- upvalues: v76 (copy), v78 (copy), prevCellKey (copy), updateHighlightFor (copy)
			v76(true)
			v78(true)

			if prevCellKey ~= nil then
				updateHighlightFor(prevCellKey, true)
			end
		end,
		unhighlight = function() -- line: 618
			-- upvalues: v76 (copy), v78 (copy), prevCellKey (copy), updateHighlightFor (copy)
			v76(false)
			v78(false)

			if prevCellKey ~= nil then
				updateHighlightFor(prevCellKey, false)
			end
		end,
		updateProps = function(s5: string, p16) -- line: 625
			-- upvalues: LeadingSeparatorComponent (copy), v80 (copy), Object (copy), v79 (copy), prevCellKey (copy), updatePropsFor (copy), SeparatorComponent (copy), v82 (copy), v81 (copy)
			if s5 == "leading" then
				if LeadingSeparatorComponent ~= nil then
					v80(Object.assign({}, v79, p16))

					return
				end

				if prevCellKey ~= nil then
					updatePropsFor(prevCellKey, Object.assign({}, v79, p16))

					return
				end
			elseif s5 == "trailing" and SeparatorComponent ~= nil then
				v82(Object.assign({}, v81, p16))
			end
		end
	}
	local v84 = p15.renderItem({
		item = item,
		index = index,
		section = section,
		separators = t8
	})
	local v85 = LeadingSeparatorComponent ~= nil and React.createElement(LeadingSeparatorComponent, Object.assign({
		highlighted = v75
	}, v79))
	local v86 = SeparatorComponent ~= nil and React.createElement(SeparatorComponent, Object.assign({
		highlighted = v77
	}, v81))

	if v85 or v86 then
		return (React.createElement(View, {
			Size = if not p15.horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0),
			AutomaticSize = if not p15.horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X
		}, React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = if not p15.horizontal then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
		}), if inverted ~= false then v86 else v85, v84, if inverted ~= false then v85 else v86))
	end

	return v84
end

return v13
