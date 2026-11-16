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
		userId = v5.userId or 1234,
		partyVoiceEligible = v5.partyVoiceEligible or false
	}))
end

function class.format(p2)
	return (class.new({ userId = p2.userId, partyVoiceEligible = p2.partyVoiceEligible }))
end

class.isValid = t.interface({
	userId = t.number,
	partyVoiceEligible = t.optional(t.boolean)
})

return class
