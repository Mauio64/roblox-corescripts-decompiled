local EventIngestService = game:GetService("EventIngestService")
local ParentParent = script.Parent.Parent.Parent
local getPlatformTarget = require(ParentParent.Analytics).getPlatformTarget

return function(s1: string, s2: string, t1: {[any]: any}?) -- line: 5
	-- upvalues: EventIngestService (copy), getPlatformTarget (copy)
	EventIngestService:SendEventDeferred(getPlatformTarget(), s1, s2, t1 or {})
end
