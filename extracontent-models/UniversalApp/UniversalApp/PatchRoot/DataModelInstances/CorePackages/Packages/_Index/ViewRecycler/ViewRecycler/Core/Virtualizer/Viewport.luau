local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact084 = Flags.FFlagViewRecyclerReact084
local Flags2 = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags2.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

require(ViewRecycler.Core.Layout)
local ReachedThreshold = require(ViewRecycler.Core.ViewportBehavior.ReachedThreshold)
local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)
local Types = require(ViewRecycler.Core.Types)

local frozen = table.freeze({ firstIndex = 1, lastIndex = 0 })

local function resolveOverscan(value: number?) -- 2 equivalent calls inferred from this helper
	local overscan = value or 1
	local v = overscan >= 0 and overscan % 1 == 0
	assert(v, "Virtualizer: overscan must be a non-negative integer")
	return overscan
end

local function validateAlignment(p) -- 2 equivalent calls inferred from this helper
	assert(
		p == ScrollAlignment.Start or p == ScrollAlignment.Center or p == ScrollAlignment.End,
		"Virtualizer: invalid content alignment"
	)
end

local function validateInset(p: number) -- 2 equivalent calls inferred from this helper
	local v = p >= 0 and p < 1e999
	assert(v, "Virtualizer: content insets must be finite non-negative numbers")
end

local function sameRange(p, p2): boolean -- 2 equivalent calls inferred from this helper
	return p.firstIndex == p2.firstIndex and p.lastIndex == p2.lastIndex
end

