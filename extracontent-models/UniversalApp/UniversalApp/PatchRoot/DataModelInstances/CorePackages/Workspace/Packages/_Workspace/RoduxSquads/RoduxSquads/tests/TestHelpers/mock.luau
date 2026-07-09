local RoduxSquads = script:FindFirstAncestor("RoduxSquads")
local RoduxSquadsParent = RoduxSquads.Parent
local Mock = require(RoduxSquadsParent.Dev.LuaSocialLibrariesDeps).Mock
local Rodux = require(RoduxSquadsParent.Rodux)
local ExperienceInviteState = require(RoduxSquads.Enums.ExperienceInviteState)
local ExperienceInviteVoteType = require(RoduxSquads.Enums.ExperienceInviteVoteType)

require(RoduxSquads.RoduxSquadsTypes)

local function v7(s1: string?, s2: string?) -- line: 63
	return {
		initiatorId = 123,
		createdAtTime = "2024-07-19T21:02:47.777+00:00",
		parentChannelId = "23456",
		groupUpId = s2 or "12345",
		updatedAtTime = s1 or "2024-07-19T21:02:47.777+00:00",
		members = {
			{
				userId = 123
			},
			{
				userId = 456
			}
		},
		invitees = {
			{
				userId = 123,
				invitedAtTimestampMs = 111111
			},
			{
				userId = 456,
				invitedAtTimestampMs = 111111
			}
		}
	}
end
local function v8(s3: string?, s4: string?, t1: {[any]: any}?, n1: number?) -- line: 75
	-- upvalues: ExperienceInviteState (copy)
	return {
		inviterId = 65432,
		membershipEntityId = "54321",
		totalSpots = 5,
		inviteType = "PlayWithPartyInPublicServer",
		createdAtTime = s3 or "2024-07-19T21:02:47.777+00:00",
		experienceDetail = {
			placeId = 15308759682,
			gameInstanceId = "instanceId"
		},
		experienceInviteId = s4 or "23456",
		state = ExperienceInviteState.Active,
		versionId = n1 or 1,
		votes = t1 or {}
	}
end

local v9 = Rodux.makeActionCreator("CREATE_OR_JOIN_SQUAD", function() -- line: 98
	-- upvalues: v7 (copy)
	return {
		responseBody = {
			groupUp = v7()
		}
	}
end)
local v10 = Rodux.makeActionCreator("GET_SQUAD_ACTIVE", function(b1: boolean) -- line: 106
	-- upvalues: v7 (copy)
	return {
		responseBody = {
			groupUp = if not b1 then nil else v7()
		}
	}
end)
local v11 = Rodux.makeActionCreator("GET_SQUAD_FROM_SQUAD_ID", function(s5: string) -- line: 114
	-- upvalues: v7 (copy)
	return {
		responseBody = {
			groupUp = v7("2024-07-19T21:02:47.777+00:00", s5)
		}
	}
end)
local v12 = Rodux.makeActionCreator("JOIN_SQUAD", function(s6: string) -- line: 122
	-- upvalues: v7 (copy)
	return {
		responseBody = {
			groupUp = v7("2024-07-19T21:02:47.777+00:00", s6)
		}
	}
end)
local v13 = Rodux.makeActionCreator("LEAVE_SQUAD", function(s7: string) -- line: 130
	return {
		responseBody = {},
		postBody = {
			groupUpId = s7
		}
	}
end)
local v14 = Rodux.makeActionCreator("CREATE_EXPERIENCE_INVITE", function() -- line: 139
	-- upvalues: v8 (copy)
	return {
		responseBody = v8()
	}
end)
local v15 = Rodux.makeActionCreator("GET_EXPERIENCE_INVITE", function(s8: string) -- line: 147
	-- upvalues: v8 (copy)
	return {
		responseBody = v8("2024-07-19T21:02:47.777+00:00", s8)
	}
end)
local v16 = Rodux.makeActionCreator("VOTE_FOR_EXPERIENCE_INVITE", function(s9: string) -- line: 156
	-- upvalues: v8 (copy), ExperienceInviteVoteType (copy)
	return {
		responseBody = v8("2024-07-19T21:02:47.777+00:00", s9, {
			[1] = {
				userId = 123,
				voteIdentifier = "voteIdentifier",
				voteType = ExperienceInviteVoteType.Accept
			}
		})
	}
end)
local v17 = Rodux.makeActionCreator("ACT_ON_PARTY_NUDGE", function(s10: string) -- line: 169
	-- upvalues: v7 (copy)
	return {
		responseBody = {
			groupUp = v7("2024-07-19T21:02:47.777+00:00", s10)
		}
	}
end)
local v18 = Rodux.makeActionCreator("SELF_PERMISSION_UPDATED", function(p1) -- line: 177
	return {
		responseBody = {
			selfPermissions = p1
		}
	}
end)

return {
	mockCreateExperienceInvite = "CREATE_EXPERIENCE_INVITE",
	mockCreateOrJoinSquad = "CREATE_OR_JOIN_SQUAD",
	mockGetExperienceInvite = "GET_EXPERIENCE_INVITE",
	mockGetSquadActive = "GET_SQUAD_ACTIVE",
	mockGetSquadFromSquadId = "GET_SQUAD_FROM_SQUAD_ID",
	mockJoinSquad = "JOIN_SQUAD",
	mockLeaveSquad = "LEAVE_SQUAD",
	mockVoteForExperienceInvite = "VOTE_FOR_EXPERIENCE_INVITE",
	mockActOnPartyNudge = "ACT_ON_PARTY_NUDGE",
	mockSelfPermissionUpdated = "SELF_PERMISSION_UPDATED",
	createStorage = function() -- line: 22
		return {
			memStorageKey = "key",
			getItem = function() -- line: 25
				return nil
			end,
			setItem = function(_) -- line: 28
				return true
			end,
			bindAndFire = function(_) -- line: 31
				return {
					Disconnect = function() -- line: 33
					end
				}
			end
		}
	end,
	createExperienceInvite = v8,
	createSquad = function(s11: string?, s12: string?, s13: string?, s14: string?, n2: number?, t2: {[any]: any}?, t3: {[any]: any}?) -- line: 40
		return {
			squadId = s12 or "12345",
			initiatorId = n2 or 123,
			createdAtTime = s13 or "2024-07-19T21:02:47.777+00:00",
			updatedAtTime = s11 or "2024-07-19T21:02:47.777+00:00",
			parentChannelId = s14 or "23456",
			members = t2 or {
				{
					userId = 123
				},
				{
					userId = 456
				}
			},
			invitees = t3 or {
				{
					userId = 123,
					invitedAtTimestampMs = 111111
				},
				{
					userId = 456,
					invitedAtTimestampMs = 111111
				}
			}
		}
	end,
	createServerSquad = v7,
	mock = Mock,
	mockCreateExperienceInviteAction = v14,
	mockCreateOrJoinSquadAction = v9,
	mockGetExperienceInviteAction = v15,
	mockGetSquadActiveAction = v10,
	mockGetSquadFromSquadIdAction = v11,
	mockJoinSquadAction = v12,
	mockLeaveSquadAction = v13,
	mockVoteForExperienceInviteAction = v16,
	mockActOnPartyNudgeAction = v17,
	mockSelfPermissionUpdatedAction = v18
}
