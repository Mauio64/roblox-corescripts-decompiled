local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local t = require(RoduxSquadsParent.t)
local ExperienceInviteState = require(RoduxSquads.Enums.ExperienceInviteState)
local ExperienceInviteVoteType = require(RoduxSquads.Enums.ExperienceInviteVoteType)
local ExperienceInviteType = require(RoduxSquads.Enums.ExperienceInviteType)
local FFlagEnablePrivatePartyAcceptInvite = require(RoduxSquadsParent.SharedFlags).FFlagEnablePrivatePartyAcceptInvite

local function getSpotsTaken(t1: {[any]: any}) -- line: 12
	-- upvalues: ExperienceInviteVoteType (copy)
	local n1 = 0

	for i = 1, #t1 do
		if t1[i].voteType == ExperienceInviteVoteType.Accept then
			n1 += 1
		end
	end

	return n1
end

local t2 = {}

function t2.new(p1) -- line: 32
	-- upvalues: t2 (copy)
	assert(t2.isValid(p1))
	t2.__index = t2
	setmetatable(p1, t2)

	return p1
end
function t2.mock(p2) -- line: 44
	-- upvalues: ExperienceInviteVoteType (copy), t2 (copy), ExperienceInviteState (copy), FFlagEnablePrivatePartyAcceptInvite (copy), ExperienceInviteType (copy)
	local v15 = p2 or {}
	local v16 = v15.votes or {
		[1] = {
			userId = 456,
			voteIdentifier = "voteIdentifier",
			voteType = ExperienceInviteVoteType.Accept
		}
	}
	local n2 = 0

	for i = 1, #v16 do
		if v16[i].voteType == ExperienceInviteVoteType.Accept then
			n2 += 1
		end
	end

	local v19 = t2.new({
		createdAtTime = v15.createdAtTime or "2024-07-19T21:02:47.777+00:00",
		experienceInviteId = v15.experienceInviteId or "987",
		experienceDetail = v15.experienceDetail or {
			placeId = 15308759682,
			gameInstanceId = "instanceId"
		},
		inviterId = v15.inviterId or 123456,
		membershipEntityId = v15.membershipEntityId or "54321",
		spotsTaken = n2,
		state = v15.state or ExperienceInviteState.Active,
		totalSpots = v15.totalSpots or 6,
		versionId = v15.version or 1,
		votes = v16
	})

	if FFlagEnablePrivatePartyAcceptInvite then
		v19.inviteType = v15.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v19
end
function t2.format(p3) -- line: 79
	-- upvalues: t2 (copy), ExperienceInviteVoteType (copy), FFlagEnablePrivatePartyAcceptInvite (copy), ExperienceInviteType (copy)
	local votes = p3.votes
	local new = t2.new
	local t3 = {
		createdAtTime = p3.createdAtTime,
		experienceDetail = p3.experienceDetail,
		experienceInviteId = p3.experienceInviteId,
		inviterId = p3.inviterId,
		membershipEntityId = p3.membershipEntityId
	}
	local n3 = 0

	for i = 1, #votes do
		if votes[i].voteType == ExperienceInviteVoteType.Accept then
			n3 += 1
		end
	end

	t3.spotsTaken = n3
	t3.state = p3.state
	t3.totalSpots = p3.totalSpots
	t3.versionId = p3.versionId
	t3.votes = votes

	local v26 = new(t3)

	if FFlagEnablePrivatePartyAcceptInvite then
		v26.inviteType = p3.inviteType or ExperienceInviteType.PlayWithPartyInPublicServer
	end

	return v26
end

t2.isValid = t.strictInterface({
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
	inviteType = t.optional(t.union(t.literal(ExperienceInviteType.PlayWithPartyInPublicServer), t.literal(ExperienceInviteType.PlayWithPartyInPrivatePartyServer)))
})

return t2
