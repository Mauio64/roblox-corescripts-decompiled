local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
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

if FFlagViewRecyclerReact084 then
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
elseif FFlagViewRecyclerReact08 then
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

	if FFlagViewRecyclerReact084 then
		isLaidOut = data.isLaidOut
		v2 = data.config
		validate(v2)
	elseif FFlagViewRecyclerReact08 then
		isLaidOut = data.isLaidOut
		v2 = data.config
		validate(v2)
	else
		v2 = nil
		isLaidOut = nil
	end

	local v3 = nil

	local v4 = nil
	local v5, v6, v7, hasItems, distanceFrom, edgeOffset, followThreshold, hold, holdsItemTarget, edgeHolds, opensAtInitialEdge, observe

	if FFlagViewRecyclerReact084 then
		v5 = nil
		v6 = false

		v7 = true
		v4 = false

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
			v6 = v6 and p == v5
			v5 = p
		end

		holdsItemTarget = function(): boolean
			return v3 ~= nil and v3.kind == "itemTarget"
		end

		edgeHolds = function(): boolean
			return v5 ~= nil and not holdsItemTarget()
		end

		opensAtInitialEdge = function()
			local v8 = v7

			if v8 then
				if v2.initialScrollAlignment == nil then
					return false
				end

				return hasItems() and isLaidOut()
			end

			return v8
		end

		observe = function()
			local v8 = followThreshold()

			if v5 ~= nil and distanceFrom(v5) <= v8 then
				return
			end

			local v9 = followedEdge(v2.autoScrollOnChange)
			local v10 = hold

			if v9 == nil or not (distanceFrom(v9) <= v8) then
				v9 = nil
			end

			v10(v9)
		end
	elseif FFlagViewRecyclerReact08 then
		v5 = nil
		v6 = false

		v7 = true

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
			v6 = v6 and p == v5
			v5 = p
		end

		holdsItemTarget = function(): boolean
			return v3 ~= nil and v3.kind == "itemTarget"
		end

		edgeHolds = function(): boolean
			return v5 ~= nil and not holdsItemTarget()
		end

		opensAtInitialEdge = function()
			local v8 = v7

			if v8 then
				if v2.initialScrollAlignment == nil then
					return false
				end

				return hasItems() and isLaidOut()
			end

			return v8
		end

		observe = function()
			local v8 = followThreshold()

			if v5 ~= nil and distanceFrom(v5) <= v8 then
				return
			end

			local v9 = followedEdge(v2.autoScrollOnChange)
			local v10 = hold

			if v9 == nil or not (distanceFrom(v9) <= v8) then
				v9 = nil
			end

			v10(v9)
		end
	else
		holdsItemTarget = nil
		v7 = nil
		v5 = nil
		v6 = nil
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
		local v8 = v3

		if v8 == nil then
			return
		end

		local indexHint = v8.indexHint

		for _, change in p.changes do
			indexHint = projectIndex(indexHint, change)
		end

		v8.indexHint = indexHint

		if v8.kind == "itemTarget" or findKeyIndex(v8.key, indexHint) ~= nil then
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
		local v8 = v3

		if v8 == nil then
			v3 = captureViewport(viewport.getScrollOffset(), nil)
			return nil
		end

		local keyIndex = findKeyIndex(v8.key, v8.indexHint)

		if keyIndex == nil then
			v3 = captureViewport(viewport.getScrollOffset(), nil)
			return nil
		end

		local source = data2.source
		local scrollOffset = viewport.getScrollOffset()
		local v9

		if v8.kind == "itemTarget" then
			v8.indexHint = keyIndex
			source = Diagnostics.ScrollCorrectionSource.ProgrammaticScroll
			v9 = viewport.offsetForItem(keyIndex, v8.alignment) - scrollOffset
		else
			local v10

			if FFlagViewRecyclerReact084 then
				v10 = v2.preserveScrollPositionOnChange
			elseif FFlagViewRecyclerReact08 then
				v10 = v2.preserveScrollPositionOnChange
			else
				v10 = data.shouldPreserveUserPosition()
			end

			if not v10 then
				v3 = captureViewport(scrollOffset, nil)
				return nil
			end

			v8.indexHint = keyIndex
			local v11 = viewport.placedItemLayout(keyIndex).startOffset - scrollOffset
			local startInsetDelta = data2.startInsetDelta or 0
			v9 = v11 - v8.viewportCoordinate - startInsetDelta

			if data2.preserveStartAnchor and scrollOffset > 0 then
				v9 += startInsetDelta
			end
		end

		local delta = viewport.clamp(scrollOffset + v9) - scrollOffset

		if v8.kind == "viewport" then
			local scrollOffset2 = scrollOffset + (math.abs(delta) < 1 and 0 or delta)
			local placedItemLayout = viewport.placedItemLayout(keyIndex)
			local viewportCoordinate = placedItemLayout.startOffset - scrollOffset2
			local length = viewport.getLength()

			if viewportCoordinate < length and viewportCoordinate + placedItemLayout.length > 0 then
				v3 = {
					kind = "viewport",
					key = v8.key,
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

	local function setViewport(scrollOffset: number)
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

	local configure

	if FFlagViewRecyclerReact084 then
		configure = function(p)
			validate(p)
			v2 = p
		end
	else
		configure = FFlagViewRecyclerReact08 and function(p)
			validate(p)
			v2 = p
		end or nil
	end

	local scrollAnchor = {
		configure = configure,
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
		setViewport = setViewport,
		observeHost = function(scrollOffset)
			local v8

			if FFlagViewRecyclerReact084 then
				v8 = not holdsItemTarget()
			elseif FFlagViewRecyclerReact08 then
				v8 = not holdsItemTarget()
			else
				v8 = v3 == nil or v3.kind == "viewport"
			end

			if v8 then
				local v9 = v3

				if v9 ~= nil and v9.kind == "viewport" then
					local viewportCoordinate = v9.viewportCoordinate - (scrollOffset - v9.scrollOffset)

					if viewportCoordinate < v9.viewportLength and viewportCoordinate + v9.itemLength > 0 then
						v9.viewportCoordinate = viewportCoordinate
						v9.scrollOffset = scrollOffset
						return
					end
				end

				v3 = captureViewport(scrollOffset, nil)
			end
		end,
		scrolledProgrammatically = 0,
		beginMotion = 0,
		endMotion = 0,
		restore = 0,
		snapshotOffset = 0,
		preserve = 0,
		settle = 0,
		getAnchoredItem = 0,
		dataSourceReplaced = 0,
		reset = 0,
		allowsPolicyOffset = 0
	}
	local scrolledProgrammatically

	if FFlagViewRecyclerReact084 then
		scrolledProgrammatically = function(p)
			v7 = false

			if p ~= nil then
				v5 = p
				v6 = true
			end
		end
	else
		scrolledProgrammatically = FFlagViewRecyclerReact08 and function(p)
			v7 = false

			if p ~= nil then
				v5 = p
				v6 = true
			end
		end or nil
	end

	scrollAnchor.scrolledProgrammatically = scrolledProgrammatically

	scrollAnchor.beginMotion = FFlagViewRecyclerReact084 and function()
		v7 = false
		v5 = nil
		v6 = false
		v4 = true

		if holdsItemTarget() then
			v3 = captureViewport(viewport.getScrollOffset(), nil)
		end
	end or nil

	scrollAnchor.endMotion = FFlagViewRecyclerReact084 and function()
		v4 = false
	end or nil

	function scrollAnchor.restore(p, scrollOffset)
		local v8

		if p.anchorKey ~= nil then
			v8 = findKeyIndex(p.anchorKey, p.anchorIndex)
		end

		v3 = captureViewport(scrollOffset, v8)
	end
	function scrollAnchor.snapshotOffset(data2)
		if data2.anchorKey ~= nil then
			local keyIndex = findKeyIndex(data2.anchorKey, data2.anchorIndex)

			if keyIndex ~= nil then
				return viewport.placedItemLayout(keyIndex).startOffset + data2.offsetWithinItem
			end
		end

		return data2.fallbackScrollOffset
	end

	function scrollAnchor.preserve(p, callback)
		local dataSourceChange, v8, v9

		if FFlagViewRecyclerReact084 then
			dataSourceChange = p.dataSourceChange
			v8 = followedEdge(v2.autoScrollOnChange)

			if dataSourceChange == nil then
				v9 = false
			else
				v9 = not v4

				if v9 then
					if v8 == nil then
						v9 = false
					else
						v9 = distanceFrom(v8) <= followThreshold()
					end
				end
			end
		elseif FFlagViewRecyclerReact08 then
			dataSourceChange = p.dataSourceChange
			v8 = followedEdge(v2.autoScrollOnChange)

			if dataSourceChange == nil or v8 == nil then
				v9 = false
			else
				v9 = distanceFrom(v8) <= followThreshold()
			end
		end

		local v10

		if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
			v10 = dataSourceChange
		else
			v10 = p.dataSourceChange
		end

		if v10 ~= nil then
			local v11

			if FFlagViewRecyclerReact084 or FFlagViewRecyclerReact08 then
				v11 = dataSourceChange
			else
				v11 = p.dataSourceChange
			end

			prepareDataChange(v11, captureEvidence())
		end

		callback()

		if not FFlagViewRecyclerReact084 and not FFlagViewRecyclerReact08 then
			return resolve(p)
		end

		if dataSourceChange ~= nil and not (holdsItemTarget() or opensAtInitialEdge()) then
			if v9 then
				hold(v8)
			elseif not v6 then
				hold(nil)
			end
		end

		local v11 = resolve(p)

		if v11 == nil or not (edgeHolds() or opensAtInitialEdge()) then
			return v11
		end

		local scrollOffset = viewport.getScrollOffset()
		local v12 = v3

		if v12 == nil or v12.kind ~= "viewport" then
			v3 = captureViewport(scrollOffset, nil)
		else
			local viewportCoordinate = v12.viewportCoordinate - (scrollOffset - v12.scrollOffset)

			if viewportCoordinate < v12.viewportLength and viewportCoordinate + v12.itemLength > 0 then
				v12.viewportCoordinate = viewportCoordinate
				v12.scrollOffset = scrollOffset
			else
				v3 = captureViewport(scrollOffset, nil)
			end
		end

		return nil
	end

	local settle

	if FFlagViewRecyclerReact084 then
		settle = function(data2, callback)
			if v7 and hasItems() and isLaidOut() then
				v7 = false

				local initialScrollAlignment = v2.initialScrollAlignment

				if initialScrollAlignment ~= nil then
					hold(initialScrollAlignment)
					callback(edgeOffset(initialScrollAlignment))
					return
				end
			end

			local v8 = v5

			if data2.dataChange == nil then
				local laidOut = isLaidOut()
				local v9

				if data2.contentLengthChanged and v8 ~= nil and edgeHolds() then
					v9 = edgeOffset(v8)
				end

				local v10 = data2.replaced and 0 or v9

				if data2.viewportChanged then
					local keptDistanceFromEnd = data2.keptDistanceFromEnd

					if laidOut and v8 ~= nil and edgeHolds() then
						v10 = edgeOffset(v8)
					elseif keptDistanceFromEnd ~= nil and not holdsItemTarget() then
						v10 = viewport.getContentLength() - viewport.getLength() - keptDistanceFromEnd
					end
				end

				if v10 ~= nil then
					callback(v10)
				end

				if laidOut and not v4 and (data2.replaced or data2.viewportChanged or data2.scrollMoved) then
					observe()
				end
			elseif v8 ~= nil and edgeHolds() then
				callback(edgeOffset(v8))
			end
		end
	else
		settle = FFlagViewRecyclerReact08 and function(data2, callback)
			if v7 and hasItems() and isLaidOut() then
				v7 = false

				local initialScrollAlignment = v2.initialScrollAlignment

				if initialScrollAlignment ~= nil then
					hold(initialScrollAlignment)
					callback(edgeOffset(initialScrollAlignment))
					return
				end
			end

			local v8 = v5

			if data2.dataChange == nil then
				local laidOut = isLaidOut()
				local v9

				if data2.contentLengthChanged and v8 ~= nil and edgeHolds() then
					v9 = edgeOffset(v8)
				end

				local v10 = data2.replaced and 0 or v9

				if data2.viewportChanged then
					local keptDistanceFromEnd = data2.keptDistanceFromEnd

					if laidOut and v8 ~= nil and edgeHolds() then
						v10 = edgeOffset(v8)
					elseif keptDistanceFromEnd ~= nil and not holdsItemTarget() then
						v10 = viewport.getContentLength() - viewport.getLength() - keptDistanceFromEnd
					end
				end

				if v10 ~= nil then
					callback(v10)
				end

				if laidOut and (data2.replaced or data2.viewportChanged or data2.scrollMoved) then
					observe()
				end
			elseif v8 ~= nil and edgeHolds() then
				callback(edgeOffset(v8))
			end
		end or nil
	end

	scrollAnchor.settle = settle

	function scrollAnchor.getAnchoredItem()
		local v8 = v3
		local v9

		if FFlagViewRecyclerReact084 then
			if v8 == nil then
				v9 = false
			else
				v9 = v8.kind == "itemTarget"
			end
		elseif FFlagViewRecyclerReact08 then
			if v8 == nil then
				v9 = false
			else
				v9 = v8.kind == "itemTarget"
			end
		elseif v8 == nil then
			v9 = true
		elseif v8.kind == "viewport" then
			v9 = not data.shouldPreserveUserPosition()
		else
			v9 = false
		end

		if v9 then
			local indexHint

			if FFlagViewRecyclerReact084 then
				indexHint = v8.indexHint
			elseif FFlagViewRecyclerReact08 then
				indexHint = v8.indexHint
			end

			if not FFlagViewRecyclerReact084 and not FFlagViewRecyclerReact08 or indexHint == nil then
				return nil
			end

			return (table.freeze({ index = indexHint, alignment = v8.alignment }))
		else
			local alignment

			if FFlagViewRecyclerReact084 then
				alignment = v5
			end

			local v10

			if FFlagViewRecyclerReact084 then
				v10 = viewport.getContentLength() <= viewport.getLength()
			else
				v10 = FFlagViewRecyclerReact08
			end

			if v10 then
				if FFlagViewRecyclerReact084 then
					local contentAlignment = viewport.getContentAlignment()

					if contentAlignment == ScrollAlignment.Start then
						alignment = ScrollAlignment.Start
					elseif contentAlignment == ScrollAlignment.End then
						alignment = ScrollAlignment.End
					end
				else
					alignment = v5

					if viewport.getContentLength() <= viewport.getLength() then
						local contentAlignment = viewport.getContentAlignment()

						if contentAlignment == ScrollAlignment.Start then
							alignment = ScrollAlignment.Start
						elseif contentAlignment == ScrollAlignment.End then
							alignment = ScrollAlignment.End
						end
					end

					if alignment == nil then
						if v8 == nil or not v2.preserveScrollPositionOnChange then
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
			end

			if FFlagViewRecyclerReact084 then
				if alignment == nil then
					if v8 == nil or not v2.preserveScrollPositionOnChange then
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

			local indexHint = v8.indexHint

			if FFlagViewRecyclerReact084 then
				if indexHint == nil then
					return nil
				end

				return (table.freeze({ index = indexHint, alignment = ScrollAlignment.Start }))
			elseif FFlagViewRecyclerReact08 then
				if indexHint == nil then
					return nil
				end

				return (table.freeze({ index = indexHint, alignment = ScrollAlignment.Start }))
			else
				if indexHint == nil then
					return nil
				end

				local alignment2

				if v8.kind == "itemTarget" then
					alignment2 = v8.alignment
				else
					alignment2 = ScrollAlignment.Start
				end

				return table.freeze({ index = indexHint, alignment = alignment2 })
			end
		end
	end

	local dataSourceReplaced

	if FFlagViewRecyclerReact084 then
		dataSourceReplaced = function()
			v3 = nil
			v5 = nil
			v6 = false
			v7 = true
		end
	else
		dataSourceReplaced = FFlagViewRecyclerReact08 and function()
			v3 = nil
			v5 = nil
			v6 = false
			v7 = true
		end or nil
	end

	scrollAnchor.dataSourceReplaced = dataSourceReplaced

	function scrollAnchor.reset()
		v3 = nil
	end

	local allowsPolicyOffset

	if not FFlagViewRecyclerReact084 then
		allowsPolicyOffset = not FFlagViewRecyclerReact08 and function(): boolean
			return v3 == nil or v3.kind == "viewport"
		end or nil
	end

	scrollAnchor.allowsPolicyOffset = allowsPolicyOffset
	return scrollAnchor
end

return createScrollAnchor
