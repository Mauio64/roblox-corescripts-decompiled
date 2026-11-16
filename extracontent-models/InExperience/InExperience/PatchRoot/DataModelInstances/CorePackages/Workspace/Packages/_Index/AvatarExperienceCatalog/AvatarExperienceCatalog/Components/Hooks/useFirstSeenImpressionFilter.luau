local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local function useFirstSeenImpressionFilter(p)
	local ref = React.useRef({})

	React.useEffect(function()
		ref.current = {}
	end, { p })

	return React.useCallback(function(p2: number): boolean
		if ref.current[p2] then
			return false
		end

		ref.current[p2] = true
		return true
	end, {})
end

return useFirstSeenImpressionFilter
