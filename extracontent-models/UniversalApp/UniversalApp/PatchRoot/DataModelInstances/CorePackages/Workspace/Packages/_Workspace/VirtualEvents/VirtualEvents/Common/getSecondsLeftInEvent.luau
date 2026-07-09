local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)

local function getSecondsLeftInEvent(p1, p2) -- line: 6
	-- upvalues: getVirtualEventDates (copy)
	local v6 = getVirtualEventDates(p1)

	if p2.UnixTimestamp < v6.startDate.UnixTimestamp then
		return 1e999
	end

	if p2.UnixTimestamp > v6.endDate.UnixTimestamp then
		return 0
	end

	return v6.endDate.UnixTimestamp - v6.startDate.UnixTimestamp - (p2.UnixTimestamp - v6.startDate.UnixTimestamp)
end

return getSecondsLeftInEvent
