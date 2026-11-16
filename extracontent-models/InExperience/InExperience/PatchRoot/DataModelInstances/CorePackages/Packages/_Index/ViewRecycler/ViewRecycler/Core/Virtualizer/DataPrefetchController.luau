local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataPrefetch = require(ViewRecycler.Core.DataPrefetch)
require(ViewRecycler.Core.Virtualizer.ItemSequence)
local Types = require(ViewRecycler.Core.Types)

local frozen = table.freeze({})
local frozen2 = table.freeze({ startItems = 0, endItems = 0 })

local function sameRange(range, p): boolean -- 1 equivalent call inferred from this helper
	return range.firstIndex == p.firstIndex and range.lastIndex == p.lastIndex
end

local function sameOptions(p, p2): boolean -- 2 equivalent calls inferred from this helper
	return p.startItems == p2.startItems and p.endItems == p2.endItems
end

local function createDataPrefetchController(p)
	local flag = false
	local itemSequence = nil
	local v = DataPrefetch.resolve(p)
	local v2 = {}

	local function createRequest(edge, list)
		local v3 = { range = table.freeze(list) }

		v2[edge] = v3
		return table.freeze({
			edge = edge,
			range = v3.range,
			isCurrent = function(): boolean
				return not flag and v2[edge] == v3
			end
		})
	end

	local function desiredRange(p2, p3: number, mountedRange, resolved)
		local v3

		if p2 == DataPrefetch.Edge.Start then
			v3 = resolved.startItems
		else
			v3 = resolved.endItems
		end

		if v3 == 0 then
			return nil
		end

		local selected

		if p2 == DataPrefetch.Edge.Start then
			selected = {
				firstIndex = math.max(1, mountedRange.firstIndex - v3),
				lastIndex = mountedRange.firstIndex - 1
			}
		else
			selected = {
				firstIndex = mountedRange.lastIndex + 1,
				lastIndex = math.min(p3, mountedRange.lastIndex + v3)
			}
		end

		if Types.isIndexRangeEmpty(selected) then
			return nil
		end

		return selected
	end

	local function reconcileEdge(edge, p2, list)
		local v3 = v2[edge]

		if p2 == nil then
			v2[edge] = nil
			return list
		end

		if v3 == nil then
			list = list or {}
			table.insert(list, createRequest(edge, p2))
		elseif not sameRange(v3.range, p2) then -- inferred equivalent call
			list = list or {}
			table.insert(list, createRequest(edge, p2))
		end

		return list
	end

	return {
		reconcile = function(data)
			assert(not flag, "DataPrefetchController: cannot reconcile after destroy")
			local options = data.options
			local v3 = options == nil and 0 or options.startItems or 0
			local v4 = options == nil and 0 or options.endItems or 0

			if v3 == 0 and v4 == 0 then
				if itemSequence == data.itemSequence then
					if not sameOptions(v, frozen2) then -- inferred equivalent call
						table.clear(v2)
					end
				else
					table.clear(v2)
				end

				itemSequence = data.itemSequence
				v = frozen2
				return frozen
			else
				local resolved = DataPrefetch.resolve(data.options)
				local mountedRange = data.mountedRange
				local v5 = Types.isIndexRangeEmpty(mountedRange) and 0 or data.itemSequence.getItemCount()
				local v6, v7

				if not Types.isIndexRangeEmpty(mountedRange) then
					v6 = desiredRange(DataPrefetch.Edge.Start, v5, mountedRange, resolved)
					v7 = desiredRange(DataPrefetch.Edge.End, v5, mountedRange, resolved)
				end

				if itemSequence == data.itemSequence then
					if not sameOptions(v, resolved) then -- inferred equivalent call
						table.clear(v2)
					end
				else
					table.clear(v2)
				end

				itemSequence = data.itemSequence
				v = resolved

				local v8 = reconcileEdge(DataPrefetch.Edge.Start, v6, nil)
				return reconcileEdge(DataPrefetch.Edge.End, v7, v8) or frozen
			end
		end,
		destroy = function()
			if flag then
				return
			end

			flag = true
			table.clear(v2)
		end
	}
end

return createDataPrefetchController
