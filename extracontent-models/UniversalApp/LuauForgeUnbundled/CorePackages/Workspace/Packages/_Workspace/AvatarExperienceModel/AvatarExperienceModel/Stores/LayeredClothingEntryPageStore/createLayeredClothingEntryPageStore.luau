require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/SignalsUtils").createSessionScopedSignal
local avatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceNavigation").Enums.AvatarScreen

local function createLayeredClothingEntryPageStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal(avatarScreen.None)

	return {
		getEntryPage = sessionScopedSignal,
		setEntryPage = function(p2)
			v5(p2)
		end,
		reset = function()
			v5(avatarScreen.None)
		end
	}
end

return createLayeredClothingEntryPageStore
