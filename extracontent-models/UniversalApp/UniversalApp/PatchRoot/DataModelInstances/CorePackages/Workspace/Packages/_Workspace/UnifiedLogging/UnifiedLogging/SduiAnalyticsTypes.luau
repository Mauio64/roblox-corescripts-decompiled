local Parent = script:FindFirstAncestor("UnifiedLogging").Parent
local t = require(Parent.t)
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport
local t1 = {
	collectionId = t.union(t.number, t.string),
	contentType = t.string,
	itemsPerRow = t.number,
	collectionPosition = t.number,
	startRowNumber = t.optional(t.number),
	totalNumberOfItems = t.number,
	refId = if not FFlagSduiExperienceDetailsSupport then nil else t.optional(t.string)
}
local t2 = {
	id = t.union(t.number, t.string),
	itemPosition = t.optional(t.number)
}

return {
	CollectionAnalyticsDataInterface = t1,
	ItemAnalyticsDataInterface = t2
}
