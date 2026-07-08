local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

require(VirtualEvents.Parent.GraphQLServer)

local function sortEventsByStartDate(t1: {[any]: any}) -- line: 7
	local v4 = table.clone(t1)

	table.sort(v4, function(p1, p2) -- line: 9
		if p1.eventTime and (p1.eventTime.startUtc and p2.eventTime and p2.eventTime.startUtc) then
			local v7 = DateTime.fromIsoDate(p1.eventTime.startUtc) or DateTime.now()
			local v8 = DateTime.fromIsoDate(p2.eventTime.startUtc) or DateTime.now()

			return v7.UnixTimestamp < v8.UnixTimestamp
		end

		return true
	end)

	return v4
end

return sortEventsByStartDate
