local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Loggers").mutedError
local UnifiedEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local sendUnifiedEventLog = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLog")
local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/sendUnifiedEventLogForInstance")

local function toUnifiedEventFields(p2)
	return p2
end

local function reportIfNotPassthrough(p2, p3)
	if not UnifiedEventTypes.PassthroughSurfaces[p3.surface] then
		mutedError(p2 .. ": surface is not on the passthrough route", {
			surface = tostring(p3.surface)
		})
	end
end

return {
	send = function(p2, p3, p4)
		sendUnifiedEventLog(p2, p3, p4)

		if not UnifiedEventTypes.PassthroughSurfaces[p2.surface] then
			mutedError("sendPassthroughUnifiedEventLog: surface is not on the passthrough route", {
				surface = tostring(p2.surface)
			})
		end
	end,
	sendForInstance = function(p2, p3, p4)
		sendUnifiedEventLogForInstance(p2, p3, p4)

		if not UnifiedEventTypes.PassthroughSurfaces[p3.surface] then
			mutedError(
				"sendPassthroughUnifiedEventLogForInstance: surface is not on the passthrough route",
				{ surface = tostring(p3.surface) }
			)
		end
	end
}
