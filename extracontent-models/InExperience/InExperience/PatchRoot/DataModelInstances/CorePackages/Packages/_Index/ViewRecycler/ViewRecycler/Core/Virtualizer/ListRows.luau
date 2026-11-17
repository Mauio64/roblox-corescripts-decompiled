local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.DataSource)
local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
local Diagnostics = require(ViewRecycler.Core.Diagnostics)
require(ViewRecycler.Core.Layout)
local PlacementTypes = require(ViewRecycler.Core.Placement.PlacementTypes)
local ShallowTable = require(ViewRecycler.Internal.ShallowTable)
local Types = require(ViewRecycler.Core.Types)
require(ViewRecycler.Core.Recycling.SlotBinder)

local cloneFrozen = ShallowTable.cloneFrozen
local containsEqual = ShallowTable.containsEqual
local optionalContainsEqual = ShallowTable.optionalContainsEqual

local ITEM_LAYOUT_KEYS = Types.ITEM_LAYOUT_KEYS
local ITEM_PLACEMENT_KEYS = PlacementTypes.ITEM_PLACEMENT_KEYS
local frozen = table.freeze({ firstIndex = 1, lastIndex = 0 })
local frozen2 = table.freeze({})
local frozen3 = table.freeze({})
local frozen4 = table.freeze({
	retainedItems = frozen3,
	additionalItems = frozen3,
	placements = frozen2,
	hasViewportRelativePlacements = false
})

local function sameRange(mountedRange, p): boolean -- 1 equivalent call inferred from this helper
	return mountedRange.firstIndex == p.firstIndex and mountedRange.lastIndex == p.lastIndex
end

local function measuresSameContent(state, state2): boolean -- 1 equivalent call inferred from this helper
	if state == state2 then
		return true
	end

	local itemLayout = state.itemLayout
	local itemLayout2 = state2.itemLayout
	return state.assignment == state2.assignment
		and state.pinnedPosition == state2.pinnedPosition
		and itemLayout.crossAxisIndex == itemLayout2.crossAxisIndex
		and itemLayout.crossAxisCount == itemLayout2.crossAxisCount
		and itemLayout.crossAxisSpacing == itemLayout2.crossAxisSpacing
end

local function resolveLayout(list, itemLayout, flag: boolean?)
	if itemLayout ~= nil and containsEqual(itemLayout, list, ITEM_LAYOUT_KEYS) then
		return itemLayout
	end

	if table.isfrozen(list) then
		return list
	end

	if flag then
		return (table.freeze(list))
	end

	return (cloneFrozen(list))
end

local function resolvePlacement(data, p: number, state)
	local v = frozen2
	local v2 = nil

	if data == nil or not data.viewportRelative then
		if data ~= nil then
			v = {
				mainAxisOffset = data.mainAxisOffset,
				mainAxisLength = data.mainAxisLength,
				mainAxisEndLimit = data.mainAxisEndLimit,
				zIndex = data.zIndex
			}
		end
	else
		local mainAxisEndLimit = data.mainAxisEndLimit
		v = {
			mainAxisOffset = p + (data.mainAxisOffset or 0),
			mainAxisLength = data.mainAxisLength,
			mainAxisEndLimit = 0,
			zIndex = 0
		}
		local mainAxisEndLimit2

		if mainAxisEndLimit ~= nil then
			mainAxisEndLimit2 = p + mainAxisEndLimit
		end

		v.mainAxisEndLimit = mainAxisEndLimit2
		v.zIndex = data.zIndex

		v2 = {
			mainAxisOffset = data.mainAxisOffset,
			mainAxisLength = data.mainAxisLength,
			mainAxisEndLimit = mainAxisEndLimit,
			viewportRelative = true,
			zIndex = data.zIndex
		}
	end

	if state == nil or not containsEqual(state.canvasPlacement, v, ITEM_PLACEMENT_KEYS) then
		if v ~= frozen2 then
			table.freeze(v)
		end
	else
		v = state.canvasPlacement
	end

	if state ~= nil and optionalContainsEqual(state.viewportPlacement, v2, ITEM_PLACEMENT_KEYS) then
		return v, state.viewportPlacement
	end

	if v2 ~= nil then
		table.freeze(v2)
	end

	return v, v2
end

