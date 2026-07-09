local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch

local function useClearSduiFocusedSort(t1: {[any]: any}) -- line: 27
	-- upvalues: useDispatch (copy), React (copy)
	local v6 = useDispatch()

	return React.useCallback(function(s1: string?) -- line: 29
		-- upvalues: v6 (copy), t1 (copy)
		if not s1 then
			return
		end

		v6(t1.ClearWidgetInfo(nil, s1))
	end, {
		v6,
		t1.ClearWidgetInfo
	})
end

return useClearSduiFocusedSort
