local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function getVirtualEventDates(p)
	local dateTime

	if p.eventTime and p.eventTime.startUtc then
		dateTime = DateTime.fromIsoDate(p.eventTime.startUtc)
	end

	local v

	if p.eventTime and p.eventTime.endUtc then
		v = DateTime.fromIsoDate(p.eventTime.endUtc)
	end

	return {
		startDate = dateTime or DateTime.now(),
		endDate = v or DateTime.now()
	}
end

return getVirtualEventDates
