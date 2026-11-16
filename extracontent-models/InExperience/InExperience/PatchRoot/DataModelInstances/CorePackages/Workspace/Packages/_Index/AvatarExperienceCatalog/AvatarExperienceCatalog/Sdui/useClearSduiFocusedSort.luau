local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local function useClearSduiFocusedSort(p)
	local v = useDispatch()
	return React.useCallback(function(p2: string?)
		if not p2 then
			return
		end

		v(p.ClearWidgetInfo(nil, p2))
	end, { v, p.ClearWidgetInfo })
end

return useClearSduiFocusedSort
