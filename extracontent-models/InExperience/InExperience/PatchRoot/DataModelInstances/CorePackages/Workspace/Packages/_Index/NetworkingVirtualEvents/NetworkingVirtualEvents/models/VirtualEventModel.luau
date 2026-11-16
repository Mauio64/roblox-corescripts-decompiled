local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")

require(NetworkingVirtualEvents.types)
local VirtualEventModel = {}

function VirtualEventModel.mock(id: string)
	local now = DateTime.now()
	return {
		id = id,
		title = "Event Name",
		description = "Event description goes here...",
		host = { hostType = "user", hostId = 1, hostName = "Roblox", hasVerifiedBadge = true },
		eventTime = {
			startTime = now,
			endTime = DateTime.fromUnixTimestamp(now.UnixTimestamp + 86400),
			startUtc = now:ToIsoDate(),
			endUtc = now:ToIsoDate()
		},
		universeId = 3531439676,
		placeId = 123456789,
		eventStatus = "active",
		createdTime = now,
		updatedTime = now,
		userRsvpStatus = "none"
	}
end

function VirtualEventModel.fromResponse(data)
	local dateTime = DateTime.fromIsoDate(data.eventTime.startUtc)
	local dateTime2 = DateTime.fromIsoDate(data.eventTime.endUtc)
	local dateTime3 = DateTime.fromIsoDate(data.createdUtc)
	local dateTime4 = DateTime.fromIsoDate(data.updatedUtc)

	if dateTime and dateTime2 and dateTime3 and dateTime4 then
		return {
			id = data.id,
			title = data.title,
			description = data.description,
			host = data.host,
			eventTime = {
				startTime = dateTime,
				endTime = dateTime2,
				startUtc = data.eventTime.startUtc,
				endUtc = data.eventTime.endUtc
			},
			universeId = data.universeId,
			placeId = data.placeId,
			eventStatus = data.eventStatus,
			createdTime = dateTime3,
			updatedTime = dateTime4,
			userRsvpStatus = data.userRsvpStatus
		}
	end

	return nil
end

return VirtualEventModel