local distanceFrom
local sortByIndex
local prioritizeSlots

if FFlagViewRecyclerReact084 then
	distanceFrom = function(p, item)
		local index = item.index

		if index == nil or item.side then
			return 0
		end

		if index < p.firstIndex then
			return p.firstIndex - index
		end

		return (math.max(0, index - p.lastIndex))
	end

	sortByIndex = function(list)
		for i = 2, #list do
			local item = list[i]
			local v = i

			while v > 1 and list[v - 1].index > item.index do
				list[v] = list[v - 1]
				v -= 1
			end

			list[v] = item
		end
	end

	prioritizeSlots = function(list, p, list2, list3)
		local firstIndex = p.firstIndex
		local lastIndex = p.lastIndex
		local count = 0

		for _, item in list do
			local index = item.index

			if index == nil or item.side or firstIndex <= index and index <= lastIndex then
				count += 1
				list[count] = item
			elseif index < firstIndex then
				table.insert(list2, item)
			else
				table.insert(list3, item)
			end
		end

		sortByIndex(list2)
		sortByIndex(list3)
		local count2 = #list2
		local v = 1

		for i = count + 1, #list do
			local v2

			if count2 >= 1 and (list3[v] == nil or firstIndex - list2[count2].index <= list3[v].index - lastIndex) then
				v2 = list2[count2]
				count2 -= 1
			else
				v2 = list3[v]
				v += 1
			end

			list[i] = v2
		end

		table.clear(list2)
		table.clear(list3)
	end
else
	prioritizeSlots = nil
end

