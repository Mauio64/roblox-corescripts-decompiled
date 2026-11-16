local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local AutoScroll = require(script.Parent.AutoScroll)
local AutoScrollTarget = require(ViewRecycler.Core.Enums.AutoScrollTarget)
local PaginationEdges = require(script.Parent.PaginationEdges)
local ReachedThreshold = require(script.Parent.ReachedThreshold)
local ScrollAlignment = require(ViewRecycler.Core.Enums.ScrollAlignment)
require(ViewRecycler.Core.Types)
local InitialScrollPosition = require(script.Parent.InitialScrollPosition)

local function validate(data) -- 2 equivalent calls inferred from this helper
	AutoScroll.validate(data.autoScrollOnChange)

	if data.autoScrollThreshold ~= nil then
		ReachedThreshold.validate(data.autoScrollThreshold, "Virtualizer: autoScrollThreshold")
	end

	if data.startReachedThreshold ~= nil then
		ReachedThreshold.validate(data.startReachedThreshold, "Virtualizer: startReachedThreshold")
	end
end

local function createScrollPolicy(data)
	validate(data) -- inferred equivalent call
	local v = data
	local initialScrollPosition = InitialScrollPosition()
	local v2 = AutoScroll.create()
	local v3 = PaginationEdges.create()

	local function settleInitialEnd(p: number?, itemCount: number) -- 3 equivalent calls inferred from this helper
		if p ~= nil and itemCount > 0 and v.initialScrollAlignment == ScrollAlignment.End then
			v2.settleAt(AutoScrollTarget.End)
		end

		return p
	end

	local function followThreshold(viewportLength: number) -- 1 equivalent call inferred from this helper
		return ReachedThreshold.resolve(v.autoScrollThreshold, viewportLength, 1)
	end

	return {
		configure = function(data2)
			validate(data2) -- inferred equivalent call
			v = data2
		end,
		contentLengthChanged = function(p)
			return v2.getSettleOffset(p.contentLength, p.viewportLength)
		end,
		dataChanged = function(data2, p)
			local v4 = initialScrollPosition.onDataSourceChange(
				data2.itemCount,
				v.initialScrollAlignment,
				data2.getScrollOffsetForItem
			)

			local v5 = v2.onDataSourceChanged(AutoScroll.resolveTarget(
				v.autoScrollOnChange,
				p,
				followThreshold(p.viewportLength)
			))

			if v5 ~= false then
				return AutoScroll.getTargetOffset(v5, data2.scrollState.contentLength, data2.scrollState.viewportLength)
			end

			return settleInitialEnd(v4, data2.itemCount) -- inferred equivalent call
		end,
		dataReplaced = function(p)
			return settleInitialEnd( -- inferred equivalent call
				initialScrollPosition.onDataSourceReplaced(
					p.itemCount,
					v.initialScrollAlignment,
					p.getScrollOffsetForItem
				),
				p.itemCount
			)
		end,
		viewportChanged = function(data2)
			local scrollState = data2.scrollState

			if data2.itemCount ~= 0 and not (scrollState.contentLength > 0) then
				return nil
			end

			local v4 = initialScrollPosition.onViewportChanged(
				data2.itemCount,
				v.initialScrollAlignment,
				data2.getScrollOffsetForItem
			)

			if settleInitialEnd(v4, data2.itemCount) == nil then -- inferred equivalent call
				return v2.getSettleOffset(scrollState.contentLength, scrollState.viewportLength)
			end

			return v4
		end,
		observe = function(p)
			v2.onScrollOffsetChanged(
				p,
				followThreshold(p.viewportLength), -- inferred equivalent call
				AutoScroll.followedEdge(v.autoScrollOnChange)
			)
		end,
		pin = v2.pin,
		checkEdges = function(data2, p, rearmAfterStructureChange)
			if not (v.startReachedEnabled or v.endReachedEnabled) then
				return false, false
			end

			local viewportLength = data2.viewportLength

			if viewportLength <= 0 or p > 0 and data2.contentLength == 0 then
				return false, false
			end

			local v4 = v3.check({
				scrollOffset = data2.scrollOffset,
				viewportLength = viewportLength,
				contentLength = data2.contentLength,
				startThreshold = ReachedThreshold.resolve(v.startReachedThreshold, viewportLength, 0),
				atEnd = data2.atEnd,
				canReachStart = v.startReachedEnabled,
				canReachEnd = v.endReachedEnabled,
				rearmAfterStructureChange = rearmAfterStructureChange
			})

			return v4.startReached, v4.endReached
		end,
		reachesEdges = function()
			return v.startReachedEnabled or v.endReachedEnabled
		end
	}
end

return createScrollPolicy
