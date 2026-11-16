require("@game/CorePackages/Workspace/Packages/_Workspace/GraphQLServer/GraphQLServer/graphql/generatedTypes")

local function createMockVirtualEvent(p2)
	local now = DateTime.now()
	local dateTime = DateTime.fromUnixTimestamp(now.UnixTimestamp + 86400)

	return {
		id = p2,
		title = "Event Name",
		description = "Event description goes here...",
		host = {
			hostType = "user",
			hostId = "1",
			hostName = "Roblox",
			hasVerifiedBadge = true
		},
		eventTime = {
			startUtc = now:ToIsoDate(),
			endUtc = dateTime:ToIsoDate(),
			startTime = now,
			endTime = dateTime
		},
		universeId = "3531439676",
		eventStatus = "active",
		createdTime = now,
		updatedTime = now,
		userRsvpStatus = "none",
		eventCategories = {
			{ category = "challenge", rank = 0 },
			{ category = "newContent", rank = 1 }
		},
		experienceDetails = {
			id = "3531439676",
			name = "Experience Name",
			playing = 50000
		},
		rsvpCounters = { going = 2500, notGoing = 0, none = 0, maybeGoing = 0 },
		rsvps = {
			{ userId = "957765952", rsvpStatus = "going" },
			{ userId = "35392", rsvpStatus = "going" },
			{ userId = "4416634", rsvpStatus = "going" },
			{ userId = "1893522417", rsvpStatus = "going" },
			{ userId = "1343930", rsvpStatus = "going" },
			{ userId = "29819622", rsvpStatus = "notGoing" },
			{ userId = "1668748746", rsvpStatus = "notGoing" },
			{ userId = "308199922", rsvpStatus = "notGoing" }
		}
	}
end

return createMockVirtualEvent
