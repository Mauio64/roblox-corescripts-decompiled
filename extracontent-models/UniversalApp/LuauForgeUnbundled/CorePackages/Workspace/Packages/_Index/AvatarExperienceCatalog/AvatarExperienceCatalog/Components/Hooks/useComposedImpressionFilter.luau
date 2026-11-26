local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local function useComposedImpressionFilter(items)
	return React.useCallback(function(p2): boolean
		for k, item in items do
			if not item(p2) then
				return false
			end
		end

		return true
	end, items)
end

return useComposedImpressionFilter
