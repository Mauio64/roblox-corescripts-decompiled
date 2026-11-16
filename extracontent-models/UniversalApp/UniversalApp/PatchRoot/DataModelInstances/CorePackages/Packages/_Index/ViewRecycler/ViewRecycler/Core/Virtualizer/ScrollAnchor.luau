local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AutoScrollPolicy = require(ViewRecycler.Core.Enums.AutoScrollPolicy)
local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)
local Diagnostics = require(ViewRecycler.Core.Diagnostics)
require(ViewRecycler.Core.Virtualizer.ItemSequence)

local ReachedThreshold = require(ViewRecycler.Core.ViewportBehavior.ReachedThreshold)
local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)
local Types = require(ViewRecycler.Core.Types)
require(ViewRecycler.Core.Virtualizer.Viewport)
local v, followedEdge, validate

if FFlagViewRecyclerReact08 then
	v = 1

	followedEdge = function(p)
		if p == AutoScrollPolicy.WhenAtStart then
			return ScrollAlignment.Start
		end

		if p == AutoScrollPolicy.WhenAtEnd then
			return ScrollAlignment.End
		end

		return nil
	end

	validate = function(data)
		local initialScrollAlignment = data.initialScrollAlignment
		assert(
			initialScrollAlignment == nil or initialScrollAlignment == ScrollAlignment.Start or initialScrollAlignment == ScrollAlignment.End,
			"Virtualizer: initialScrollAlignment must be ScrollAlignment.Start or ScrollAlignment.End"
		)

		assert(
			data.autoScrollOnChange == nil or followedEdge(data.autoScrollOnChange) ~= nil,
			"Virtualizer: autoScrollOnChange must be AutoScrollPolicy.WhenAtStart or AutoScrollPolicy.WhenAtEnd"
		)

		if data.autoScrollThreshold ~= nil then
			ReachedThreshold.validate(data.autoScrollThreshold, "Virtualizer: autoScrollThreshold")
		end
	end
else
	validate = nil
	v = nil
	followedEdge = nil
end

local function projectIndex(indexHint: number?, change)
	if indexHint == nil or change.type == DataSourceChangeType.Reset or change.type == DataSourceChangeType.Reorder then
		return nil
	end

	if change.type == DataSourceChangeType.Insert then
		if change.index <= indexHint then
			return indexHint + #change.keys
		end

		return indexHint
	elseif change.type == DataSourceChangeType.Remove then
		if indexHint < change.index then
			return indexHint
		end

		if change.index + #change.keys <= indexHint then
			return indexHint - #change.keys
		end

		return nil
	else
		if change.type ~= DataSourceChangeType.Move then
			return indexHint
		end

		if indexHint == change.fromIndex then
			return change.toIndex
		end

		if change.fromIndex < indexHint and indexHint <= change.toIndex then
			return indexHint - 1
		end

		if change.toIndex <= indexHint and indexHint < change.fromIndex then
			return indexHint + 1
		end

		return indexHint
	end
end

