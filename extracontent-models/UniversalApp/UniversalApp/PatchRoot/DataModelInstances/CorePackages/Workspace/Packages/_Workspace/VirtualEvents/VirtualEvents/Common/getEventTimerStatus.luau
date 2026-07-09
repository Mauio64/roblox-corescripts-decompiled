local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)
require(VirtualEvents.Parent.VirtualEventsState)

local getVirtualEventDates = require(VirtualEvents.Common.getVirtualEventDates)

local function getEventTimerStatus(p1, p2) -- line: 11
	-- upvalues: getVirtualEventDates (copy)
	local v6 = getVirtualEventDates(p1)
	local v7 = v6.startDate.UnixTimestamp - p2.UnixTimestamp
	local v8 = v6.endDate.UnixTimestamp - p2.UnixTimestamp

	if p2.UnixTimestamp >= v6.startDate.UnixTimestamp then
		if p2.UnixTimestamp < v6.endDate.UnixTimestamp then
			if v8 <= 14400 then
				return "ElapsedImminent"
			end

			return "Ongoing"
		end

		return "Elapsed"
	end

	if v7 > 0 and v7 <= 14400 then
		return "UpcomingImminent"
	end

	return "Upcoming"
end

return getEventTimerStatus
