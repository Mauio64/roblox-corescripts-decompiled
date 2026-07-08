local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local EventIngestService = game:GetService("EventIngestService")
local HttpService = game:GetService("HttpService")
local getPlatformTarget = require(VirtualEvents.Parent.Analytics).getPlatformTarget
local logger = require(VirtualEvents.logger)

local function sendEventDeferred(s1: string, t1: {[any]: any}) -- line: 9
	-- upvalues: logger (copy), HttpService (copy), EventIngestService (copy), getPlatformTarget (copy)
	logger:debug(string.format("Fired %q with payload %s", s1, HttpService:JSONEncode(t1)))
	EventIngestService:SendEventDeferred(getPlatformTarget(), "virtualEvents", s1, t1)
end

return sendEventDeferred
