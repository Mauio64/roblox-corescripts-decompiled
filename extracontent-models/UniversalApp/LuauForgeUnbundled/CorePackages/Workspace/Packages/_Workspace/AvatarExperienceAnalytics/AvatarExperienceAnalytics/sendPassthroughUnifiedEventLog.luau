local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Loggers").mutedError
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local FFlagAXInExperienceNotificationsPassthrough = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/FFlagAXInExperienceNotificationsPassthrough")
local UnifiedEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")

local function toUnifiedEventFields(p2)
	return p2
end

local function reportIfNotPassthrough(p2, p3)
	local v5

	if p3.surface == unifiedLoggingSurface.IN_EXPERIENCE_NOTIFICATIONS and not FFlagAXInExperienceNotificationsPassthrough then
		v5 = false
	else
		v5 = UnifiedEventTypes.PassthroughSurfaces[p3.surface]
	end

	if not v5 then
		mutedError(p2 .. ": surface is not on the passthrough route", {
			surface = tostring(p3.surface)
		})
	end
end

return {
	send = function(p2, p3, p4)
		sendUnifiedEventLog(p2, p3, p4)
		reportIfNotPassthrough("sendPassthroughUnifiedEventLog", p2)
	end,
	sendForInstance = function(p2, p3, p4)
		sendUnifiedEventLogForInstance(p2, p3, p4)
		reportIfNotPassthrough("sendPassthroughUnifiedEventLogForInstance", p3)
	end
}
