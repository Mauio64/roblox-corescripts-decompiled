local t = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/t")

local ExperienceInviteState = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Enums/ExperienceInviteState")
local ExperienceInviteVoteType = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Enums/ExperienceInviteVoteType")
local ExperienceInviteType = require("@game/CorePackages/Workspace/Packages/_Index/RoduxSquads/RoduxSquads/Enums/ExperienceInviteType")

local fFlagEnablePrivatePartyAcceptInvite = require("@game/CorePackages/Workspace/Packages/_Workspace/RoduxSquads/SharedFlags").FFlagEnablePrivatePartyAcceptInvite

local function getSpotsTaken(list)
	local count = 0

	for i = 1, #list do
		if list[i].voteType == ExperienceInviteVoteType.Accept then
			count += 1
		end
	end

	return count
end

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local v5 = options or {}

	local votes = v5.votes or {
		{ userId = 456, voteIdentifier = "voteIdentifier", voteType = ExperienceInviteVoteType.Accept }
	}
	local count = 0

	for i = 1, #votes do
		if votes[i].voteType == ExperienceInviteVoteType.Accept then
			count += 1
		end
	end

	local v6 = class.new({
		createdAtTime = v5.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		experienceInviteId = v5.experienceInviteId or "987",
		experienceDetail = v5.experienceDetail or {
			placeId = 15308759682,
			gameInstanceId = "instanceId"
		},
		inviterId = v5.inviterId or 123456,
		membershipEntityId = v5.membershipEntityId or "54321",
		spotsTaken = count,
		state = v5.state or ExperienceInviteState.Active,
		totalSpots = v5.totalSpots or 6,
		versionId = v5.version or 1,
		votes = votes
	})

	if fFlagEnablePrivatePartyAcceptInvite then
		v6.inviteType = v5.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v6
end

function class.format(data)
	local votes = data.votes
	local new = class.new
	local v5 = {
		createdAtTime = data.createdAtTime,
		experienceDetail = data.experienceDetail,
		experienceInviteId = data.experienceInviteId,
		inviterId = data.inviterId,
		membershipEntityId = data.membershipEntityId,
		spotsTaken = 0,
		state = 0,
		totalSpots = 0,
		versionId = 0,
		votes = 0
	}
	local count = 0

	for i = 1, #votes do
		if votes[i].voteType == ExperienceInviteVoteType.Accept then
			count += 1
		end
	end

	v5.spotsTaken = count
	v5.state = data.state
	v5.totalSpots = data.totalSpots
	v5.versionId = data.versionId
	v5.votes = votes
	local v6 = new(v5)

	if fFlagEnablePrivatePartyAcceptInvite then
		v6.inviteType = data.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v6
end

class.isValid = t.strictInterface({
	createdAtTime = t.string,
	experienceDetail = t.interface({
		placeId = t.number,
		gameInstanceId = t.optional(t.string)
	}),
	experienceInviteId = t.string,
	inviterId = t.number,
	membershipEntityId = t.string,
	spotsTaken = t.number,
	state = t.string,
	totalSpots = t.number,
	versionId = t.number,
	votes = t.array(t.interface({
		userId = t.number,
		voteIdentifier = t.optional(t.string),
		voteType = t.string
	})),
	inviteType = t.optional(t.union(
		t.literal(ExperienceInviteType.PlayWithPartyInPublicServer),
		t.literal(ExperienceInviteType.PlayWithPartyInPrivatePartyServer)
	))
})

return class
