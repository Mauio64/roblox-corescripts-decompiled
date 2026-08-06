local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local useRefCache = require(FoundationParent.ReactUtils).useRefCache

require(Foundation.Components.Types)

local function usePaginationSelectionChain(t1: {[any]: any}, p1, p2: ((...any) -> ...any)?) -- line: 22
	-- upvalues: useRefCache (copy), React (copy)
	local v9 = useRefCache()
	local v10 = t1[1]
	local v11 = React.useCallback(function(s1: string) -- line: 30
		-- upvalues: v9 (copy), v10 (copy), p2 (copy)
		local v14 = v9[s1]

		if s1 ~= v10 or p2 == nil then
			return v14
		end

		return function(p3) -- line: 36
			-- upvalues: v14 (copy), p2 (copy)
			v14.current = p3
			p2(p3)
		end
	end, {
		v10,
		p2,
		v9
	})
	local v12 = React.useCallback(function(s2: string) -- line: 42
		-- upvalues: t1 (copy), v9 (copy), p1 (copy)
		local v16 = table.find(t1, s2)

		if v16 == nil then
			return {
				Selectable = false,
				ref = v9[s2]
			}
		end

		return {
			Selectable = true,
			ref = v9[s2],
			NextSelectionLeft = if not (v16 > 1) then nil else v9[t1[v16 - 1]],
			NextSelectionRight = if not (v16 < #t1) then nil else v9[t1[v16 + 1]],
			NextSelectionUp = p1 and p1.NextSelectionUp,
			NextSelectionDown = p1 and p1.NextSelectionDown
		}
	end, {
		t1,
		v9,
		p1
	})

	return React.useMemo(function() -- line: 61
		-- upvalues: v10 (copy), v12 (copy), v11 (copy)
		return {
			firstSlotId = v10,
			getSlotBindings = v12,
			getSlotRef = v11
		}
	end, {
		v10,
		v12,
		v11
	})
end

return usePaginationSelectionChain
