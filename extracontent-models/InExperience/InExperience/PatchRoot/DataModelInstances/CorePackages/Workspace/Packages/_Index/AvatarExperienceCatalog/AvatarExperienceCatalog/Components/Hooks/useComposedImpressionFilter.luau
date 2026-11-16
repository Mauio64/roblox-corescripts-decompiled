local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)

local function useComposedImpressionFilter(items)
	return React.useCallback(function(p: number): boolean
		for _, item in items do
			if not item(p) then
				return false
			end
		end

		return true
	end, items)
end

return useComposedImpressionFilter
