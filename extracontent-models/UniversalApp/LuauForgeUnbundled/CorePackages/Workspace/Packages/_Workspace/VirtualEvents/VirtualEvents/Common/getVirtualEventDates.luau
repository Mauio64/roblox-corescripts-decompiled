require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")

local function getVirtualEventDates(p2)
	local dateTime

	if p2.eventTime and p2.eventTime.startUtc then
		dateTime = DateTime.fromIsoDate(p2.eventTime.startUtc)
	end

	local v5 = if p2.eventTime and p2.eventTime.endUtc then DateTime.fromIsoDate(p2.eventTime.endUtc) else nil

	return {
		startDate = dateTime or DateTime.now(),
		endDate = v5 or DateTime.now()
	}
end

return getVirtualEventDates
