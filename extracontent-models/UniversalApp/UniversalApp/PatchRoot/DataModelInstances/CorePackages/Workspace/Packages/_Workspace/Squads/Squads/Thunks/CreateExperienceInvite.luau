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
local FFlagEnablePrivatePartyStartJoin = dependencies.SharedFlags.FFlagEnablePrivatePartyStartJoin
local SquadExperienceInviteType = Enums.SquadExperienceInviteType
local u21 = nil

return function(s1: string, p1, s2: string?, p2) -- line: 32
	-- upvalues: FFlagEncodeSquadMembersUpdated (copy), encodeSquadMembers (ref), Cryo (copy), HttpService (copy), Promise (copy), AppStorageService (copy), LocalStorageKey (copy), RoduxSquads (copy), u21 (ref), FFlagEnableSquadRegroupExperimentation (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), EventNames (copy), Http (copy), SquadPromptType (copy)
	return function(p3) -- line: 33
		-- upvalues: FFlagEncodeSquadMembersUpdated (copy), encodeSquadMembers (ref), Cryo (copy), HttpService (copy), Promise (copy), AppStorageService (copy), LocalStorageKey (copy), RoduxSquads (copy), u21 (ref), s1 (copy), FFlagEnableSquadRegroupExperimentation (copy), s2 (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), p2 (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), p1 (copy), EventNames (copy), Http (copy), SquadPromptType (copy)
		local v27 = p3:getState()
		local v28 = v27.Squad and (v27.Squad.Squad and v27.Squad.Squad.currentSquad)
		local v29 = v28 and v28.squadId
		local v30 = v28 and v28.parentChannelId
		local v31 = if not v28 or not v28.members then {} else v28.members

		if not FFlagEncodeSquadMembersUpdated then
			function encodeSquadMembers(_) -- line: 43
				-- upvalues: Cryo (copy), v31 (copy), HttpService (copy)
				local u39 = Cryo.List.map(v31, function(p5) -- line: 44
					return p5.userId
				end)
				local ok, result = pcall(function() -- line: 48
					-- upvalues: HttpService (copy), u39 (ref)
					return HttpService:JSONEncode(u39)
				end)

				if ok then
					return result
				end

				return "[]"
			end
		end

		local v32 = encodeSquadMembers(v31)

		if not v29 then
			return Promise.resolve()
		end

		local ok, result = pcall(function() -- line: 66
			-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
			return AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)
		end)
		local v35 = not ok and "" or result

		local function updateCurrentExperienceInviteStatus(p6) -- line: 71
			-- upvalues: p3 (copy), RoduxSquads (copy)
			p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
				isExperienceInvitePending = p6
			}))
		end
		local function CreateExperienceInvite(p7) -- line: 77
			-- upvalues: u21 (ref), p3 (copy), RoduxSquads (copy), v29 (copy), s1 (copy), v35 (copy), FFlagEnableSquadRegroupExperimentation (copy), s2 (copy), SquadExperienceInviteSource (copy), FFlagEnablePrivatePartyStartJoin (copy), p2 (copy), SquadExperienceInviteType (copy), NetworkingSquads (copy), p1 (copy), EventNames (copy), v30 (copy), v32 (copy), v31 (copy), HttpService (copy), Http (copy), SquadPromptType (copy)
			if u21 then
				task.cancel(u21)
				u21 = nil
			end

			p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
				isExperienceInvitePending = true
			}))

			local t1 = {
				membershipEntityId = v29,
				placeId = s1,
				voteIdentifier = v35
			}
			local v45 = if not FFlagEnableSquadRegroupExperimentation then nil else s2 or SquadExperienceInviteSource.Default

			if v45 then
				t1.source = v45
			end

			if FFlagEnablePrivatePartyStartJoin then
				t1.inviteType = p2 or SquadExperienceInviteType.PlayWithPartyInPublicServer
			end

			return p3:dispatch(NetworkingSquads.CreateExperienceInvite.API(t1)):andThen(function(p8) -- line: 105
				-- upvalues: p1 (copy), EventNames (copy), v30 (copy), s1 (copy), v32 (copy), v31 (copy), u21 (ref), p3 (copy), RoduxSquads (copy)
				local experienceInviteId = p8.responseBody.experienceInviteId

				p1.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					isSuccess = true,
					parentChannelId = v30,
					experienceInviteId = experienceInviteId,
					invitationPlaceId = tonumber(s1),
					squadMembers = v32,
					squadMembersCount = #v31
				})
				u21 = task.delay(2, function() -- line: 116
					-- upvalues: p3 (copy), RoduxSquads (copy), u21 (ref)
					p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
						isExperienceInvitePending = false
					}))
					u21 = nil
				end)

				return experienceInviteId
			end):catch(function(t2: {[any]: any}) -- line: 122
				-- upvalues: p3 (copy), RoduxSquads (copy), HttpService (copy), p1 (copy), EventNames (copy), v30 (copy), s1 (copy), v32 (copy), v31 (copy), Http (copy), p7 (copy), SquadPromptType (copy)
				p3:dispatch(RoduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
					isExperienceInvitePending = false
				}))

				local Body = t2.Body
				local ok2, result2 = pcall(function() -- line: 126
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)
				local v53 = if not ok2 then nil else result2.errorType

				p1.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					isSuccess = false,
					parentChannelId = v30,
					errorMessage = v53,
					errorType = if not t2.StatusCode then nil else tostring(t2.StatusCode),
					invitationPlaceId = tonumber(s1),
					squadMembers = v32,
					squadMembersCount = #v31
				})

				if t2.StatusCode == Http.StatusCodes.CONFLICT then
					p1.setSquadPrompt(p3, {
						onConfirm = function() -- line: 144
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
