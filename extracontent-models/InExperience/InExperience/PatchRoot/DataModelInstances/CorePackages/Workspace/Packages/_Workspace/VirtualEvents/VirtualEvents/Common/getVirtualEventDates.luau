local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function getVirtualEventDates(p1) -- line: 10
	local v4 = if not p1.eventTime or not p1.eventTime.startUtc then nil else DateTime.fromIsoDate(p1.eventTime.startUtc)
	local v5 = if not p1.eventTime or not p1.eventTime.endUtc then nil else DateTime.fromIsoDate(p1.eventTime.endUtc)

	return {
		startDate = v4 or DateTime.now(),
		endDate = v5 or DateTime.now()
	}
end

return getVirtualEventDates