local function createScrollAnchor(data)
	local viewport = data.viewport
	local isLaidOut, v2

	if FFlagViewRecyclerReact08 then
		isLaidOut = data.isLaidOut
		v2 = data.config
		validate(v2)
	else
		v2 = nil
		isLaidOut = nil
	end

	local v3 = nil
	local v4, v5, v6, hasItems, distanceFrom, edgeOffset, followThreshold, hold, holdsItemTarget, edgeHolds, opensAtInitialEdge, observe

	if FFlagViewRecyclerReact08 then
		v4 = nil
		v5 = false

		v6 = true

		hasItems = function(): boolean
			return data.getItemSequence().getItemCount() > 0
		end

		distanceFrom = function(p)
			local scrollOffset = viewport.getScrollOffset()

			if p == ScrollAlignment.Start then
				return scrollOffset
			end

			return (math.max(0, viewport.getContentLength() - viewport.getLength() - scrollOffset))
		end

		edgeOffset = function(p)
			if p == ScrollAlignment.Start then
				return 0
			end

			return (math.max(0, viewport.getContentLength() - viewport.getLength()))
		end

		followThreshold = function()
			return ReachedThreshold.resolve(v2.autoScrollThreshold, viewport.getLength(), v)
		end

		hold = function(p)
			v5 = v5 and p == v4
			v4 = p
		end

		holdsItemTarget = function(): boolean
			return v3 ~= nil and v3.kind == "itemTarget"
		end

		edgeHolds = function(): boolean
			return v4 ~= nil and not holdsItemTarget()
		end

		opensAtInitialEdge = function()
			local v7 = v6

			if v7 then
				if v2.initialScrollAlignment == nil then
					return false
				end

				return hasItems() and isLaidOut()
			end

			return v7
		end

		observe = function()
			local v7 = followThreshold()

			if v4 ~= nil and distanceFrom(v4) <= v7 then
				return
			end

			local v8 = followedEdge(v2.autoScrollOnChange)
			local v9 = hold

			if v8 == nil or not (distanceFrom(v8) <= v7) then
				v8 = nil
			end

			v9(v8)
		end
	else
		holdsItemTarget = nil
		v6 = nil
		v4 = nil
		v5 = nil
		distanceFrom = nil
		followThreshold = nil
		opensAtInitialEdge = nil
		hold = nil
		edgeHolds = nil
		hasItems = nil
		edgeOffset = nil
		observe = nil
	end

	local function findKeyIndex(p: string, p2: number?)
		local itemSequence = data.getItemSequence()
		local itemCount = itemSequence.getItemCount()

		if p2 ~= nil and p2 >= 1 and p2 <= itemCount and itemSequence.getItemKey(p2) == p then
			return p2
		end

		for i = 1, itemCount do
			if itemSequence.getItemKey(i) == p then
				return i
			end
		end

		return nil
	end

	local function captureViewport(scrollOffset: number, value: number?)
		local itemSequence = data.getItemSequence()
		local itemCount = itemSequence.getItemCount()
		local length = viewport.getLength()

		if itemCount == 0 or length <= 0 then
			return nil
		end

		if value == nil then
			local visibleRangeAt = viewport.visibleRangeAt(scrollOffset, scrollOffset + length)

			if Types.isIndexRangeEmpty(visibleRangeAt) then
				return nil
			end

			value = visibleRangeAt.firstIndex

			local isItemMeasured = viewport.getLayout().isItemMeasured

			if isItemMeasured ~= nil then
				for i = visibleRangeAt.firstIndex, math.min(visibleRangeAt.lastIndex, itemCount) do
					if isItemMeasured(i) then
						value = i
						break
					end
				end
			end
		end

		local indexHint = math.clamp(value, 1, itemCount)
		local placedItemLayout = viewport.placedItemLayout(indexHint)
		return {
			kind = "viewport",
			key = itemSequence.getItemKey(indexHint),
			indexHint = indexHint,
			viewportCoordinate = placedItemLayout.startOffset - scrollOffset,
			itemLength = placedItemLayout.length,
			scrollOffset = scrollOffset,
			viewportLength = length
		}
	end

	local function captureEvidence()
		local scrollOffset = viewport.getScrollOffset()
		local length = viewport.getLength()
		local visibleRange = viewport.getVisibleRange()

		if Types.isIndexRangeEmpty(visibleRange) then
			return nil
		end

		local itemSequence = data.getItemSequence()
		local itemCount = itemSequence.getItemCount()
		local items = {}

		for i = visibleRange.firstIndex, math.min(visibleRange.lastIndex, itemCount) do
			local placedItemLayout = viewport.placedItemLayout(i)
			table.insert(items, {
				key = itemSequence.getItemKey(i),
				viewportCoordinate = placedItemLayout.startOffset - scrollOffset,
				itemLength = placedItemLayout.length
			})
		end

		return { scrollOffset = scrollOffset, viewportLength = length, items = items }
	end

	local function prepareDataChange(p, data2)
		local v7 = v3

		if v7 == nil then
			return
		end

		local indexHint = v7.indexHint

		for _, change in p.changes do
			indexHint = projectIndex(indexHint, change)
		end

		v7.indexHint = indexHint

		if v7.kind == "itemTarget" or findKeyIndex(v7.key, indexHint) ~= nil then
			return
		end

		if data2 ~= nil and data2.viewportLength > 0 then
			for _, item in data2.items do
				local key = item.key
				local itemSequence = data.getItemSequence()
				local indexHint2 = nil

				for i = 1, itemSequence.getItemCount() do
					if itemSequence.getItemKey(i) == key then
						indexHint2 = i
						break
					end
				end

				if indexHint2 ~= nil then
					v3 = {
						kind = "viewport",
						key = item.key,
						indexHint = indexHint2,
						viewportCoordinate = item.viewportCoordinate,
						itemLength = item.itemLength,
						scrollOffset = data2.scrollOffset,
						viewportLength = data2.viewportLength
					}

					return
				end
			end
		end

		v3 = nil
	end

	local function resolve(data2)
		local v7 = v3

		if v7 == nil then
			v3 = captureViewport(viewport.getScrollOffset(), nil)
			return nil
		end

		local keyIndex = findKeyIndex(v7.key, v7.indexHint)

		if keyIndex == nil then
			v3 = captureViewport(viewport.getScrollOffset(), nil)
			return nil
		end

		local source = data2.source
		local scrollOffset = viewport.getScrollOffset()
		local v8

		if v7.kind == "itemTarget" then
			v7.indexHint = keyIndex
			source = Diagnostics.ScrollCorrectionSource.ProgrammaticScroll
			v8 = viewport.offsetForItem(keyIndex, v7.alignment) - scrollOffset
		else
			local v9

			if FFlagViewRecyclerReact08 then
				v9 = v2.preserveScrollPositionOnChange
			else
				v9 = data.shouldPreserveUserPosition()
			end

			if not v9 then
				v3 = captureViewport(scrollOffset, nil)
				return nil
			end

			v7.indexHint = keyIndex
			local v10 = viewport.placedItemLayout(keyIndex).startOffset - scrollOffset
			local startInsetDelta = data2.startInsetDelta or 0
			v8 = v10 - v7.viewportCoordinate - startInsetDelta

			if data2.preserveStartAnchor and scrollOffset > 0 then
				v8 += startInsetDelta
			end
		end

		local delta = viewport.clamp(scrollOffset + v8) - scrollOffset

		if v7.kind == "viewport" then
			local scrollOffset2 = scrollOffset + (math.abs(delta) < 1 and 0 or delta)
			local placedItemLayout = viewport.placedItemLayout(keyIndex)
			local viewportCoordinate = placedItemLayout.startOffset - scrollOffset2
			local length = viewport.getLength()

			if viewportCoordinate < length and viewportCoordinate + placedItemLayout.length > 0 then
				v3 = {
					kind = "viewport",
					key = v7.key,
					indexHint = keyIndex,
					viewportCoordinate = viewportCoordinate,
					itemLength = placedItemLayout.length,
					scrollOffset = scrollOffset2,
					viewportLength = length
				}
			else
				v3 = captureViewport(scrollOffset2, nil)
			end
		end

		if math.abs(delta) < 1 then
			return nil
		end

		return { delta = delta, source = source }
	end

	return {
		configure = FFlagViewRecyclerReact08 and function(p)
			validate(p)
			v2 = p
		end or nil,
		setItemTarget = function(value, p)
			local itemSequence = data.getItemSequence()
			local itemCount = itemSequence.getItemCount()

			if itemCount == 0 then
				v3 = nil
				return
			end

			local indexHint = math.clamp(value, 1, itemCount)
			v3 = {
				kind = "itemTarget",
				key = itemSequence.getItemKey(indexHint),
				indexHint = indexHint,
				alignment = p or ScrollAlignment.Start
			}
		end,
		setViewport = function(scrollOffset: number)
			local v7 = v3

			if v7 ~= nil and v7.kind == "viewport" then
				local viewportCoordinate = v7.viewportCoordinate - (scrollOffset - v7.scrollOffset)

				if viewportCoordinate < v7.viewportLength and viewportCoordinate + v7.itemLength > 0 then
					v7.viewportCoordinate = viewportCoordinate
					v7.scrollOffset = scrollOffset
					return
				end
			end

			v3 = captureViewport(scrollOffset, nil)
		end,
		observeHost = function(scrollOffset)
			local v7

			if FFlagViewRecyclerReact08 then
				v7 = not holdsItemTarget()
			else
				v7 = v3 == nil or v3.kind == "viewport"
			end

			if v7 then
				local v8 = v3

				if v8 ~= nil and v8.kind == "viewport" then
					local viewportCoordinate = v8.viewportCoordinate - (scrollOffset - v8.scrollOffset)

					if viewportCoordinate < v8.viewportLength and viewportCoordinate + v8.itemLength > 0 then
						v8.viewportCoordinate = viewportCoordinate
						v8.scrollOffset = scrollOffset
						return
					end
				end

				v3 = captureViewport(scrollOffset, nil)
			end
		end,
		scrolledProgrammatically = FFlagViewRecyclerReact08 and function(p)
			v6 = false

			if p ~= nil then
				v4 = p
				v5 = true
			end
		end or nil,
		restore = function(p, scrollOffset)
			local v7

			if p.anchorKey ~= nil then
				v7 = findKeyIndex(p.anchorKey, p.anchorIndex)
			end

			v3 = captureViewport(scrollOffset, v7)
		end,
		snapshotOffset = function(data2)
			if data2.anchorKey ~= nil then
				local keyIndex = findKeyIndex(data2.anchorKey, data2.anchorIndex)

				if keyIndex ~= nil then
					return viewport.placedItemLayout(keyIndex).startOffset + data2.offsetWithinItem
				end
			end

			return data2.fallbackScrollOffset
		end,
		preserve = function(p, callback)
			local dataSourceChange, v7, v8

			if FFlagViewRecyclerReact08 then
				dataSourceChange = p.dataSourceChange
				v7 = followedEdge(v2.autoScrollOnChange)

				if dataSourceChange == nil or v7 == nil then
					v8 = false
				else
					v8 = distanceFrom(v7) <= followThreshold()
				end
			end

			local v9

			if FFlagViewRecyclerReact08 then
				v9 = dataSourceChange
			else
				v9 = p.dataSourceChange
			end

			if v9 ~= nil then
				local v10

				if FFlagViewRecyclerReact08 then
					v10 = dataSourceChange
				else
					v10 = p.dataSourceChange
				end

				prepareDataChange(v10, captureEvidence())
			end

			callback()

			if not FFlagViewRecyclerReact08 then
				return resolve(p)
			end

			if dataSourceChange ~= nil and not (holdsItemTarget() or opensAtInitialEdge()) then
				if v8 then
					hold(v7)
				elseif not v5 then
					hold(nil)
				end
			end

			local v10 = resolve(p)

			if v10 == nil or not (edgeHolds() or opensAtInitialEdge()) then
				return v10
			end

			local scrollOffset = viewport.getScrollOffset()
			local v11 = v3

			if v11 == nil or v11.kind ~= "viewport" then
				v3 = captureViewport(scrollOffset, nil)
			else
				local viewportCoordinate = v11.viewportCoordinate - (scrollOffset - v11.scrollOffset)

				if viewportCoordinate < v11.viewportLength and viewportCoordinate + v11.itemLength > 0 then
					v11.viewportCoordinate = viewportCoordinate
					v11.scrollOffset = scrollOffset
				else
					v3 = captureViewport(scrollOffset, nil)
				end
			end

			return nil
		end,
		settle = FFlagViewRecyclerReact08 and function(data2, callback)
			if v6 and hasItems() and isLaidOut() then
				v6 = false

				local initialScrollAlignment = v2.initialScrollAlignment

				if initialScrollAlignment ~= nil then
					hold(initialScrollAlignment)
					callback(edgeOffset(initialScrollAlignment))
					return
				end
			end

			local v7 = v4

			if data2.dataChange == nil then
				local laidOut = isLaidOut()
				local v8

				if data2.contentLengthChanged and v7 ~= nil and edgeHolds() then
					v8 = edgeOffset(v7)
				end

				local v9 = data2.replaced and 0 or v8

				if data2.viewportChanged then
					local keptDistanceFromEnd = data2.keptDistanceFromEnd

					if laidOut and v7 ~= nil and edgeHolds() then
						v9 = edgeOffset(v7)
					elseif keptDistanceFromEnd ~= nil and not holdsItemTarget() then
						v9 = viewport.getContentLength() - viewport.getLength() - keptDistanceFromEnd
					end
				end

				if v9 ~= nil then
					callback(v9)
				end

				if laidOut and (data2.replaced or data2.viewportChanged or data2.scrollMoved) then
					observe()
				end
			elseif v7 ~= nil and edgeHolds() then
				callback(edgeOffset(v7))
			end
		end or nil,
		getAnchoredItem = function()
			local v7 = v3
			local v8

			if FFlagViewRecyclerReact08 then
				if v7 == nil then
					v8 = false
				else
					v8 = v7.kind == "itemTarget"
				end
			elseif v7 == nil then
				v8 = true
			elseif v7.kind == "viewport" then
				v8 = not data.shouldPreserveUserPosition()
			else
				v8 = false
			end

			if v8 then
				local indexHint

				if FFlagViewRecyclerReact08 then
					indexHint = v7.indexHint
				end

				if not (FFlagViewRecyclerReact08 and indexHint ~= nil) then
					return nil
				end

				return (table.freeze({ index = indexHint, alignment = v7.alignment }))
			else
				if FFlagViewRecyclerReact08 then
					local alignment = v4

					if viewport.getContentLength() <= viewport.getLength() then
						local contentAlignment = viewport.getContentAlignment()

						if contentAlignment == ScrollAlignment.Start then
							alignment = ScrollAlignment.Start
						elseif contentAlignment == ScrollAlignment.End then
							alignment = ScrollAlignment.End
						end
					end

					if alignment == nil then
						if v7 == nil or not v2.preserveScrollPositionOnChange then
							return nil
						end
					else
						local itemCount = data.getItemSequence().getItemCount()

						if itemCount == 0 then
							return nil
						end

						return table.freeze({
							index = alignment == ScrollAlignment.Start and 1 or itemCount,
							alignment = alignment
						})
					end
				end

				local indexHint = v7.indexHint

				if FFlagViewRecyclerReact08 then
					if indexHint == nil then
						return nil
					end

					return (table.freeze({ index = indexHint, alignment = ScrollAlignment.Start }))
				else
					if indexHint == nil then
						return nil
					end

					local alignment

					if v7.kind == "itemTarget" then
						alignment = v7.alignment
					else
						alignment = ScrollAlignment.Start
					end

					return table.freeze({ index = indexHint, alignment = alignment })
				end
			end
		end,
		dataSourceReplaced = FFlagViewRecyclerReact08 and function()
			v3 = nil
			v4 = nil
			v5 = false
			v6 = true
		end or nil,
		reset = function()
			v3 = nil
		end,
		allowsPolicyOffset = not FFlagViewRecyclerReact08 and function(): boolean
			return v3 == nil or v3.kind == "viewport"
		end or nil
	}
end

return createScrollAnchor
