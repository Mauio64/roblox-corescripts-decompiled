local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local EventIngestService = game:GetService("EventIngestService")
local HttpService = game:GetService("HttpService")

local Analytics = require(VirtualEvents.Parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget
local logger = require(VirtualEvents.logger)

local function sendEventDeferred(p: string, p2)
	logger:debug(string.format("Fired %q with payload %s", p, HttpService:JSONEncode(p2)))
	EventIngestService:SendEventDeferred(getPlatformTarget(), "virtualEvents", p, p2)
end

return sendEventDeferred
