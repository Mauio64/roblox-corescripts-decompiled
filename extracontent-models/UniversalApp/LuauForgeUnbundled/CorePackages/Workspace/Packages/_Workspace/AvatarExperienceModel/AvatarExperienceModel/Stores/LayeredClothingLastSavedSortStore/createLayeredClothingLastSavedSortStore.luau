require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/SignalsUtils").createSessionScopedSignal

local function createEmptyLastSavedSort()
	return {}
end

local function createLayeredClothingLastSavedSortStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(createEmptyLastSavedSort)

	return {
		getLastSavedSort = sessionScopedSignal,
		setLastSavedSort = function(p2)
			v5(p2)
		end,
		reset = function()
			v5({})
		end
	}
end

return createLayeredClothingLastSavedSortStore
