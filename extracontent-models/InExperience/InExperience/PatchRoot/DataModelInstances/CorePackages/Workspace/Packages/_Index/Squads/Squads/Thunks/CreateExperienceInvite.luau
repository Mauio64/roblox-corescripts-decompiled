local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Http = require(SquadsParent.Http)
local LocalStorageKey = require(SquadsParent.LocalStorage).Enums.LocalStorageKey
local Promise = require(SquadsParent.Promise)
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Enums = require(SquadsParent.SquadsCore.Enums)

require(SquadsParent.SquadsCore.Types)

local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local NetworkingSquads = dependencies.NetworkingSquads
local RoduxSquads = dependencies.RoduxSquads
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadPromptType = Enums.SquadPromptType
local encodeSquadMembers = require(SquadsParent.SquadsCore.encodeSquadMembers)
local FFlagEncodeSquadMembersUpdated = require(SquadsParent.SquadsCore.Flags).FFlagEncodeSquadMembersUpdated
local FFlagEnableSquadRegroupExperimentation = dependencies.SharedFlags.FFlagEnableSquadRegroupExperimentation
local LuckyRecommendationExperimentation = dependencies.SocialExperiments.LuckyRecommendationExperimentation
local FFlagEnablePrivatePartyStartJoin = dependencies.SharedFlags.FFlagEnablePrivatePartyStartJoin
local SquadExperienceInviteType = Enums.SquadExperienceInviteType
local u22 = nil

return function(s1: string, p1, s2: string?, p2) -- line: 33
	-- upvalues: FFlagEncodeSquadMembersUpdated (copy), encodeSquadMembers (ref), Cryo (copy), HttpService (copy), Promise (copy), AppStorageService (copy), LocalStorageKey (copy), RoduxSquads (copy), u22 (ref), FFlagEnableSquadRegroupExperimentation (copy), LuckyRecommendationExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), EventNames (copy), Http (copy), SquadPromptType (copy)
	return function(p3) -- line: 34
		-- upvalues: FFlagEncodeSquadMembersUpdated (copy), encodeSquadMembers (ref), Cryo (copy), HttpService (copy), Promise (copy), AppStorageService (copy), LocalStorageKey (copy), RoduxSquads (copy), u22 (ref), s1 (copy), FFlagEnableSquadRegroupExperimentation (copy), LuckyRecommendationExperimentation (copy), s2 (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), p2 (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), p1 (copy), EventNames (copy), Http (copy), SquadPromptType (copy)
		local v28 = p3:getState()
		local v29 = v28.Squad and (v28.Squad.Squad and v28.Squad.Squad.currentSquad)
		local v30 = v29 and v29.squadId
		local v31 = v29 and v29.parentChannelId
		local v32 = if not v29 or not v29.members then {} else v29.members

		if not FFlagEncodeSquadMembersUpdated then
			function encodeSquadMembers(_) -- line: 44
				-- upvalues: Cryo (copy), v32 (copy), HttpService (copy)
				local u40 = Cryo.List.map(v32, function(p5) -- line: 45
					return p5.userId
				end)
				local ok, result = pcall(function() -- line: 49
					-- upvalues: HttpService (copy), u40 (ref)
					return HttpService:JSONEncode(u40)
				end)

				if ok then
					return result
				end

				return "[]"
			end
		end

		local v33 = encodeSquadMembers(v32)

		if not v30 then
			return Promise.resolve()
		end

		local ok, result = pcall(function() -- line: 67
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
			return AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)
		end)
		local v36 = not ok and "" or result

		local function updateCurrentExperienceInviteStatus(p6) -- line: 72
			-- upvalues: p3 (copy), RoduxSquads (copy)
			p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
				isExperienceInvitePending = p6
			}))
		end
		local function CreateExperienceInvite(p7) -- line: 78
			-- upvalues: u22 (ref), p3 (copy), RoduxSquads (copy), v30 (copy), s1 (copy), v36 (copy), FFlagEnableSquadRegroupExperimentation (copy), LuckyRecommendationExperimentation (copy), s2 (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), p2 (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), p1 (copy), EventNames (copy), v31 (copy), v33 (copy), v32 (copy), HttpService (copy), Http (copy), SquadPromptType (copy)
			if u22 then
				task.cancel(u22)
				u22 = nil
			end

			p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
				isExperienceInvitePending = true
			}))

			local t1 = {
				membershipEntityId = v30,
				placeId = s1,
				voteIdentifier = v36
			}
			local v46 = if not FFlagEnableSquadRegroupExperimentation and not LuckyRecommendationExperimentation.getLuckyRecommendationEnabled() then nil else s2 or SquadExperienceInviteSource.Default

			if v46 then
				t1.source = v46
			end

			if FFlagEnablePrivatePartyStartJoin then
				t1.inviteType = p2 or SquadExperienceInviteType.PlayWithPartyInPublicServer
			end

			return p3:dispatch(NetworkingSquads.CreateExperienceInvite.API(t1)):andThen(function(p8) -- line: 107
				-- upvalues: p1 (copy), EventNames (copy), v31 (copy), s1 (copy), v33 (copy), v32 (copy), u22 (ref), p3 (copy), RoduxSquads (copy)
				local experienceInviteId = p8.responseBody.experienceInviteId

				p1.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					isSuccess = true,
					parentChannelId = v31,
					experienceInviteId = experienceInviteId,
					invitationPlaceId = tonumber(s1),
					squadMembers = v33,
					squadMembersCount = #v32
				})
				u22 = task.delay(2, function() -- line: 118
					-- upvalues: p3 (copy), RoduxSquads (copy), u22 (ref)
					p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
						isExperienceInvitePending = false
					}))
					u22 = nil
				end)

				return experienceInviteId
			end):catch(function(t2: {[any]: any}) -- line: 124
				-- upvalues: p3 (copy), RoduxSquads (copy), HttpService (copy), p1 (copy), EventNames (copy), v31 (copy), s1 (copy), v33 (copy), v32 (copy), Http (copy), p7 (copy), SquadPromptType (copy)
				p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
					isExperienceInvitePending = false
				}))

				local Body = t2.Body
				local ok2, result2 = pcall(function() -- line: 128
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)
				local v54 = if not ok2 then nil else result2.errorType

				p1.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					isSuccess = false,
					parentChannelId = v31,
					errorMessage = v54,
					errorType = if not t2.StatusCode then nil else tostring(t2.StatusCode),
					invitationPlaceId = tonumber(s1),
					squadMembers = v33,
					squadMembersCount = #v32
				})

				if t2.StatusCode == Http.StatusCodes.CONFLICT then
					p1.setSquadPrompt(p3, {
						onConfirm = function() -- line: 146
							-- upvalues: p7 (copy)
							p7(p7)
						end,
						promptType = SquadPromptType.InvitedToExperience
					})

					return
				end

				p1.setSquadPrompt(p3, {
					promptType = SquadPromptType.Error
				})
			end)
		end

		return CreateExperienceInvite(CreateExperienceInvite)
	end
end
