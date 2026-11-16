local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local parent = RoduxSquads.Parent

local t = require(parent.t)

local ExperienceInviteState = require(RoduxSquads.Enums.ExperienceInviteState)
local ExperienceInviteVoteType = require(RoduxSquads.Enums.ExperienceInviteVoteType)
local ExperienceInviteType = require(RoduxSquads.Enums.ExperienceInviteType)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePrivatePartyAcceptInvite = SharedFlags.FFlagEnablePrivatePartyAcceptInvite

local function getSpotsTaken(votes) -- 2 equivalent calls inferred from this helper
	local count = 0

	for i = 1, #votes do
		if votes[i].voteType == ExperienceInviteVoteType.Accept then
			count += 1
		end
	end

	return count
end

local ExperienceInviteModel = {}

function ExperienceInviteModel.new(p)
	assert(ExperienceInviteModel.isValid(p))

	ExperienceInviteModel.__index = ExperienceInviteModel

	setmetatable(p, ExperienceInviteModel)

	return p
end

function ExperienceInviteModel.mock(options)
	local v = options or {}

	local votes = v.votes or {
		{
			userId = 456,
			voteIdentifier = "voteIdentifier",
			voteType = ExperienceInviteVoteType.Accept
		}
	}
	local spotsTaken = getSpotsTaken(votes) -- inferred equivalent call
	local v2 = ExperienceInviteModel.new({
		createdAtTime = v.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		experienceInviteId = v.experienceInviteId or "987",
		experienceDetail = v.experienceDetail or {
			placeId = 15308759682,
			gameInstanceId = "instanceId"
		},
		inviterId = v.inviterId or 123456,
		membershipEntityId = v.membershipEntityId or "54321",
		spotsTaken = spotsTaken,
		state = v.state or ExperienceInviteState.Active,
		totalSpots = v.totalSpots or 6,
		versionId = v.version or 1,
		votes = votes
	})

	if FFlagEnablePrivatePartyAcceptInvite then
		v2.inviteType = v.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v2
end

function ExperienceInviteModel.format(data)
	local votes = data.votes
	local v = ExperienceInviteModel.new({
		createdAtTime = data.createdAtTime,
		experienceDetail = data.experienceDetail,
		experienceInviteId = data.experienceInviteId,
		inviterId = data.inviterId,
		membershipEntityId = data.membershipEntityId,
		spotsTaken = getSpotsTaken(votes), -- inferred equivalent call
		state = data.state,
		totalSpots = data.totalSpots,
		versionId = data.versionId,
		votes = votes
	})

	if FFlagEnablePrivatePartyAcceptInvite then
		v.inviteType = data.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v
end

ExperienceInviteModel.isValid = t.strictInterface({
	createdAtTime = t.string,
	experienceDetail = t.interface({ placeId = t.number, gameInstanceId = t.optional(t.string) }),
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

return ExperienceInviteModel
