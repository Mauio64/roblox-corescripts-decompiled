local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)

local function useComposedImpressionFilter(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy)
	return React.useCallback(function(n1: number) -- line: 32
		-- upvalues: t1 (copy)
		for _, v7 in t1 do
			if not v7(n1) then
				return false
			end
		end

		return true
	end, t1)
end

return useComposedImpressionFilter
