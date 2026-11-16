local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local UnifiedEventTypes = require(script.Parent.Generated.UnifiedEventTypes)
local sendUnifiedEventLog = require(script.Parent.sendUnifiedEventLog)
local sendUnifiedEventLogForInstance = require(script.Parent.sendUnifiedEventLogForInstance)

local function toUnifiedEventFields(p)
	return p
end

local function reportIfNotPassthrough(p: string, p2) -- 2 equivalent calls inferred from this helper
	if not UnifiedEventTypes.PassthroughSurfaces[p2.surface] then
		mutedError(p .. ": surface is not on the passthrough route", {
			surface = tostring(p2.surface)
		})
	end
end

local SendPassthroughUnifiedEventLog = {}

function SendPassthroughUnifiedEventLog.send(p, p2, p3)
	sendUnifiedEventLog(p, p2, p3)
	reportIfNotPassthrough("sendPassthroughUnifiedEventLog", p) -- inferred equivalent call
end

function SendPassthroughUnifiedEventLog.sendForInstance(p, p2, p3)
	sendUnifiedEventLogForInstance(p, p2, p3)
	reportIfNotPassthrough("sendPassthroughUnifiedEventLogForInstance", p2) -- inferred equivalent call
end

return SendPassthroughUnifiedEventLog
