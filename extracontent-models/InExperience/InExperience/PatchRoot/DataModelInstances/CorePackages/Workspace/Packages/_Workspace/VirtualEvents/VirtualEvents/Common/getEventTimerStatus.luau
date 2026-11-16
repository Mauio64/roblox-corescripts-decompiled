local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
require(VirtualEvents.Parent.VirtualEventsState)
local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)

local function getEventTimerStatus(p, p2): string
	local virtualEventDates = getVirtualEventDates(p)

	local v = virtualEventDates.startDate.UnixTimestamp - p2.UnixTimestamp
	local v2 = virtualEventDates.endDate.UnixTimestamp - p2.UnixTimestamp

	if p2.UnixTimestamp >= virtualEventDates.startDate.UnixTimestamp then
		if p2.UnixTimestamp < virtualEventDates.endDate.UnixTimestamp then
			return if v2 <= 14400 then "ElapsedImminent" else "Ongoing"
		end

		return "Elapsed"
	elseif v > 0 and v <= 14400 then
		return "UpcomingImminent"
	else
		return "Upcoming"
	end
end

return getEventTimerStatus
