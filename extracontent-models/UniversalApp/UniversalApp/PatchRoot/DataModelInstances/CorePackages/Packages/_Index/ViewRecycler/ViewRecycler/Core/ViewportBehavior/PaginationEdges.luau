local Flags = require(script:FindFirstAncestor("ViewRecycler").Flags)
local FFlagViewRecyclerReact08 = Flags.FFlagViewRecyclerReact08
local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DataSourceChangeType = require(ViewRecycler.Core.Enums.DataSourceChangeType)

local ReachedThreshold = require(ViewRecycler.Core.ViewportBehavior.ReachedThreshold)
require(ViewRecycler.Core.Types)

local validate = FFlagViewRecyclerReact08 and function(p)
	if p.startReachedThreshold ~= nil then
		ReachedThreshold.validate(p.startReachedThreshold, "Virtualizer: startReachedThreshold")
	end
end or nil
local PaginationEdges = {}

function PaginationEdges.hasStructuralChange(p): boolean
	for _, change in p.changes do
		if change.type ~= DataSourceChangeType.Update then
			return true
		end
	end

	return false
end

if FFlagViewRecyclerReact08 then
	function PaginationEdges.create(p)
		validate(p)
		local v = p
		local v2 = true
		local v3 = true

		return {
			configure = function(p2)
				validate(p2)
				v = p2
			end,
			isEnabled = function()
				return v.startReachedEnabled or v.endReachedEnabled
			end,
			check = function(data, p2)
				if p2 then
					v2 = true
					v3 = true
				end

				local v4 = ReachedThreshold.resolve(v.startReachedThreshold, data.viewportLength, 0) >= data.scrollOffset
				local atEnd = data.atEnd
				local startReachedEnabled = v4 and v2 and v.startReachedEnabled
				local endReachedEnabled = atEnd and v3 and v.endReachedEnabled

				if startReachedEnabled then
					v2 = false
				elseif not v4 then
					v2 = true
				end

				if endReachedEnabled then
					v3 = false
					return startReachedEnabled, endReachedEnabled
				end

				if not atEnd then
					v3 = true
				end

				return startReachedEnabled, endReachedEnabled
			end
		}
	end
else
	function PaginationEdges.create(_)
		local v = true
		local v2 = true

		return {
			check = function(data)
				if data.rearmAfterStructureChange then
					v = true
					v2 = true
				end

				local v3 = data.scrollOffset <= data.startThreshold
				local atEnd = data.atEnd
				local canReachStart = v3 and v and data.canReachStart
				local canReachEnd = atEnd and v2 and data.canReachEnd

				if canReachStart then
					v = false
				elseif not v3 then
					v = true
				end

				if canReachEnd then
					v2 = false
				elseif not atEnd then
					v2 = true
				end

				return { startReached = canReachStart, endReached = canReachEnd }
			end
		}
	end
end

return PaginationEdges
