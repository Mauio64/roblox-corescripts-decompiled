local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventNames = require(ParentParent.Analytics.Enums.EventNames)
local llama = dependencies.llama

return function(p1, p2) -- line: 7
	-- upvalues: EventNames (copy), AnalyticsEvents (copy), llama (copy)
	assert(EventNames.isEnumValue(p1), "Invalid event name")

	local v8 = AnalyticsEvents[p1]

	return v8.context, v8.eventType, llama.Dictionary.join(v8.additionalInfo, {
		btn = if not v8.additionalInfo or not v8.additionalInfo.btn then nil else v8.additionalInfo.btn.rawValue()
	}, p2)
end
