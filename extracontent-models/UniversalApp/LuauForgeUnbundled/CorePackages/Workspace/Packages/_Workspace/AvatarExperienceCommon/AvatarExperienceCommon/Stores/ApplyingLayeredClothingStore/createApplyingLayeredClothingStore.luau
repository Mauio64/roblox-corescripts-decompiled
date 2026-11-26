require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/SignalsUtils").createSessionScopedSignal

local function createApplyingLayeredClothingStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(false)

	return {
		getApplyingLayeredClothing = sessionScopedSignal,
		startedApplyingLayeredClothing = function()
			v5(true)
		end,
		finishedApplyingLayeredClothing = function()
			v5(false)
		end,
		reset = function()
			v5(false)
		end
	}
end

return createApplyingLayeredClothingStore
