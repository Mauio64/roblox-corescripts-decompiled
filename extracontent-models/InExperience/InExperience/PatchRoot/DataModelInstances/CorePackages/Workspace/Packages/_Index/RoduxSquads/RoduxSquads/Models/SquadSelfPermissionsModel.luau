local parent = script:FindFirstAncestor("RoduxSquads").Parent

local t = require(parent.t)

local SquadSelfPermissionsModel = {}

function SquadSelfPermissionsModel.new(p)
	assert(SquadSelfPermissionsModel.isValid(p))

	SquadSelfPermissionsModel.__index = SquadSelfPermissionsModel

	setmetatable(p, SquadSelfPermissionsModel)

	return p
end

function SquadSelfPermissionsModel.mock(options)
	local v = options or {}

	return (SquadSelfPermissionsModel.new({
		canSeeRegroupPromptToast = v.canSeeRegroupPromptToast or false,
		canSeeRegroupJoinButton = v.canSeeRegroupJoinButton or false
	}))
end

function SquadSelfPermissionsModel.format(p)
	return (SquadSelfPermissionsModel.new({
		canSeeRegroupPromptToast = p.canSeeRegroupPromptToast,
		canSeeRegroupJoinButton = p.canSeeRegroupJoinButton
	}))
end

SquadSelfPermissionsModel.isValid = t.interface({
	canSeeRegroupPromptToast = t.boolean,
	canSeeRegroupJoinButton = t.boolean
})

return SquadSelfPermissionsModel
