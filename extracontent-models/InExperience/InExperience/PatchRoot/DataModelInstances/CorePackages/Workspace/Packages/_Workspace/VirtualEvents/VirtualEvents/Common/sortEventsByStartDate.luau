local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function sortEventsByStartDate(p)
	local clone = table.clone(p)
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
