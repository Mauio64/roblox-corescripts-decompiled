local EventIngestService = game:GetService("EventIngestService")
local HttpService = game:GetService("HttpService")

local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Analytics").getPlatformTarget
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/logger")

local function sendEventDeferred(p2, p3)
	logger:debug(string.format("Fired %q with payload %s", p2, HttpService:JSONEncode(p3)))
	EventIngestService:SendEventDeferred(getPlatformTarget(), "virtualEvents", p2, p3)
end

return sendEventDeferred
