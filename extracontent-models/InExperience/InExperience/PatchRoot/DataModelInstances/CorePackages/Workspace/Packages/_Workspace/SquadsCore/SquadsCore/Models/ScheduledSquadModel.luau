local parent = script:FindFirstAncestor("SquadsCore").Parent

local t = require(parent.t)

local ScheduledSquadModel = {}

function ScheduledSquadModel.new(p)
	assert(ScheduledSquadModel.isValid(p))

	ScheduledSquadModel.__index = ScheduledSquadModel

	setmetatable(p, ScheduledSquadModel)

	return p
end

function ScheduledSquadModel.mock(options)
	local v = options or {}

	return (ScheduledSquadModel.new({
		createdAtTime = v.createdAtTime or "2025-07-02T18:00:00Z",
		initiatorId = v.initiatorId or 54321,
		parentChannelId = v.parentChannelId or "23456",
		scheduledGroupUpId = v.scheduledGroupUpId or 12345,
		startTime = v.startTime or "2500-07-02T18:00:00Z",
		subscribers = v.subscribers or {
			{ userId = 12345 }
		},
		title = v.title or "Cool Test Scheduled Party",
		updatedAtTime = v.updatedAtTime or "2025-07-02T18:00:00Z"
	}))
end

function ScheduledSquadModel.format(p)
	return (ScheduledSquadModel.new({
		createdAtTime = p.scheduledGroupUp.createdAtTime,
		initiatorId = p.scheduledGroupUp.initiatorId,
		parentChannelId = p.scheduledGroupUp.parentChannelId,
		scheduledGroupUpId = p.scheduledGroupUp.scheduledGroupUpId,
		startTime = p.scheduledGroupUp.startTime,
		subscribers = p.scheduledGroupUp.subscribers,
		title = p.scheduledGroupUp.title,
		updatedAtTime = p.scheduledGroupUp.updatedAtTime
	}))
end

ScheduledSquadModel.isValid = t.strictInterface({
	createdAtTime = t.string,
	initiatorId = t.number,
	parentChannelId = t.string,
	scheduledGroupUpId = t.number,
	startTime = t.string,
	subscribers = t.array(t.strictInterface({ userId = t.number })),
	title = t.string,
	updatedAtTime = t.string
})

return ScheduledSquadModel
