local parent = script:FindFirstAncestor("RoduxSquads").Parent

local t = require(parent.t)

local SquadInviteeModel = {}

function SquadInviteeModel.new(p)
	assert(SquadInviteeModel.isValid(p))

	SquadInviteeModel.__index = SquadInviteeModel

	setmetatable(p, SquadInviteeModel)

	return p
end

function SquadInviteeModel.mock(options)
	local v = options or {}

	return (SquadInviteeModel.new({
		invitedAtTimestampMs = v.invitedAtTimestampMs or 333333,
		userId = v.userId or 11111111
	}))
end

function SquadInviteeModel.format(p)
	return (SquadInviteeModel.new({
		invitedAtTimestampMs = p.invitedAtTimestampMs,
		userId = p.userId
	}))
end

SquadInviteeModel.isValid = t.interface({ invitedAtTimestampMs = t.number, userId = t.number })

return SquadInviteeModel