local function createListRows(data)
	local slotBinder = data.slotBinder
	local isReadyOnAssignment

	if FFlagViewRecyclerReact084 then
		isReadyOnAssignment = data.isReadyOnAssignment
	else
		isReadyOnAssignment = nil
	end

	local flag = false

	local v = {}
	local v2 = {}
	local v3 = true
	local v4 = {}
	local v5 = {}
	local flag2 = false
	local v6 = frozen
	local v7 = nil
	local v8 = 0
	local v9 = nil
	local v10 = frozen4
	local count = 0
	local mountedViews = frozen3

	local v11 = false
	local flag3 = false
	local v12 = false
	local set = {}

	local v13 = nil
	local v14 = frozen

	local function knownRange() -- 3 equivalent calls inferred from this helper
		if flag2 then
			return v6
		end

		return if v13 == nil then frozen else v14
	end

	local function noteDataChange(p)
		for _, change in p.changes do
			local kind = change.type

			if kind == DataSourceChangeType.Reset then
				v11 = true
				flag3 = true
			elseif kind == DataSourceChangeType.Reorder then
				v11 = true
			elseif kind == DataSourceChangeType.Update then
				for _, key in change.keys do
					set[key] = true
				end
			elseif kind == DataSourceChangeType.Insert then
				for _, key in change.keys do
					set[key] = true
				end

				local v15 = knownRange() -- inferred equivalent call

				if not v11 and not Types.isIndexRangeEmpty(v15) and change.index <= v15.lastIndex then
					v11 = true
				end
			elseif kind == DataSourceChangeType.Remove then
				local v15 = knownRange() -- inferred equivalent call

				if not v11 and not Types.isIndexRangeEmpty(v15) and change.index <= v15.lastIndex then
					v11 = true
				end
			elseif kind == DataSourceChangeType.Move then
				local v15 = knownRange() -- inferred equivalent call

				if
					not v11
					and not Types.isIndexRangeEmpty(v15)
					and math.min(change.fromIndex, change.toIndex) <= v15.lastIndex
					and math.max(change.fromIndex, change.toIndex) >= v15.firstIndex
				then
					v11 = true
				end
			end
		end
	end

	local function publish(state, itemLayout, canvasPlacement, viewportPlacement, contentStartOffset: number): boolean
		local state2 = state.state
		local assignment = state.assignment

		if
			state2 ~= nil
			and state2.assignment == assignment
			and state2.index == state.index
			and state2.pinnedPosition == state.pinnedPosition
			and state2.itemLayout == itemLayout
			and state2.canvasPlacement == canvasPlacement
			and state2.viewportPlacement == viewportPlacement
			and state2.contentStartOffset == contentStartOffset
			and state.record.itemView == state.view
		then
			return false
		end

		local frozen5 = table.freeze({
			assignment = assignment,
			index = state.index,
			pinnedPosition = state.pinnedPosition,
			itemLayout = itemLayout,
			canvasPlacement = canvasPlacement,
			viewportPlacement = viewportPlacement,
			contentStartOffset = contentStartOffset
		})

		state.state = frozen5
		state.record = table.freeze({ itemView = state.view, state = frozen5 })
		return true
	end

	local epoch = 0
	local dataSource = nil
	local layout = nil
	local v15 = 0
	local v16 = 0
	local v17 = false
	local v18 = 0
	local v19 = 0
	local v20 = {}
	local v21 = {}
	local count2 = 0
	local v22, v23

	if FFlagViewRecyclerReact084 then
		v22 = {}
		v23 = {}
	else
		v22 = nil
		v23 = nil
	end

	local records = frozen3
	local records2 = frozen3
	local v24 = nil
	local v25 = {}

	local function enter(p: string, p2: number?, p3, viewType) -- 4 equivalent calls inferred from this helper
		local v26 = {
			key = p,
			value = p3,
			viewType = viewType,
			index = p2,
			side = false,
			epoch = epoch,
			entered = true,
			changed = true
		}

		count2 += 1
		table.insert(v20, v26)
		return v26
	end

	local function replace(data2, item, itemViewType) -- 1 equivalent call inferred from this helper
		table.insert(v21, data2.key)
		local v26 = enter(data2.key, data2.index, item, itemViewType) -- inferred equivalent call
		v26.side = data2.side
		return v26
	end

	local function claim(p, p2: string) -- 4 equivalent calls inferred from this helper
		assert(p.epoch ~= epoch, `Virtualizer: duplicate key "{p2}"`)
		p.epoch = epoch
		p.entered = false
		p.changed = false
	end

	local function enterIndex(i: number)
		local itemKey = dataSource.getItemKey(i)
		local v26 = v4[itemKey]

		if v26 == nil then
			local item = dataSource.getItem(i)
			return enter(itemKey, i, item, data.getItemViewType(item, i)) -- inferred equivalent call
		end

		claim(v26, itemKey) -- inferred equivalent call
		v26.index = i
		v26.side = false
		return v26
	end

	local function reread(data2, changed: boolean)
		local index = data2.index

		if index == nil or data2.entered then
			return nil
		end

		local item = dataSource.getItem(index)
		local itemViewType = data.getItemViewType(item, index)

		if itemViewType == data2.viewType then
			table.insert(v20, {
				key = data2.key,
				value = item,
				viewType = itemViewType,
				changed = changed
			})

			return nil
		end

		return replace(data2, item, itemViewType) -- inferred equivalent call
	end

	local function restate(data2)
		local state = data2.state
		local itemLayout

		if state ~= nil then
			itemLayout = state.itemLayout
		end

		local v26 = v25[data2.key]
		local index = data2.index

		if index == nil then
			itemLayout = resolveLayout({
				startOffset = 0,
				length = v26 == nil and 0 or v26.mainAxisLength or 0
			}, itemLayout, true)
		elseif itemLayout == nil or v17 or state.index ~= index then
			if v24 == nil or not (v18 <= index and index <= v19) then
				itemLayout = resolveLayout(layout.getItemLayout(index), itemLayout)
			else
				itemLayout = resolveLayout(v24[index - v18 + 1], itemLayout, true)
			end
		end

		local v27 = frozen2
		local v28

		if not (v26 == nil and (state == nil or state.canvasPlacement == frozen2)) then
			v27, v28 = resolvePlacement(v26, v15, state)
		end

		if publish(data2, itemLayout, v27, v28, v16) then
			if data2.entered then
				records = table.isfrozen(records) and {} or records
				table.insert(records, data2.record)
			else
				records2 = table.isfrozen(records2) and {} or records2
				table.insert(records2, data2.record)
			end
		end
	end

	local keepReadyViewsAhead = FFlagViewRecyclerReact084 and function(items, p, p2: number)
		local v26 = isReadyOnAssignment

		local v27 = {}
		local v28 = {}

		for _, item in items do
			local index = item.index
			local v29

			if p2 > 0 and index < p.firstIndex then
				v29 = true
			elseif p2 < 0 then
				v29 = p.lastIndex < index
			else
				v29 = false
			end

			local v30 = index < p.firstIndex or p.lastIndex < index

			if v26(item.view) then
				if v29 or p2 == 0 and v30 then
					table.insert(v27, { row = item, distance = distanceFrom(p, item) })
				end
			elseif not v29 then
				table.insert(v28, { row = item, distance = distanceFrom(p, item) })
			end
		end

		if #v28 == 0 or #v27 == 0 then
			return
		end

		table.sort(v28, function(a, b): boolean
			return a.distance < b.distance
		end)

		table.sort(v27, function(a, b): boolean
			return a.distance > b.distance
		end)

		local set2 = {}

		for _, v29 in v28 do
			local row = v29.row

			for k, v30 in v27 do
				if not set2[k] and v30.row.viewType == row.viewType then
					if not (p2 ~= 0 or not (v30.distance <= v29.distance)) then
						break
					end

					set2[k] = true
					local row2 = v30.row
					local view = row.view
					row.view = row2.view
					row2.view = view
					v5[row.view] = row
					v5[row2.view] = row2
					row.entered = true
					row2.entered = true
					break
				end
			end
		end
	end or nil

	local function release()
		if not flag2 then
			return frozen3
		end

		if v3 and #v > 0 and not v11 then
			local v26 = table.create(#v)

			for k, v27 in v do
				v26[k] = v27.key
			end

			v13 = v26
			v14 = v6
		else
			v13 = nil
		end

		v11 = false
		local v26 = slotBinder.releaseAll()
		v = {}
		v2 = {}
		v3 = true
		v4 = {}
		v5 = {}
		flag2 = false
		v6 = frozen

		if FFlagViewRecyclerReact084 then
			v7 = nil
		end

		v10 = frozen4
		v9 = nil
		mountedViews = frozen3
		return v26
	end

	return {
		noteDataChange = noteDataChange,
		invalidateKeys = function()
			v11 = true
		end,
		invalidatePayloads = function()
			flag3 = true
		end,
		invalidateLayout = function()
			v12 = true
		end,
		apply = function(data2)
			if flag then
				return nil, nil
			end

			dataSource = data2.dataSource
			layout = data2.layout
			local plan = data2.plan or frozen4
			local mountedRange = data2.mountedRange
			v15 = data2.scrollOffset
			v16 = data2.contentStartOffset
			v17 = v12 or layout ~= v9
			local v26 = v16 ~= v8
			local v27 = not sameRange(mountedRange, v6) -- inferred equivalent call

			local v28 = next(set) ~= nil

			if flag2 and not v11 and not flag3 and not v17 and not v26 and not v27 and not v28 and plan == v10 then
				return nil, nil
			end

			count += 1
			epoch = count
			local itemCount = dataSource.getItemCount()
			v18 = mountedRange.firstIndex
			v19 = math.min(mountedRange.lastIndex, itemCount)
			local v29 = math.max(0, v19 - v18 + 1)
			local v30 = table.create(v29)
			local v31 = {}
			table.clear(v20)
			local v32 = {}
			table.clear(v21)
			count2 = 0
			local v34 = not flag2 or not v3 or v11
			local v35 = v34 or v17 or v26

			if v34 then
				local v36

				if not (v11 or flag2) then
					v36 = v13
				end

				for i = v18, v19 do
					local v37

					if v36 == nil or not (v14.firstIndex <= i and i <= v14.lastIndex) then
						v37 = dataSource.getItemKey(i)
					else
						v37 = v36[i - v14.firstIndex + 1]
					end

					local v38 = v4[v37]

					if v38 == nil then
						local item = dataSource.getItem(i)
						local v39 = i - v18 + 1
						v30[v39] = enter(v37, i, item, data.getItemViewType(item, i)) -- inferred equivalent call
					else
						claim(v38, v37) -- inferred equivalent call
						v38.index = i
						v38.side = false
						v30[i - v18 + 1] = v38
					end
				end

				for _, v37 in v4 do
					if v37.epoch ~= epoch then
						table.insert(v32, v37)
					end
				end
			else
				local firstIndex = v6.firstIndex
				local lastIndex = v6.lastIndex
				local v36 = math.max(firstIndex, v18)
				local v37 = math.min(lastIndex, v19)

				for i = firstIndex, math.min(lastIndex, v18 - 1) do
					table.insert(v32, v[i - firstIndex + 1])
				end

				for i = math.max(firstIndex, v19 + 1), lastIndex do
					table.insert(v32, v[i - firstIndex + 1])
				end

				for _, v38 in v2 do
					table.insert(v32, v38)
				end

				if v36 <= v37 then
					table.move(v, v36 - firstIndex + 1, v37 - firstIndex + 1, v36 - v18 + 1, v30)

					for i = v36 - v18 + 1, v37 - v18 + 1 do
						local v38 = v30[i]
						v38.epoch = epoch
						v38.entered = false
						v38.changed = false
					end
				end

				for i = v18, math.min(v19, v36 - 1) do
					v30[i - v18 + 1] = enterIndex(i)
				end

				for i = math.max(v18, v37 + 1), v19 do
					v30[i - v18 + 1] = enterIndex(i)
				end
			end

			for _, retainedItem in plan.retainedItems do
				if not (retainedItem.index < v18) then
					local index = retainedItem.index

					if not (v19 < index) then
						continue
					end
				end

				local v36 = v4[retainedItem.key]

				if v36 == nil then
					local item = dataSource.getItem(retainedItem.index)
					local v37 = enter( -- inferred equivalent call
						retainedItem.key,
						retainedItem.index,
						item,
						data.getItemViewType(item, retainedItem.index)
					)
					v37.side = true
					table.insert(v31, v37)
				else
					claim(v36, retainedItem.key) -- inferred equivalent call
					v36.index = retainedItem.index
					v36.side = true
					table.insert(v31, v36)
				end
			end

			for _, additionalItem in plan.additionalItems do
				local position = additionalItem.identity.position
				local pinnedItem = data.getPinnedItem(position)

				if not (pinnedItem ~= nil and pinnedItem.key == additionalItem.key) then
					continue
				end

				local v36 = v4[additionalItem.key]
				local v37

				if v36 == nil then
					v37 = {
						key = additionalItem.key,
						value = pinnedItem.value,
						viewType = pinnedItem.itemViewType,
						index = nil,
						side = false,
						epoch = epoch,
						entered = true,
						changed = true
					}
					count2 += 1
					table.insert(v20, v37)
				else
					claim(v36, additionalItem.key) -- inferred equivalent call

					if v36.viewType == pinnedItem.itemViewType then
						if v36.value ~= pinnedItem.value then
							table.insert(v20, {
								key = additionalItem.key,
								value = pinnedItem.value,
								viewType = pinnedItem.itemViewType
							})
						end

						v37 = v36
					else
						local value = pinnedItem.value
						local itemViewType = pinnedItem.itemViewType
						table.insert(v21, v36.key)
						v37 = {
							key = v36.key,
							value = value,
							viewType = itemViewType,
							index = v36.index,
							side = false,
							epoch = epoch,
							entered = true,
							changed = true
						}
						count2 += 1
						table.insert(v20, v37)

						v37.side = v36.side
					end
				end

				v37.index = nil
				v37.side = true
				v37.pinnedPosition = position
				v37.pinnedRevision = additionalItem.identity.revision
				table.insert(v31, v37)
			end

			if flag3 then
				for k, v36 in v30 do
					v30[k] = reread(v36, false) or v36
				end

				for k, v36 in v31 do
					v31[k] = reread(v36, false) or v36
				end
			elseif v28 then
				for k in set do
					local v36 = v4[k]

					if not (v36 ~= nil and v36.epoch == epoch) then
						continue
					end

					local v37 = reread(v36, true)

					if v37 == nil then
						continue
					end

					if v36.side then
						v31[table.find(v31, v36)] = v37
					else
						v30[v36.index - v18 + 1] = v37
					end
				end
			end

			for _, v36 in v32 do
				if v36.epoch ~= epoch then
					table.insert(v21, v36.key)
				end
			end

			local visibleRange

			if FFlagViewRecyclerReact084 then
				visibleRange = data2.visibleRange

				if visibleRange ~= nil and isReadyOnAssignment ~= nil and count2 > 1 then
					prioritizeSlots(v20, visibleRange, v22, v23)
				end
			end

			local v36 = slotBinder.apply(v21, v20)

			for _, v37 in v21 do
				local v38 = v4[v37]
				v4[v37] = nil
				v5[v38.view] = nil
			end

			for _, v37 in v36.entered do
				v4[v37.key] = v37
				v5[v37.view] = v37
			end

			for _, v37 in v36.updated do
				v37.changed = true
			end

			if FFlagViewRecyclerReact084 and visibleRange ~= nil and isReadyOnAssignment ~= nil then
				keepReadyViewsAhead(v30, visibleRange, v7 == nil and 0 or math.sign(v15 - v7))
			end

			local reassigned = #v21 - #v36.departed

			records = frozen3
			records2 = frozen3

			v24 = nil

			if v29 > 1 and layout.getItemLayouts ~= nil and (v35 and (v17 or not flag2) or v29 < count2 * 2) then
				local v38 = table.create(v29)
				layout.getItemLayouts(v18, v19, v38)
				v24 = v38
			end

			v25 = plan.placements
			local placements = v10.placements

			if v35 then
				for _, v38 in v30 do
					restate(v38)
				end
			else
				for _, v38 in v30 do
					if v38.entered or v38.changed then
						restate(v38)
					end
				end

				for k in v25 do
					local v38 = v4[k]

					if v38 == nil or (v38.side or v38.entered or v38.changed) then
						continue
					end

					restate(v38)
				end

				for k in placements do
					local v38 = v4[k]

					if not (v38 ~= nil and v25[k] == nil) then
						continue
					end

					if v38.side or v38.entered or v38.changed then
						continue
					end

					restate(v38)
				end
			end

			for _, v38 in v31 do
				restate(v38)
			end

			local v38 = #v30 ~= #v or (#v31 ~= #v2 or v27)

			if not v38 and v34 then
				for k, v40 in v30 do
					if v[k] ~= v40 then
						v38 = true
						break
					end
				end
			end

			if not v38 then
				for k, v40 in v31 do
					if v2[k] ~= v40 then
						v38 = true
						break
					end
				end
			end

			v = v30
			v2 = v31
			v3 = v29 == math.max(0, mountedRange.lastIndex - mountedRange.firstIndex + 1)
			flag2 = true
			v6 = mountedRange

			if FFlagViewRecyclerReact084 then
				v7 = v15
			end

			v8 = v16
			v9 = layout
			v10 = plan
			v11 = false
			flag3 = false
			v12 = false

			if v28 then
				table.clear(set)
			end

			v13 = nil

			local departed = v36.departed

			if not v38 and #records == 0 and #records2 == 0 and #departed == 0 then
				return nil, nil
			end

			local records3 = table.create(#v + #v2)

			for k, v39 in v do
				records3[k] = v39.record
			end

			local v39 = #v

			for k, v40 in v2 do
				records3[v39 + k] = v40.record
			end

			mountedViews = table.freeze(records3)
			local touched = #records + #records2 + #departed
			local v41 = { entered = records, updated = records2, departed = departed }

			if touched == 0 then
				return v41, nil
			end

			return v41, {
				kind = Diagnostics.EventKind.ItemViewsSynchronized,
				retained = #records3 - #records - #records2,
				reassigned = reassigned,
				acquired = #records - reassigned,
				released = #departed,
				touched = touched
			}
		end,
		release = release,
		destroy = function()
			if flag then
				return
			end

			release()
			v13 = nil
			slotBinder.destroy()
			flag = true
		end,
		isApplied = function()
			return flag2
		end,
		getMountedViews = function()
			return mountedViews
		end,
		validate = function(items)
			local count3 = 0
			local result = {}

			for _, item in items do
				local v26 = v5[item.itemView]
				local state = item.state

				if v26 ~= nil and measuresSameContent(v26.state, state) then -- inferred equivalent call
					table.insert(result, {
						index = v26.index,
						key = v26.key,
						pinnedPosition = v26.pinnedPosition,
						pinnedRevision = v26.pinnedRevision,
						length = item.length
					})
					continue
				end

				if state.index == nil or state.pinnedPosition ~= nil or v4[state.assignment.key] ~= nil then
					count3 += 1
				else
					table.insert(result, {
						index = state.index,
						key = state.assignment.key,
						length = item.length
					})
				end
			end

			return result, count3
		end
	}
end

return createListRows
