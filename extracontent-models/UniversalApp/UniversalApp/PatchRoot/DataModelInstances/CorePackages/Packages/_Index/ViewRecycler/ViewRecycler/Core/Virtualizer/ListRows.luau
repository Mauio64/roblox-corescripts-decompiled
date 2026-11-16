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

local function createListRows(data)
	local slotBinder = data.slotBinder
	local flag = false

	local v = {}
	local v2 = {}
	local v3 = true
	local v4 = {}
	local v5 = {}
	local flag2 = false
	local v6 = frozen
	local v7 = 0
	local v8 = nil
	local v9 = frozen4
	local count = 0
	local mountedViews = frozen3

	local v10 = false
	local flag3 = false
	local v11 = false
	local set = {}

	local v12 = nil
	local v13 = frozen

	local function knownRange() -- 3 equivalent calls inferred from this helper
		if flag2 then
			return v6
		end

		return if v12 == nil then frozen else v13
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
	local records = frozen3
	local records2 = frozen3
	local v22 = nil
	local v23 = {}

	local function enter(p: string, p2: number?, p3, viewType) -- 4 equivalent calls inferred from this helper
		local v14 = {
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
		table.insert(v20, v14)
		return v14
	end

	local function replace(data2, item, itemViewType) -- 1 equivalent call inferred from this helper
		table.insert(v21, data2.key)
		local v14 = enter(data2.key, data2.index, item, itemViewType) -- inferred equivalent call
		v14.side = data2.side
		return v14
	end

	local function claim(p, p2: string) -- 4 equivalent calls inferred from this helper
		assert(p.epoch ~= epoch, `Virtualizer: duplicate key "{p2}"`)
		p.epoch = epoch
		p.entered = false
		p.changed = false
	end

	local function enterIndex(i: number)
		local itemKey = dataSource.getItemKey(i)
		local v14 = v4[itemKey]

		if v14 == nil then
			local item = dataSource.getItem(i)
			return enter(itemKey, i, item, data.getItemViewType(item, i)) -- inferred equivalent call
		end

		claim(v14, itemKey) -- inferred equivalent call
		v14.index = i
		v14.side = false
		return v14
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

		local v14 = v23[data2.key]
		local index = data2.index

		if index == nil then
			itemLayout = resolveLayout({
				startOffset = 0,
				length = v14 == nil and 0 or v14.mainAxisLength or 0
			}, itemLayout, true)
		elseif itemLayout == nil or v17 or state.index ~= index then
			if v22 == nil or not (v18 <= index and index <= v19) then
				itemLayout = resolveLayout(layout.getItemLayout(index), itemLayout)
			else
				itemLayout = resolveLayout(v22[index - v18 + 1], itemLayout, true)
			end
		end

		local v24 = frozen2
		local v25

		if not (v14 == nil and (state == nil or state.canvasPlacement == frozen2)) then
			v24, v25 = resolvePlacement(v14, v15, state)
		end

		if publish(data2, itemLayout, v24, v25, v16) then
			if data2.entered then
				records = table.isfrozen(records) and {} or records
				table.insert(records, data2.record)
			else
				records2 = table.isfrozen(records2) and {} or records2
				table.insert(records2, data2.record)
			end
		end
	end

	local function release()
		if not flag2 then
			return frozen3
		end

		if v3 and #v > 0 and not v10 then
			local v14 = table.create(#v)

			for k, v24 in v do
				v14[k] = v24.key
			end

			v12 = v14
			v13 = v6
		else
			v12 = nil
		end

		v10 = false
		local v14 = slotBinder.releaseAll()
		v = {}
		v2 = {}
		v3 = true
		v4 = {}
		v5 = {}
		flag2 = false
		v6 = frozen
		v9 = frozen4
		v8 = nil
		mountedViews = frozen3
		return v14
	end

	return {
		noteDataChange = function(p)
			for _, change in p.changes do
				local kind = change.type

				if kind == DataSourceChangeType.Reset then
					v10 = true
					flag3 = true
				elseif kind == DataSourceChangeType.Reorder then
					v10 = true
				elseif kind == DataSourceChangeType.Update then
					for _, key in change.keys do
						set[key] = true
					end
				elseif kind == DataSourceChangeType.Insert then
					for _, key in change.keys do
						set[key] = true
					end

					local v14 = knownRange() -- inferred equivalent call

					if not v10 and not Types.isIndexRangeEmpty(v14) and change.index <= v14.lastIndex then
						v10 = true
					end
				elseif kind == DataSourceChangeType.Remove then
					local v14 = knownRange() -- inferred equivalent call

					if not v10 and not Types.isIndexRangeEmpty(v14) and change.index <= v14.lastIndex then
						v10 = true
					end
				elseif kind == DataSourceChangeType.Move then
					local v14 = knownRange() -- inferred equivalent call

					if
						not v10
						and not Types.isIndexRangeEmpty(v14)
						and math.min(change.fromIndex, change.toIndex) <= v14.lastIndex
						and math.max(change.fromIndex, change.toIndex) >= v14.firstIndex
					then
						v10 = true
					end
				end
			end
		end,
		invalidateKeys = function()
			v10 = true
		end,
		invalidatePayloads = function()
			flag3 = true
		end,
		invalidateLayout = function()
			v11 = true
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
			v17 = v11 or layout ~= v8
			local v14 = v16 ~= v7
			local v24 = not sameRange(mountedRange, v6) -- inferred equivalent call

			local v25 = next(set) ~= nil

			if flag2 and not v10 and not flag3 and not v17 and not v14 and not v24 and not v25 and plan == v9 then
				return nil, nil
			end

			count += 1
			epoch = count
			local itemCount = dataSource.getItemCount()
			v18 = mountedRange.firstIndex
			v19 = math.min(mountedRange.lastIndex, itemCount)
			local v26 = math.max(0, v19 - v18 + 1)
			local v27 = table.create(v26)
			local v28 = {}
			table.clear(v20)
			local v29 = {}
			table.clear(v21)
			count2 = 0
			local v30 = not flag2 or not v3 or v10
			local v31 = v30 or v17 or v14

			if v30 then
				local v32

				if not (v10 or flag2) then
					v32 = v12
				end

				for i = v18, v19 do
					local v34

					if v32 == nil or not (v13.firstIndex <= i and i <= v13.lastIndex) then
						v34 = dataSource.getItemKey(i)
					else
						v34 = v32[i - v13.firstIndex + 1]
					end

					local v35 = v4[v34]

					if v35 == nil then
						local item = dataSource.getItem(i)
						local v36 = i - v18 + 1
						v27[v36] = enter(v34, i, item, data.getItemViewType(item, i)) -- inferred equivalent call
					else
						claim(v35, v34) -- inferred equivalent call
						v35.index = i
						v35.side = false
						v27[i - v18 + 1] = v35
					end
				end

				for _, v34 in v4 do
					if v34.epoch ~= epoch then
						table.insert(v29, v34)
					end
				end
			else
				local firstIndex = v6.firstIndex
				local lastIndex = v6.lastIndex
				local v32 = math.max(firstIndex, v18)
				local v34 = math.min(lastIndex, v19)

				for i = firstIndex, math.min(lastIndex, v18 - 1) do
					table.insert(v29, v[i - firstIndex + 1])
				end

				for i = math.max(firstIndex, v19 + 1), lastIndex do
					table.insert(v29, v[i - firstIndex + 1])
				end

				for _, v35 in v2 do
					table.insert(v29, v35)
				end

				if v32 <= v34 then
					table.move(v, v32 - firstIndex + 1, v34 - firstIndex + 1, v32 - v18 + 1, v27)

					for i = v32 - v18 + 1, v34 - v18 + 1 do
						local v35 = v27[i]
						v35.epoch = epoch
						v35.entered = false
						v35.changed = false
					end
				end

				for i = v18, math.min(v19, v32 - 1) do
					v27[i - v18 + 1] = enterIndex(i)
				end

				for i = math.max(v18, v34 + 1), v19 do
					v27[i - v18 + 1] = enterIndex(i)
				end
			end

			for _, retainedItem in plan.retainedItems do
				if not (retainedItem.index < v18) then
					local index = retainedItem.index

					if not (v19 < index) then
						continue
					end
				end

				local v32 = v4[retainedItem.key]

				if v32 == nil then
					local item = dataSource.getItem(retainedItem.index)
					local v34 = enter( -- inferred equivalent call
						retainedItem.key,
						retainedItem.index,
						item,
						data.getItemViewType(item, retainedItem.index)
					)
					v34.side = true
					table.insert(v28, v34)
				else
					claim(v32, retainedItem.key) -- inferred equivalent call
					v32.index = retainedItem.index
					v32.side = true
					table.insert(v28, v32)
				end
			end

			for _, additionalItem in plan.additionalItems do
				local position = additionalItem.identity.position
				local pinnedItem = data.getPinnedItem(position)

				if not (pinnedItem ~= nil and pinnedItem.key == additionalItem.key) then
					continue
				end

				local v32 = v4[additionalItem.key]
				local v34

				if v32 == nil then
					v34 = {
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
					table.insert(v20, v34)
				else
					claim(v32, additionalItem.key) -- inferred equivalent call

					if v32.viewType == pinnedItem.itemViewType then
						if v32.value ~= pinnedItem.value then
							table.insert(v20, {
								key = additionalItem.key,
								value = pinnedItem.value,
								viewType = pinnedItem.itemViewType
							})
						end

						v34 = v32
					else
						local value = pinnedItem.value
						local itemViewType = pinnedItem.itemViewType
						table.insert(v21, v32.key)
						v34 = {
							key = v32.key,
							value = value,
							viewType = itemViewType,
							index = v32.index,
							side = false,
							epoch = epoch,
							entered = true,
							changed = true
						}
						count2 += 1
						table.insert(v20, v34)

						v34.side = v32.side
					end
				end

				v34.index = nil
				v34.side = true
				v34.pinnedPosition = position
				v34.pinnedRevision = additionalItem.identity.revision
				table.insert(v28, v34)
			end

			if flag3 then
				for k, v32 in v27 do
					v27[k] = reread(v32, false) or v32
				end

				for k, v32 in v28 do
					v28[k] = reread(v32, false) or v32
				end
			elseif v25 then
				for k in set do
					local v32 = v4[k]

					if not (v32 ~= nil and v32.epoch == epoch) then
						continue
					end

					local v34 = reread(v32, true)

					if v34 == nil then
						continue
					end

					if v32.side then
						v28[table.find(v28, v32)] = v34
					else
						v27[v32.index - v18 + 1] = v34
					end
				end
			end

			for _, v32 in v29 do
				if v32.epoch ~= epoch then
					table.insert(v21, v32.key)
				end
			end

			local v32 = slotBinder.apply(v21, v20)

			for _, v34 in v21 do
				local v35 = v4[v34]
				v4[v34] = nil
				v5[v35.view] = nil
			end

			for _, v34 in v32.entered do
				v4[v34.key] = v34
				v5[v34.view] = v34
			end

			for _, v34 in v32.updated do
				v34.changed = true
			end

			local reassigned = #v21 - #v32.departed

			records = frozen3
			records2 = frozen3

			v22 = nil

			if v26 > 1 and layout.getItemLayouts ~= nil and (v31 and (v17 or not flag2) or v26 < count2 * 2) then
				local v35 = table.create(v26)
				layout.getItemLayouts(v18, v19, v35)
				v22 = v35
			end

			v23 = plan.placements
			local placements = v9.placements

			if v31 then
				for _, v35 in v27 do
					restate(v35)
				end
			else
				for _, v35 in v27 do
					if v35.entered or v35.changed then
						restate(v35)
					end
				end

				for k in v23 do
					local v35 = v4[k]

					if v35 == nil or (v35.side or v35.entered or v35.changed) then
						continue
					end

					restate(v35)
				end

				for k in placements do
					local v35 = v4[k]

					if not (v35 ~= nil and v23[k] == nil) then
						continue
					end

					if v35.side or v35.entered or v35.changed then
						continue
					end

					restate(v35)
				end
			end

			for _, v35 in v28 do
				restate(v35)
			end

			local v35 = #v27 ~= #v or (#v28 ~= #v2 or v24)

			if not v35 and v30 then
				for k, v37 in v27 do
					if v[k] ~= v37 then
						v35 = true
						break
					end
				end
			end

			if not v35 then
				for k, v37 in v28 do
					if v2[k] ~= v37 then
						v35 = true
						break
					end
				end
			end

			v = v27
			v2 = v28
			v3 = v26 == math.max(0, mountedRange.lastIndex - mountedRange.firstIndex + 1)
			flag2 = true
			v6 = mountedRange
			v7 = v16
			v8 = layout
			v9 = plan
			v10 = false
			flag3 = false
			v11 = false

			if v25 then
				table.clear(set)
			end

			v12 = nil

			local departed = v32.departed

			if not v35 and #records == 0 and #records2 == 0 and #departed == 0 then
				return nil, nil
			end

			local records3 = table.create(#v + #v2)

			for k, v36 in v do
				records3[k] = v36.record
			end

			local v36 = #v

			for k, v37 in v2 do
				records3[v36 + k] = v37.record
			end

			mountedViews = table.freeze(records3)
			local touched = #records + #records2 + #departed
			local v38 = { entered = records, updated = records2, departed = departed }

			if touched == 0 then
				return v38, nil
			end

			return v38, {
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
			v12 = nil
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
				local v14 = v5[item.itemView]
				local state = item.state

				if v14 ~= nil and measuresSameContent(v14.state, state) then -- inferred equivalent call
					table.insert(result, {
						index = v14.index,
						key = v14.key,
						pinnedPosition = v14.pinnedPosition,
						pinnedRevision = v14.pinnedRevision,
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
