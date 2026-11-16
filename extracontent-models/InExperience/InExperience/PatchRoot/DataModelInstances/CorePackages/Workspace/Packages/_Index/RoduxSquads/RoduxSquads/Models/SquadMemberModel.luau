local parent = script:FindFirstAncestor("RoduxSquads").Parent

local t = require(parent.t)

local SquadMemberModel = {}

function SquadMemberModel.new(p)
	assert(SquadMemberModel.isValid(p))

	SquadMemberModel.__index = SquadMemberModel

	setmetatable(p, SquadMemberModel)

	return p
end

function SquadMemberModel.mock(options)
	local v = options or {}

	return (SquadMemberModel.new({
		userId = v.userId or 1234,
		partyVoiceEligible = v.partyVoiceEligible or false
	}))
end

function SquadMemberModel.format(p)
	return (SquadMemberModel.new({ userId = p.userId, partyVoiceEligible = p.partyVoiceEligible }))
end

SquadMemberModel.isValid = t.interface({
	userId = t.number,
	partyVoiceEligible = t.optional(t.boolean)
})

return SquadMemberModel
