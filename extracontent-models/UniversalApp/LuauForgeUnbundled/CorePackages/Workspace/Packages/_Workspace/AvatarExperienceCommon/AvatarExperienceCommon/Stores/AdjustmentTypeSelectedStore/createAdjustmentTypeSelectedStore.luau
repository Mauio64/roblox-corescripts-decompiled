require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsUtils").createSessionScopedSignal
local position = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Enums/AdjustmentType").Position

local function createAdjustmentTypeSelectedStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(position)

	return {
		getAdjustmentTypeSelected = sessionScopedSignal,
		setAdjustmentType = function(p2)
			v5(p2)
		end,
		reset = function()
			v5(position)
		end
	}
end

return createAdjustmentTypeSelectedStore
