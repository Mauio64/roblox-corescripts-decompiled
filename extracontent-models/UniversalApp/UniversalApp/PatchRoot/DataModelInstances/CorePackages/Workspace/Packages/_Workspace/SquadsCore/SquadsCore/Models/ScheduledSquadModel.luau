local Parent = script:FindFirstAncestor("SquadsCore").Parent
local t = require(Parent.t)
local t1 = {}

function t1.new(p1) -- line: 8
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 20
	-- upvalues: t1 (copy)
	local v6 = p2 or {}

	return (t1.new({
		createdAtTime = v6.createdAtTime or "2025-07-02T18:00:00Z",
		initiatorId = v6.initiatorId or 54321,
		parentChannelId = v6.parentChannelId or "23456",
		scheduledGroupUpId = v6.scheduledGroupUpId or 12345,
		startTime = v6.startTime or "2500-07-02T18:00:00Z",
		subscribers = v6.subscribers or {{
			userId = 12345
		}},
		title = v6.title or "Cool Test Scheduled Party",
		updatedAtTime = v6.updatedAtTime or "2025-07-02T18:00:00Z"
	}))
end
function t1.format(p3) -- line: 37
	-- upvalues: t1 (copy)
	return (t1.new({
		createdAtTime = p3.scheduledGroupUp.createdAtTime,
		initiatorId = p3.scheduledGroupUp.initiatorId,
		parentChannelId = p3.scheduledGroupUp.parentChannelId,
		scheduledGroupUpId = p3.scheduledGroupUp.scheduledGroupUpId,
		startTime = p3.scheduledGroupUp.startTime,
		subscribers = p3.scheduledGroupUp.subscribers,
		title = p3.scheduledGroupUp.title,
		updatedAtTime = p3.scheduledGroupUp.updatedAtTime
	}))
end

t1.isValid = t.strictInterface({
	createdAtTime = t.string,
	initiatorId = t.number,
	parentChannelId = t.string,
	scheduledGroupUpId = t.number,
	startTime = t.string,
	subscribers = t.array(t.strictInterface({
		userId = t.number
	})),
	title = t.string,
	updatedAtTime = t.string
})

return t1
