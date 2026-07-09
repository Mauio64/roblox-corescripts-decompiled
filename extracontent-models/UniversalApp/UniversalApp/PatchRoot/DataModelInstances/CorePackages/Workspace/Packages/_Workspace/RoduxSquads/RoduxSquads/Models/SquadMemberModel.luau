local Parent = script:FindFirstAncestor("RoduxSquads").Parent
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
		userId = v6.userId or 1234,
		partyVoiceEligible = v6.partyVoiceEligible or false
	}))
end
function t1.format(p3) -- line: 31
	-- upvalues: t1 (copy)
	return (t1.new({
		userId = p3.userId,
		partyVoiceEligible = p3.partyVoiceEligible
	}))
end

t1.isValid = t.interface({
	userId = t.number,
	partyVoiceEligible = t.optional(t.boolean)
})

return t1
