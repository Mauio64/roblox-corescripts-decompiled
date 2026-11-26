require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/types")

local function createMockVirtualEventResponse(p2)
	return {
		id = p2,
		title = "Event Title",
		description = "Event description...",
		host = {
			hostType = "user",
			hostId = 1,
			hostName = "Roblox",
			hasVerifiedBadge = false
		},
		eventTime = {
			startUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
			endUtc = DateTime.fromLocalTime(2022, 1, 7):ToIsoDate()
		},
		universeId = 1,
		placeId = 123456789,
		eventStatus = "active",
		createdUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
		updatedUtc = DateTime.fromLocalTime(2022, 1, 1):ToIsoDate(),
		userRsvpStatus = "none"
	}
end

return createMockVirtualEventResponse
