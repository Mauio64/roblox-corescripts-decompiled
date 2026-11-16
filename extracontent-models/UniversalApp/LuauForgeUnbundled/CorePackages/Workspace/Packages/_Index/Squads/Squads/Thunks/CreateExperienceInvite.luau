local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Http")
local localStorageKey = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/LocalStorage").Enums.LocalStorageKey
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Promise")

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local Enums = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Types")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local cryo = dependencies.Cryo
local networkingSquads = dependencies.NetworkingSquads
local roduxSquads = dependencies.RoduxSquads
local squadExperienceInviteSource = Enums.SquadExperienceInviteSource
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadPromptType = Enums.SquadPromptType
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/encodeSquadMembers")

local getSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetSquadExperienceInviteStore

local fFlagEncodeSquadMembersUpdated = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagEncodeSquadMembersUpdated
local fFlagEnableSquadRegroupExperimentation = dependencies.SharedFlags.FFlagEnableSquadRegroupExperimentation

local fFlagUseSignalsForSquadExperienceInviteStatus = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInviteStatus
local luckyRecommendationExperimentation = dependencies.SocialExperiments.LuckyRecommendationExperimentation

local fFlagEnablePrivatePartyStartJoin = dependencies.SharedFlags.FFlagEnablePrivatePartyStartJoin
local squadExperienceInviteType = Enums.SquadExperienceInviteType
local getExperienceInviteRetryAfterStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetExperienceInviteRetryAfterStore

local function getRetryAfterSeconds(p2)
	local v6 = if type(p2) == "table" then p2.retryAfterSeconds else nil
	local v7 = tonumber(v6)

	if v7 and not (v7 <= 0) then
		return v7
	end

	return nil
end

local thread = nil

return function(p2, p3, p4, p5)
	return function(object)
		local state = object:getState()

		local currentSquad = state.Squad and state.Squad.Squad and state.Squad.Squad.currentSquad

		local squadId = currentSquad and currentSquad.squadId
		local parentChannelId = currentSquad and currentSquad.parentChannelId
		local v6 = not (currentSquad and currentSquad.members) and {} or currentSquad.members

		if not fFlagEncodeSquadMembersUpdated then
			v5 = function(p6)
				local mapped = cryo.List.map(v6, function(p7)
					return p7.userId
				end)

				local success, result = pcall(function()
					return HttpService:JSONEncode(mapped)
				end)

				if success then
					return result
				end

				return "[]"
			end
		end

		local v7 = v5(v6)

		if not squadId then
			return Promise.resolve()
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(localStorageKey.BrowserTrackerId)
		end)
		local v8 = not success and "" or result

		local function updateCurrentExperienceInviteStatus(p6)
			if fFlagUseSignalsForSquadExperienceInviteStatus then
				getSquadExperienceInviteStore(false).currentExperienceInviteStatusUpdated(p6)
			else
				object:dispatch(roduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
					isExperienceInvitePending = p6
				}))
			end
		end

		local function CreateExperienceInvite(CreateExperienceInvite2)
			if thread then
				task.cancel(thread)
				thread = nil
			end

			updateCurrentExperienceInviteStatus(true)

			local v9 = {
				membershipEntityId = squadId,
				placeId = p2,
				voteIdentifier = v8
			}
			local v10

			if
				fFlagEnableSquadRegroupExperimentation
				or luckyRecommendationExperimentation.getLuckyRecommendationEnabled()
			then
				v10 = p4 or squadExperienceInviteSource.Default
			end

			if v10 then
				v9.source = v10
			end

			if fFlagEnablePrivatePartyStartJoin then
				v9.inviteType = p5 or squadExperienceInviteType.PlayWithPartyInPublicServer
			end

			return object:dispatch(networkingSquads.CreateExperienceInvite.API(v9)):andThen(function(p6)
				local experienceInviteId = p6.responseBody.experienceInviteId
				p3.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					parentChannelId = parentChannelId,
					experienceInviteId = experienceInviteId,
					isSuccess = true,
					invitationPlaceId = tonumber(p2),
					squadMembers = v7,
					squadMembersCount = #v6
				})

				thread = task.delay(2, function()
					updateCurrentExperienceInviteStatus(false)
					thread = nil
				end)
				return experienceInviteId
			end):catch(function(p6)
				updateCurrentExperienceInviteStatus(false)

				local body = p6.Body
				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				local errorType = if success2 then result2.errorType else nil

				local fireSquadAnalytics = p3.fireSquadAnalytics
				local squadExperienceInviteApiCall = EventNames.SquadExperienceInviteApiCall
				local v11 = {
					parentChannelId = parentChannelId,
					isSuccess = false,
					errorMessage = errorType,
					errorType = 0,
					invitationPlaceId = 0,
					squadMembers = 0,
					squadMembersCount = 0
				}

				local v12 = if p6.StatusCode then tostring(p6.StatusCode) else nil
				v11.errorType = v12
				v11.invitationPlaceId = tonumber(p2)
				v11.squadMembers = v7
				v11.squadMembersCount = #v6
				fireSquadAnalytics(squadExperienceInviteApiCall, v11)

				if p6.StatusCode ~= Http.StatusCodes.CONFLICT then
					p3.setSquadPrompt(object, { promptType = squadPromptType.Error })

					return
				end

				local v13

				if success2 then
					local v14 = if type(result2) == "table" then result2.retryAfterSeconds else nil
					v13 = tonumber(v14)

					if not v13 or v13 <= 0 then
						v13 = nil
					end
				end

				if v13 then
					getExperienceInviteRetryAfterStore(false).block(squadId, v13)
				else
					p3.setSquadPrompt(object, {
						onConfirm = function()
							CreateExperienceInvite2(CreateExperienceInvite2)
						end,
						promptType = squadPromptType.InvitedToExperience
					})
				end
			end)
		end

		return CreateExperienceInvite(CreateExperienceInvite)
	end
end
