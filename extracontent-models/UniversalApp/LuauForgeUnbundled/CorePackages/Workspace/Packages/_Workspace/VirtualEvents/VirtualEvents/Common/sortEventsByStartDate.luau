require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")

local function sortEventsByStartDate(p2)
	local clone = table.clone(p2)
	table.sort(clone, function(a, b): boolean
		if a.eventTime and a.eventTime.startUtc and b.eventTime and b.eventTime.startUtc then
			local dateTime = DateTime.fromIsoDate(a.eventTime.startUtc) or DateTime.now()
			local dateTime2 = DateTime.fromIsoDate(b.eventTime.startUtc) or DateTime.now()

			return dateTime.UnixTimestamp < dateTime2.UnixTimestamp
		end

		return true
	end)

	return clone
end

return sortEventsByStartDate
