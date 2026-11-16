local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)

local function getSecondsLeftInEvent(p, p2)
	local virtualEventDates = getVirtualEventDates(p)

	if p2.UnixTimestamp < virtualEventDates.startDate.UnixTimestamp then
		return 1e999
	end

	if p2.UnixTimestamp > virtualEventDates.endDate.UnixTimestamp then
		return 0
	end

	return virtualEventDates.endDate.UnixTimestamp - virtualEventDates.startDate.UnixTimestamp - (p2.UnixTimestamp - virtualEventDates.startDate.UnixTimestamp)
end

return getSecondsLeftInEvent
