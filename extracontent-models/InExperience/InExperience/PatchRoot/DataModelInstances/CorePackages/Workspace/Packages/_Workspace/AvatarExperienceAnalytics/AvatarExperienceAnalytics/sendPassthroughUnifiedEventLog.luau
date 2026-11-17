local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local FFlagAXInExperienceNotificationsPassthrough = require(script.Parent.FFlagAXInExperienceNotificationsPassthrough)
local UnifiedEventTypes = require(script.Parent.Generated.UnifiedEventTypes)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)

local function toUnifiedEventFields(p)
	return p
end

local function reportIfNotPassthrough(p: string, p2)
	local v

	if
		p2.surface == UnifiedLoggingSurface.IN_EXPERIENCE_NOTIFICATIONS
		and not FFlagAXInExperienceNotificationsPassthrough
	then
		v = false
	else
		v = UnifiedEventTypes.PassthroughSurfaces[p2.surface]
	end

	if not v then
		mutedError(p .. ": surface is not on the passthrough route", {
			surface = tostring(p2.surface)
		})
	end
end

local SendPassthroughUnifiedEventLog = {}

function SendPassthroughUnifiedEventLog.send(p, p2, p3)
	sendUnifiedEventLog(p, p2, p3)
	reportIfNotPassthrough("sendPassthroughUnifiedEventLog", p)
end

function SendPassthroughUnifiedEventLog.sendForInstance(p, p2, p3)
	sendUnifiedEventLogForInstance(p, p2, p3)
	reportIfNotPassthrough("sendPassthroughUnifiedEventLogForInstance", p2)
end

return SendPassthroughUnifiedEventLog
