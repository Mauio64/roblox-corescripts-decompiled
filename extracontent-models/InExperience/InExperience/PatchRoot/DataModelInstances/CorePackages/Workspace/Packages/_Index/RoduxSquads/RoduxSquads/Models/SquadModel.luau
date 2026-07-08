local Parent = script:FindFirstAncestor("RoduxSquads").Parent
local SquadInviteeModel = require(script.Parent.SquadInviteeModel)
local SquadMemberModel = require(script.Parent.SquadMemberModel)
local SquadSelfPermissionsModel = require(script.Parent.SquadSelfPermissionsModel)
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local FFlagEnableSquadRegroupExperimentation = require(Parent.SharedFlags).FFlagEnableSquadRegroupExperimentation
local t1 = {}

function t1.new(p1) -- line: 15
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function tryGetSquadId(p2) -- line: 28
	return p2.groupUpId or p2.squadId
end
function t1.mock(p3) -- line: 32
	-- upvalues: Cryo (copy), SquadMemberModel (copy), SquadInviteeModel (copy), t1 (copy), FFlagEnableSquadRegroupExperimentation (copy)
	local v12 = p3 or {}
	local v13 = Cryo.List.map(v12.members or {{
		userId = 1234
	}}, function(p4) -- line: 35
		-- upvalues: SquadMemberModel (copy)
		return SquadMemberModel.mock(p4)
	end)
	local v14 = Cryo.List.map(v12.invitees or {{
		userId = 2345,
		invitedAtTimestampMs = 3333333
	}}, function(p5) -- line: 41
		-- upvalues: SquadInviteeModel (copy)
		return SquadInviteeModel.mock(p5)
	end)
	local t2 = {
		canSeeRegroupPromptToast = false,
		canSeeRegroupJoinButton = false
	}

	return (t1.new({
		squadId = tryGetSquadId(v12) or "12345",
		initiatorId = v12.initiatorId or 54321,
		createdAtTime = v12.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		updatedAtTime = v12.updatedAtTime or "2024-07-19T21:02:47.777+00:00",
		deletedAtTime = v12.deletedAtTime,
		parentChannelId = v12.parentChannelId or "23456",
		members = v13,
		invitees = v14,
		selfPermissions = if not FFlagEnableSquadRegroupExperimentation then nil else v12.selfPermissions or t2
	}))
end
function t1.format(p6) -- line: 68
	-- upvalues: Cryo (copy), SquadMemberModel (copy), SquadInviteeModel (copy), t1 (copy), FFlagEnableSquadRegroupExperimentation (copy)
	local v17 = Cryo.List.map(p6.members, function(p7) -- line: 69
		-- upvalues: SquadMemberModel (copy)
		return SquadMemberModel.format(p7)
	end)
	local v18 = Cryo.List.map(p6.invitees, function(p8) -- line: 73
		-- upvalues: SquadInviteeModel (copy)
		return SquadInviteeModel.format(p8)
	end)

	return (t1.new({
		createdAtTime = p6.createdAtTime,
		deletedAtTime = p6.deletedAtTime,
		initiatorId = p6.initiatorId,
		invitees = v18,
		members = v17,
		parentChannelId = p6.parentChannelId,
		squadId = tryGetSquadId(p6),
		updatedAtTime = p6.updatedAtTime,
		selfPermissions = if not FFlagEnableSquadRegroupExperimentation then nil else p6.selfPermissions
	}))
end

t1.isValid = t.strictInterface({
	createdAtTime = t.string,
	deletedAtTime = t.optional(t.string),
	initiatorId = t.number,
	invitees = t.array(SquadInviteeModel.isValid),
	members = t.array(SquadMemberModel.isValid),
	parentChannelId = t.string,
	squadId = t.string,
	updatedAtTime = t.string,
	selfPermissions = if not FFlagEnableSquadRegroupExperimentation then t.none else t.optional(SquadSelfPermissionsModel.isValid)
})

return t1
