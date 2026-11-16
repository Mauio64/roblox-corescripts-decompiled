local EventIngestService = game:GetService("EventIngestService")
local parent = script.Parent.Parent.Parent
local Analytics = require(parent.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

return function(p: string, p2: string, options)
	EventIngestService:SendEventDeferred(getPlatformTarget(), p, p2, options or {})
end
