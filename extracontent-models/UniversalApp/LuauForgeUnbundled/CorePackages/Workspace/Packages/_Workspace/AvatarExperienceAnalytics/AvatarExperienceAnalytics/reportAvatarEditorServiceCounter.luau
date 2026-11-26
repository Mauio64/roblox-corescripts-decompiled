local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendAXCounterV2")

local AVATAR_EDITOR_SERVICE_COUNTER_STATUS = Constants.AVATAR_EDITOR_SERVICE_COUNTER_STATUS

local function reportAvatarEditorServiceCounter(p2, p3, p4)
	local v5 = { status = p3 }

	if p3 == AVATAR_EDITOR_SERVICE_COUNTER_STATUS.Error and p4 ~= nil then
		local v6 = if typeof(p4) == "EnumItem" then p4.Name else tostring(p4)
		v5.message = string.sub(v6, 1, 256)
	end

	sendAXCounterV2(p2, v5)
end

return reportAvatarEditorServiceCounter
