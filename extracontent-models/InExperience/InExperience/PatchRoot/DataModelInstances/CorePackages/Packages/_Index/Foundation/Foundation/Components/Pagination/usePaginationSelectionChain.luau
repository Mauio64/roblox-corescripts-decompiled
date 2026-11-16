local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useRefCache = ReactUtils.useRefCache

require(Foundation.Components.Types)

local function usePaginationSelectionChain(list, p, callback)
	local v = useRefCache()
	local item = list[1]

	local getSlotRef = React.useCallback(function(p2: string)
		local v2 = v[p2]

		if item == p2 and callback ~= nil then
			return function(current)
				v2.current = current
				callback(current)
			end
		end

		return v2
	end, { item, callback, v })

	local getSlotBindings = React.useCallback(function(p2: string)
		local index = table.find(list, p2)

		if index == nil then
			return { ref = v[p2], Selectable = false }
		end

		local v2 = {
			ref = v[p2],
			Selectable = true,
			NextSelectionLeft = 0,
			NextSelectionRight = 0,
			NextSelectionUp = 0,
			NextSelectionDown = 0
		}
		local nextSelectionLeft

		if index > 1 then
			nextSelectionLeft = v[list[index - 1]]
		end

		v2.NextSelectionLeft = nextSelectionLeft
		local nextSelectionRight

		if index < #list then
			nextSelectionRight = v[list[index + 1]]
		end

		v2.NextSelectionRight = nextSelectionRight
		v2.NextSelectionUp = p and p.NextSelectionUp
		v2.NextSelectionDown = p and p.NextSelectionDown
		return v2
	end, { list, v, p })

	return React.useMemo(function()
		return { firstSlotId = item, getSlotBindings = getSlotBindings, getSlotRef = getSlotRef }
	end, { item, getSlotBindings, getSlotRef })
end

return usePaginationSelectionChain
