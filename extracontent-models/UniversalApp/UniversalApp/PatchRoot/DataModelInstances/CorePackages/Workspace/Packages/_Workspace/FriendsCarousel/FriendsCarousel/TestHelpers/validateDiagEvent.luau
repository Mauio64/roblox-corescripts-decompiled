local ParentParent = script.Parent.Parent
local DiagActionList = require(ParentParent.Analytics.DiagActionList)
local EventNames = require(ParentParent.Analytics.EventNames)

return function(p1) -- line: 5
	-- upvalues: EventNames (copy), DiagActionList (copy)
	assert(EventNames.isEnumValue(p1), "Invalid event name")

	local v5 = DiagActionList[p1]

	return v5.name, v5.count or 1
end
