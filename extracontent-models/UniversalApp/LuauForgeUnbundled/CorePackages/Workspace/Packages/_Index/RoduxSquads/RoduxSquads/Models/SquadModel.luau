local SquadInviteeModel = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models/SquadInviteeModel")
local SquadMemberModel = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models/SquadMemberModel")
local SquadSelfPermissionsModel = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Models/SquadSelfPermissionsModel")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/t")

local fFlagEnableSquadRegroupExperimentation = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagEnableSquadRegroupExperimentation

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function LUAUFORGE_MODULE_GLOBALS_bsj_tryGetSquadId(p2)
	return p2.groupUpId or p2.squadId
end

function class.mock(options)
	local v5 = options or {}

	local mapped = Cryo.List.map(v5.members or {
		{ userId = 1234 }
	}, function(p2)
		return SquadMemberModel.mock(p2)
	end)

	local mapped2 = Cryo.List.map(v5.invitees or {
		{ userId = 2345, invitedAtTimestampMs = 3333333 }
	}, function(p2)
		return SquadInviteeModel.mock(p2)
	end)

	local new = class.new
	local v7 = {
		squadId = LUAUFORGE_MODULE_GLOBALS_bsj_tryGetSquadId(v5) or "12345",
		initiatorId = v5.initiatorId or 54321,
		createdAtTime = v5.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		updatedAtTime = v5.updatedAtTime or "2024-07-19T21:02:47.777+00:00",
		deletedAtTime = v5.deletedAtTime,
		parentChannelId = v5.parentChannelId or "23456",
		members = mapped,
		invitees = mapped2,
		selfPermissions = 0
	}
	local v8 = if fFlagEnableSquadRegroupExperimentation then v5.selfPermissions or {
		canSeeRegroupPromptToast = false,
		canSeeRegroupJoinButton = false
	} else nil
	v7.selfPermissions = v8
	return (new(v7))
end

function class.format(data)
	local mapped = Cryo.List.map(data.members, function(p2)
		return SquadMemberModel.format(p2)
	end)

	local mapped2 = Cryo.List.map(data.invitees, function(p2)
		return SquadInviteeModel.format(p2)
	end)

	local new = class.new
	local v5 = {
		createdAtTime = data.createdAtTime,
		deletedAtTime = data.deletedAtTime,
		initiatorId = data.initiatorId,
		invitees = mapped2,
		members = mapped,
		parentChannelId = data.parentChannelId,
		squadId = LUAUFORGE_MODULE_GLOBALS_bsj_tryGetSquadId(data),
		updatedAtTime = data.updatedAtTime,
		selfPermissions = 0
	}
	local v6 = if fFlagEnableSquadRegroupExperimentation then data.selfPermissions else nil
	v5.selfPermissions = v6
	return (new(v5))
end

local strictInterface = t.strictInterface
local v5 = {
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

local v6 = if fFlagEnableSquadRegroupExperimentation then t.optional(SquadSelfPermissionsModel.isValid) else t.none
v5.selfPermissions = v6
class.isValid = strictInterface(v5)

return class
