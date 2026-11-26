local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local function useFirstSeenImpressionFilter(p2)
	local ref = React.useRef({})

	React.useEffect(function()
		ref.current = {}
	end, { p2 })

	return React.useCallback(function(p3): boolean
		if ref.current[p3] then
			return false
		end

		ref.current[p3] = true
		return true
	end, {})
end

return useFirstSeenImpressionFilter
