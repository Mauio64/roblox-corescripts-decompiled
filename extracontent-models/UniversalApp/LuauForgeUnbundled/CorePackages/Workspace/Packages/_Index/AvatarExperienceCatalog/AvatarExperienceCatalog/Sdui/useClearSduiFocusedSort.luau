local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useDispatch

local function useClearSduiFocusedSort(p2)
	local v5 = useDispatch()
	return React.useCallback(function(p3)
		if not p3 then
			return
		end

		v5(p2.ClearWidgetInfo(nil, p3))
	end, { v5, p2.ClearWidgetInfo })
end

return useClearSduiFocusedSort
