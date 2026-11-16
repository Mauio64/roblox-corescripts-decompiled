local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/t")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local v5 = options or {}

	return (class.new({
		createdAtTime = v5.createdAtTime or "2025-07-02T18:00:00Z",
		initiatorId = v5.initiatorId or 54321,
		parentChannelId = v5.parentChannelId or "23456",
		scheduledGroupUpId = v5.scheduledGroupUpId or 12345,
		startTime = v5.startTime or "2500-07-02T18:00:00Z",
		subscribers = v5.subscribers or {
			{ userId = 12345 }
		},
		title = v5.title or "Cool Test Scheduled Party",
		updatedAtTime = v5.updatedAtTime or "2025-07-02T18:00:00Z"
	}))
end

function class.format(p2)
	return (class.new({
		createdAtTime = p2.scheduledGroupUp.createdAtTime,
		initiatorId = p2.scheduledGroupUp.initiatorId,
		parentChannelId = p2.scheduledGroupUp.parentChannelId,
		scheduledGroupUpId = p2.scheduledGroupUp.scheduledGroupUpId,
		startTime = p2.scheduledGroupUp.startTime,
		subscribers = p2.scheduledGroupUp.subscribers,
		title = p2.scheduledGroupUp.title,
		updatedAtTime = p2.scheduledGroupUp.updatedAtTime
	}))
end

class.isValid = t.strictInterface({
	createdAtTime = t.string,
	initiatorId = t.number,
	parentChannelId = t.string,
	scheduledGroupUpId = t.number,
	startTime = t.string,
	subscribers = t.array(t.strictInterface({ userId = t.number })),
	title = t.string,
	updatedAtTime = t.string
})

return class
