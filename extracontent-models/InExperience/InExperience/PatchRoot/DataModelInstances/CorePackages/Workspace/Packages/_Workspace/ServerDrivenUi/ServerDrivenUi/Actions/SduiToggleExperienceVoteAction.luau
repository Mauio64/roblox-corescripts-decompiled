local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DataHydration = require(parent.DataHydration)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local Game = DataHydration.Game
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local gameVote = DiscoveryAnalytics.Events.gameVote
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiPageEntrySnackbarStore = SduiSharedUtilities.getSduiPageEntrySnackbarStore

local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local function convertBooleanToVoteForAnalytics(flag: boolean?): string -- 2 equivalent calls inferred from this helper
	if flag == true then
		return "UpVoted"
	elseif flag == false then
		return "DownVoted"
	end

	return "NotVoted"
end

local function SduiToggleExperienceVoteAction(p, _, data, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.ToggleExperienceVote, message = "Missing action params" },
			data.appPage
		)
		return
	end

	local universeId = actionParams.universeId
	local voteDirection = actionParams.voteDirection
	local placeId = actionParams.placeId

	if
		universeId == nil
		or typeof(universeId) ~= "string"
		or voteDirection == nil
		or typeof(voteDirection) ~= "boolean"
	then
		data.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.ToggleExperienceVote,
				message = "Missing universeId or voteDirection"
			},
			data.appPage
		)
		return
	end

	local ctx = actionParams.ctx or ""

	local votesStore = Game.getVotesStore(false)

	local data2 = votesStore.getUserVote(universeId).data(false)
	local userVote

	if data2 then
		userVote = data2.userVote
	end

	if userVote == voteDirection then
		voteDirection = nil
	end

	local v = {
		uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
		placeId = tostring(placeId),
		vote = convertBooleanToVoteForAnalytics(voteDirection), -- inferred equivalent call
		prevVote = convertBooleanToVoteForAnalytics(userVote), -- inferred equivalent call
		targetId = 0
	}
	local targetId

	if FFlagLuaAppAddUniverseIdToEngagementEvents then
		targetId = universeId
	end

	v.targetId = targetId
	gameVote(v, ctx)

	if GetFFlagEdpPlayerFeedbackEnabled() and placeId then
		Game.getUserVoteFeedbackMetadataStore(false).clearItem(placeId)

		if data.configKey then
			getSduiClientPageScope(data.configKey).set("showPlayerFeedback", false)
		end
	end

	local v2 = votesStore.updateUserVote(universeId, voteDirection)

	local v3 = {}
	v3.dispose = Signals.createEffect(function(p2)
		local v4 = v2(p2)

		if v4 == nil then
			return
		end

		if v4.type == "error" then
			local configKey = data.configKey

			if configKey then
				local reasonForNotVoteable = v4.reasonForNotVoteable
				local v5

				if reasonForNotVoteable == "PlayGame" then
					v5 = "Feature.Toast.VoteError.PlayGame"
				elseif reasonForNotVoteable == "FloodCheckThresholdMet" then
					v5 = "Feature.Toast.VoteError.FloodCheckThresholdMet"
				elseif reasonForNotVoteable == "AssetNotVoteable" then
					v5 = "Feature.Toast.VoteError.AssetNotVoteable"
				else
					v5 = "Feature.Toast.VoteError.Default"
				end

				local formatted = data.dependencies.localization:Format(v5)
				getSduiPageEntrySnackbarStore().show(configKey, {
					title = formatted,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v4.type == "success" then
			local userVote2 = v4.userVote

			if GetFFlagEdpPlayerFeedbackEnabled() and userVote2 ~= nil and placeId then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(placeId)

				if data.configKey then
					getSduiClientPageScope(data.configKey).set("showPlayerFeedback", true)
				end
			end
		end

		local dispose = v3.dispose

		if dispose then
			dispose()
			v3.dispose = nil
		end
	end)
end

return SduiToggleExperienceVoteAction
