local parent = script:FindFirstAncestor("RoduxSquads").Parent

local SquadInviteeModel = require(script.Parent.SquadInviteeModel)
local SquadMemberModel = require(script.Parent.SquadMemberModel)
local SquadSelfPermissionsModel = require(script.Parent.SquadSelfPermissionsModel)

local Cryo = require(parent.Cryo)
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

local SquadModel = {}

function SquadModel.new(p)
	assert(SquadModel.isValid(p))

	SquadModel.__index = SquadModel

	setmetatable(p, SquadModel)

	return p
end

function tryGetSquadId(p)
	return p.groupUpId or p.squadId
end

function SquadModel.mock(options)
	local v = options or {}

	local mapped = Cryo.List.map(v.members or {
		{ userId = 1234 }
	}, function(p)
		return SquadMemberModel.mock(p)
	end)

	local mapped2 = Cryo.List.map(v.invitees or {
		{ userId = 2345, invitedAtTimestampMs = 3333333 }
	}, function(p)
		return SquadInviteeModel.mock(p)
	end)

	local v2 = { canSeeRegroupPromptToast = false, canSeeRegroupJoinButton = false }

	local new = SquadModel.new
	local v3 = {
		squadId = tryGetSquadId(v) or "12345",
		initiatorId = v.initiatorId or 54321,
		createdAtTime = v.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		updatedAtTime = v.updatedAtTime or "2024-07-19T21:02:47.777+00:00",
		deletedAtTime = v.deletedAtTime,
		parentChannelId = v.parentChannelId or "23456",
		members = mapped,
		invitees = mapped2,
		selfPermissions = 0
	}
	local selfPermissions

	if FFlagEnableSquadRegroupExperimentation then
		selfPermissions = v.selfPermissions or v2
	end

	v3.selfPermissions = selfPermissions
	return (new(v3))
end

function SquadModel.format(data)
	local mapped = Cryo.List.map(data.members, function(p)
		return SquadMemberModel.format(p)
	end)

	local mapped2 = Cryo.List.map(data.invitees, function(p)
		return SquadInviteeModel.format(p)
	end)

	local new = SquadModel.new
	local v = {
		createdAtTime = data.createdAtTime,
		deletedAtTime = data.deletedAtTime,
		initiatorId = data.initiatorId,
		invitees = mapped2,
		members = mapped,
		parentChannelId = data.parentChannelId,
		squadId = tryGetSquadId(data),
		updatedAtTime = data.updatedAtTime,
		selfPermissions = 0
	}
	local selfPermissions

	if FFlagEnableSquadRegroupExperimentation then
		selfPermissions = data.selfPermissions
	end

	v.selfPermissions = selfPermissions
	return (new(v))
end

local strictInterface = t.strictInterface
local v = {
	createdAtTime = t.string,
	deletedAtTime = t.optional(t.string),
	initiatorId = t.number,
	invitees = t.array(SquadInviteeModel.isValid),
	members = t.array(SquadMemberModel.isValid),
	parentChannelId = t.string,
	squadId = t.string,
	updatedAtTime = t.string,
	selfPermissions = 0
}
local selfPermissions

if FFlagEnableSquadRegroupExperimentation then
	selfPermissions = t.optional(SquadSelfPermissionsModel.isValid)
else
	selfPermissions = t.none
end

v.selfPermissions = selfPermissions
SquadModel.isValid = strictInterface(v)

return SquadModel
