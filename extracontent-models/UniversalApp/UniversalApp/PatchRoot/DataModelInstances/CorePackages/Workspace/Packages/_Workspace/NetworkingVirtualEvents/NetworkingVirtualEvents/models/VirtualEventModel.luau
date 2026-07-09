local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

require(NetworkingVirtualEvents.types)

return {
	mock = function(s1: string) -- line: 7
		local dateTime = DateTime.now()
		local dateTime2 = DateTime.fromUnixTimestamp(dateTime.UnixTimestamp + 86400)

		return {
			title = "Event Name",
			description = "Event description goes here...",
			universeId = 3531439676,
			placeId = 123456789,
			eventStatus = "active",
			userRsvpStatus = "none",
			id = s1,
			host = {
				hostType = "user",
				hostId = 1,
				hostName = "Roblox",
				hasVerifiedBadge = true
			},
			eventTime = {
				startTime = dateTime,
				endTime = dateTime2,
				startUtc = dateTime:ToIsoDate(),
				endUtc = dateTime:ToIsoDate()
			},
			createdTime = dateTime,
			updatedTime = dateTime
		}
	end,
	fromResponse = function(p1) -- line: 38
		local dateTime = DateTime.fromIsoDate(p1.eventTime.startUtc)
		local dateTime3 = DateTime.fromIsoDate(p1.eventTime.endUtc)
		local dateTime4 = DateTime.fromIsoDate(p1.createdUtc)
		local dateTime5 = DateTime.fromIsoDate(p1.updatedUtc)

		if dateTime and (dateTime3 and dateTime4 and dateTime5) then
			return {
				id = p1.id,
				title = p1.title,
				description = p1.description,
				host = p1.host,
				eventTime = {
					startTime = dateTime,
					endTime = dateTime3,
					startUtc = p1.eventTime.startUtc,
					endUtc = p1.eventTime.endUtc
				},
				universeId = p1.universeId,
				placeId = p1.placeId,
				eventStatus = p1.eventStatus,
				createdTime = dateTime4,
				updatedTime = dateTime5,
				userRsvpStatus = p1.userRsvpStatus
			}
		end

		return nil
	end
}
