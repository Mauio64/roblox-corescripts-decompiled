require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local getVirtualEventDates = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/getVirtualEventDates")

local function getEventTimerStatus(p2, p3): string
	local v5 = getVirtualEventDates(p2)

	local v6 = v5.startDate.UnixTimestamp - p3.UnixTimestamp
	local v7 = v5.endDate.UnixTimestamp - p3.UnixTimestamp

	if p3.UnixTimestamp >= v5.startDate.UnixTimestamp then
		if p3.UnixTimestamp < v5.endDate.UnixTimestamp then
			if v7 <= 14400 then
				return "ElapsedImminent"
			end

			return "Ongoing"
		end

		return "Elapsed"
	elseif v6 > 0 and v6 <= 14400 then
		return "UpcomingImminent"
	else
		return "Upcoming"
	end
end

return getEventTimerStatus
