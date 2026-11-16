local t = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/t")

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
		invitedAtTimestampMs = v5.invitedAtTimestampMs or 333333,
		userId = v5.userId or 11111111
	}))
end

function class.format(p2)
	return (class.new({
		invitedAtTimestampMs = p2.invitedAtTimestampMs,
		userId = p2.userId
	}))
end

class.isValid = t.interface({
	invitedAtTimestampMs = t.number,
	userId = t.number
})

return class