local function createViewport(data)
	local layout = data.layout
	local overscan = resolveOverscan(data.overscan) -- inferred equivalent call
	local contentAlignment = data.contentAlignment or ScrollAlignment.Start
	local v = data.endThreshold
	validateAlignment(contentAlignment) -- inferred equivalent call

	if v ~= nil then
		ReachedThreshold.validate(v, "Virtualizer: end threshold")
	end

	local v2 = 0
	local v3 = 0
	local scrollOffset = 0
	local length = 0
	local crossAxisLength = 0
	local contentLength = 0
	local contentStartOffset = 0
	local visibleRange = frozen
	local mountedRange = frozen

	local function metrics() -- 3 equivalent calls inferred from this helper
		local contentLength2 = layout.getContentLength()
		local v4 = math.max(0, length - v2 - v3 - contentLength2)

		if contentAlignment ~= ScrollAlignment.End then
			v4 = contentAlignment ~= ScrollAlignment.Center and 0 or v4 / 2
		end

		return v2 + contentLength2 + v3, v2 + v4
	end

	local function refresh() -- 4 equivalent calls inferred from this helper
		contentLength, contentStartOffset = metrics() -- inferred equivalent call
	end

	local function clamp(value: number) -- 1 equivalent call inferred from this helper
		return (math.clamp(value, 0, (math.max(0, metrics() - length)))) -- inferred equivalent call
	end

	local function scrollTo(value: number) -- 1 equivalent call inferred from this helper
		assert(math.abs(value) < 1e999, "Virtualizer: scroll offset must be finite")
		scrollOffset = clamp(value) -- inferred equivalent call
		return scrollOffset
	end

	local function visibleRangeAt(scrollOffset2: number, p: number) -- 1 equivalent call inferred from this helper
		local v4 = scrollOffset2 + v2 - contentStartOffset
		local v5 = math.max(v4, p - v3 - contentStartOffset)
		return layout.getIntersectingIndexRange(v4, v5)
	end

	local contentLength2 = layout.getContentLength()
	local v4 = math.max(0, length - v2 - v3 - contentLength2)

	if contentAlignment ~= ScrollAlignment.End then
		v4 = contentAlignment ~= ScrollAlignment.Center and 0 or v4 / 2
	end

	local v5 = v2 + contentLength2 + v3
	local v6 = v2 + v4
	contentLength = v5
	contentStartOffset = v6

	local viewport = {
		setLayout = function(p)
			layout = p
			refresh() -- inferred equivalent call
		end,
		getLayout = function()
			return layout
		end,
		setScrollOffset = function(p): boolean
			if scrollOffset == p then
				return false
			end

			scrollOffset = p
			return true
		end,
		scrollTo = scrollTo,
		clamp = clamp,
		setSize = function(p, p2): boolean
			if length == p and crossAxisLength == p2 then
				return false
			end

			length = p
			crossAxisLength = p2
			refresh() -- inferred equivalent call
			return true
		end,
		setOverscan = function(value)
			overscan = resolveOverscan(value) -- inferred equivalent call
		end,
		setContentAlignment = function(p): boolean
			local v7 = p or ScrollAlignment.Start
			validateAlignment(v7) -- inferred equivalent call

			if contentAlignment == v7 then
				return false
			end

			contentAlignment = v7
			refresh() -- inferred equivalent call
			return true
		end,
		getContentAlignment = function()
			return contentAlignment
		end,
		setInsets = function(p, p2): boolean
			validateInset(p) -- inferred equivalent call
			validateInset(p2) -- inferred equivalent call

			if v2 == p and v3 == p2 then
				return false
			end

			v2 = p
			v3 = p2
			refresh() -- inferred equivalent call
			return true
		end,
		setEndThreshold = function(p)
			if p ~= nil then
				ReachedThreshold.validate(p, "Virtualizer: end threshold")
			end

			v = p
		end,
		refresh = refresh,
		updateRanges = function()
			local v7 = visibleRangeAt(scrollOffset, scrollOffset + length) -- inferred equivalent call
			local v8

			if Types.isIndexRangeEmpty(v7) then
				v8 = frozen
			else
				v8 = layout.expandIndexRange(v7, overscan, overscan)
			end

			local v9 = not sameRange(visibleRange, v7) -- inferred equivalent call
			local v10 = not sameRange(mountedRange, v8) -- inferred equivalent call

			if v9 then
				visibleRange = table.freeze({ firstIndex = v7.firstIndex, lastIndex = v7.lastIndex })
			end

			if v10 then
				mountedRange = table.freeze({ firstIndex = v8.firstIndex, lastIndex = v8.lastIndex })
			end

			return v9, v10
		end,
		getScrollOffset = function()
			return scrollOffset
		end,
		getLength = function()
			return length
		end,
		getCrossAxisLength = function()
			return crossAxisLength
		end,
		getContentLength = function()
			return contentLength
		end,
		getContentStartOffset = function()
			return contentStartOffset
		end,
		getVisibleRange = function()
			return visibleRange
		end,
		getMountedRange = function()
			return mountedRange
		end,
		visibleRangeAt = visibleRangeAt,
		placedItemLayout = function(p)
			local itemLayout = layout.getItemLayout(p)
			return {
				startOffset = itemLayout.startOffset + contentStartOffset,
				length = itemLayout.length,
				crossAxisIndex = itemLayout.crossAxisIndex,
				crossAxisCount = itemLayout.crossAxisCount
			}
		end,
		offsetForItem = function(value, p)
			local itemCount = layout.getItemCount()

			if itemCount == 0 then
				return 0
			end

			local itemLayout = layout.getItemLayout((math.clamp(value, 1, itemCount)))
			local v7, v8 = metrics() -- inferred equivalent call
			local v9 = math.max(0, length - v2 - v3)
			local v10

			if p == ScrollAlignment.Center then
				v10 = v8 + itemLayout.startOffset + itemLayout.length / 2 - v2 - v9 / 2
			elseif p == ScrollAlignment.End then
				v10 = v8 + itemLayout.startOffset + itemLayout.length - length + v3
			else
				v10 = v8 + itemLayout.startOffset - v2
			end

			return (math.clamp(v10, 0, (math.max(0, v7 - length))))
		end,
		scrollState = function(data2)
			local distanceFromEnd = math.max(0, contentLength - length - scrollOffset)
			local atStart = scrollOffset <= 0
			local atEnd = distanceFromEnd <= ReachedThreshold.resolve(v, length, 1)

			if
				data2 == nil
				or data2.scrollOffset ~= scrollOffset
				or data2.viewportLength ~= length
				or data2.contentLength ~= contentLength
				or data2.distanceFromEnd ~= distanceFromEnd
				or data2.atStart ~= atStart
				or data2.atEnd ~= atEnd
			then
				return table.freeze({
					scrollOffset = scrollOffset,
					viewportLength = length,
					contentLength = contentLength,
					distanceFromEnd = distanceFromEnd,
					atStart = atStart,
					atEnd = atEnd
				})
			end

			return data2
		end,
		scrollBy = 0
	}
	local scrollBy

	if not FFlagViewRecyclerReact084 then
		scrollBy = not FFlagViewRecyclerReact08 and function(p)
			assert(math.abs(p) < 1e999, "Virtualizer: scroll delta must be finite")
			return scrollTo(scrollOffset + p) -- inferred equivalent call
		end or nil
	end

	viewport.scrollBy = scrollBy
	return viewport
end

return createViewport
