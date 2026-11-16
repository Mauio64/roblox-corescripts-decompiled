local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local Http = require(parent.Http)
local LocalStorage = require(parent.LocalStorage)
local LocalStorageKey = LocalStorage.Enums.LocalStorageKey
local Promise = require(parent.Promise)

local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local Enums = require(parent.SquadsCore.Enums)
require(parent.SquadsCore.Types)
local dependencies = require(Squads.dependencies)

local cryo = dependencies.Cryo
local networkingSquads = dependencies.NetworkingSquads
local roduxSquads = dependencies.RoduxSquads
local SquadExperienceInviteSource = Enums.SquadExperienceInviteSource
local EventNames = require(parent.SquadsCore.EventNames)
local SquadPromptType = Enums.SquadPromptType
local v = require(parent.SquadsCore.encodeSquadMembers)

local Stores = require(parent.SquadsCore.Stores)
local GetSquadExperienceInviteStore = Stores.GetSquadExperienceInviteStore

local Flags = require(parent.SquadsCore.Flags)
local FFlagEncodeSquadMembersUpdated = Flags.FFlagEncodeSquadMembersUpdated
local fFlagEnableSquadRegroupExperimentation = dependencies.SharedFlags.FFlagEnableSquadRegroupExperimentation

local fFlagUseSignalsForSquadExperienceInviteStatus = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInviteStatus
local luckyRecommendationExperimentation = dependencies.SocialExperiments.LuckyRecommendationExperimentation

local fFlagEnablePrivatePartyStartJoin = dependencies.SharedFlags.FFlagEnablePrivatePartyStartJoin
local SquadExperienceInviteType = Enums.SquadExperienceInviteType
local Stores2 = require(parent.SquadsCore.Stores)
local GetExperienceInviteRetryAfterStore = Stores2.GetExperienceInviteRetryAfterStore

local function getRetryAfterSeconds(p)
	local v2

	if type(p) == "table" then
		v2 = p.retryAfterSeconds
	end

	local v3 = tonumber(v2)
	return if v3 and not (v3 <= 0) then v3 else nil
end

local thread = nil

return function(placeId: string, p, p2: string?, p3)
	return function(object)
		local state = object:getState()

		local currentSquad = state.Squad and state.Squad.Squad and state.Squad.Squad.currentSquad

		local squadId = currentSquad and currentSquad.squadId
		local parentChannelId = currentSquad and currentSquad.parentChannelId
		local v2 = not (currentSquad and currentSquad.members) and {} or currentSquad.members

		if not FFlagEncodeSquadMembersUpdated then
			v = function(_)
				local mapped = cryo.List.map(v2, function(p4)
					return p4.userId
				end)

				local success, result = pcall(function()
					return HttpService:JSONEncode(mapped)
				end)
				return if success then result else "[]"
			end
		end

		local squadMembers = v(v2)

		if not squadId then
			return Promise.resolve()
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem(LocalStorageKey.BrowserTrackerId)
		end)
		local voteIdentifier = not success and "" or result

		local function updateCurrentExperienceInviteStatus(isExperienceInvitePending)
			if fFlagUseSignalsForSquadExperienceInviteStatus then
				GetSquadExperienceInviteStore(false).currentExperienceInviteStatusUpdated(isExperienceInvitePending)
			else
				object:dispatch(roduxSquads.Actions.CurrentExperienceInviteStatusUpdated({
					isExperienceInvitePending = isExperienceInvitePending
				}))
			end
		end

		local function CreateExperienceInvite(CreateExperienceInvite2)
			if thread then
				task.cancel(thread)
				thread = nil
			end

			updateCurrentExperienceInviteStatus(true)

			local v3 = {
				membershipEntityId = squadId,
				placeId = placeId,
				voteIdentifier = voteIdentifier
			}
			local source

			if
				fFlagEnableSquadRegroupExperimentation
				or luckyRecommendationExperimentation.getLuckyRecommendationEnabled()
			then
				source = p2 or SquadExperienceInviteSource.Default
			end

			if source then
				v3.source = source
			end

			if fFlagEnablePrivatePartyStartJoin then
				v3.inviteType = p3 or SquadExperienceInviteType.PlayWithPartyInPublicServer
			end

			return object:dispatch(networkingSquads.CreateExperienceInvite.API(v3)):andThen(function(p4)
				local experienceInviteId = p4.responseBody.experienceInviteId
				p.fireSquadAnalytics(EventNames.SquadExperienceInviteApiCall, {
					parentChannelId = parentChannelId,
					experienceInviteId = experienceInviteId,
					isSuccess = true,
					invitationPlaceId = tonumber(placeId),
					squadMembers = squadMembers,
					squadMembersCount = #v2
				})

				thread = task.delay(2, function()
					updateCurrentExperienceInviteStatus(false)
					thread = nil
				end)
				return experienceInviteId
			end):catch(function(p4)
				updateCurrentExperienceInviteStatus(false)

				local body = p4.Body
				local success2, result2 = pcall(function()
					return HttpService:JSONDecode(body)
				end)
				local errorType

				if success2 then
					errorType = result2.errorType
				end

				local fireSquadAnalytics = p.fireSquadAnalytics
				local squadExperienceInviteApiCall = EventNames.SquadExperienceInviteApiCall
				local v4 = {
					parentChannelId = parentChannelId,
					isSuccess = false,
					errorMessage = errorType,
					errorType = 0,
					invitationPlaceId = 0,
					squadMembers = 0,
					squadMembersCount = 0
				}
				local errorType2

				if p4.StatusCode then
					errorType2 = tostring(p4.StatusCode)
				end

				v4.errorType = errorType2
				v4.invitationPlaceId = tonumber(placeId)
				v4.squadMembers = squadMembers
				v4.squadMembersCount = #v2
				fireSquadAnalytics(squadExperienceInviteApiCall, v4)

				if p4.StatusCode ~= Http.StatusCodes.CONFLICT then
					p.setSquadPrompt(object, { promptType = SquadPromptType.Error })

					return
				end

				local v5

				if success2 then
					local v6

					if type(result2) == "table" then
						v6 = result2.retryAfterSeconds
					end

					v5 = tonumber(v6)

					if not v5 or v5 <= 0 then
						v5 = nil
					end
				end

				if v5 then
					GetExperienceInviteRetryAfterStore(false).block(squadId, v5)
				else
					p.setSquadPrompt(object, {
						onConfirm = function()
							CreateExperienceInvite2(CreateExperienceInvite2)
						end,
						promptType = SquadPromptType.InvitedToExperience
					})
				end
			end)
		end

		return CreateExperienceInvite(CreateExperienceInvite)
	end
end
