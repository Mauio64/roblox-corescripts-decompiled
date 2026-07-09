local ParentParent = script.Parent.Parent
local DiagEvents = require(ParentParent.Analytics.DiagEvents)
local EventNames = require(ParentParent.Analytics.Enums.EventNames)

return function(p1) -- line: 5
	-- upvalues: EventNames (copy), DiagEvents (copy)
	assert(EventNames.isEnumValue(p1), "Invalid event name")

	local v5 = DiagEvents[p1]

	return v5.name, v5.count or 1
end
