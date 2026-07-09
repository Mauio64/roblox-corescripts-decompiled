local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)

local function useFirstSeenImpressionFilter(p1) -- line: 24
	-- upvalues: React (copy)
	local v5 = React.useRef({})

	React.useEffect(function() -- line: 27
		-- upvalues: v5 (copy)
		v5.current = {}
	end, { p1 })

	return React.useCallback(function(n1: number) -- line: 31
		-- upvalues: v5 (copy)
		if v5.current[n1] then
			return false
		end

		v5.current[n1] = true

		return true
	end, {})
end

return useFirstSeenImpressionFilter
