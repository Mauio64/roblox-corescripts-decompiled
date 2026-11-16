local Players = game:GetService("Players")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local Game = DataHydration.Game
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local gameVote = DiscoveryAnalytics.Events.gameVote
local getSduiPageEntrySnackbarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").getSduiPageEntrySnackbarStore

local getFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled
local fFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local function convertBooleanToVoteForAnalytics(p2): string
	if p2 == true then
		return "UpVoted"
	elseif p2 == false then
		return "DownVoted"
	end

	return "NotVoted"
end

local function SduiToggleExperienceVoteAction(p2, p3, data, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		data.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceVote,
				message = "Missing action params"
			},
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
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.ToggleExperienceVote,
				message = "Missing universeId or voteDirection"
			},
			data.appPage
		)
		return
	end

	local ctx = actionParams.ctx or ""

	local votesStore = Game.getVotesStore(false)

	local data2 = votesStore.getUserVote(universeId).data(false)
	local userVote = if data2 then data2.userVote else nil

	if userVote == voteDirection then
		voteDirection = nil
	end

	local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
	gameVote({
		uid = tostring(userId),
		placeId = tostring(placeId),
		vote = voteDirection == true and "UpVoted" or voteDirection == false and "DownVoted" or "NotVoted",
		prevVote = userVote == true and "UpVoted" or userVote == false and "DownVoted" or "NotVoted",
		targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
	}, ctx)

	if getFFlagEdpPlayerFeedbackEnabled() and placeId then
		Game.getUserVoteFeedbackMetadataStore(false).clearItem(placeId)

		if data.configKey then
			getSduiClientPageScope(data.configKey).set("showPlayerFeedback", false)
		end
	end

	local v8 = votesStore.updateUserVote(universeId, voteDirection)

	local v9 = {}
	v9.dispose = Signals.createEffect(function(p5)
		local v10 = v8(p5)

		if v10 == nil then
			return
		end

		if v10.type == "error" then
			local configKey = data.configKey

			if configKey then
				local reasonForNotVoteable = v10.reasonForNotVoteable
				local v11

				if reasonForNotVoteable == "PlayGame" then
					v11 = "Feature.Toast.VoteError.PlayGame"
				elseif reasonForNotVoteable == "FloodCheckThresholdMet" then
					v11 = "Feature.Toast.VoteError.FloodCheckThresholdMet"
				elseif reasonForNotVoteable == "AssetNotVoteable" then
					v11 = "Feature.Toast.VoteError.AssetNotVoteable"
				else
					v11 = "Feature.Toast.VoteError.Default"
				end

				local formatted = data.dependencies.localization:Format(v11)
				getSduiPageEntrySnackbarStore().show(configKey, {
					title = formatted,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v10.type == "success" then
			local userVote2 = v10.userVote

			if getFFlagEdpPlayerFeedbackEnabled() and userVote2 ~= nil and placeId then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(placeId)

				if data.configKey then
					getSduiClientPageScope(data.configKey).set("showPlayerFeedback", true)
				end
			end
		end

		local dispose = v9.dispose

		if dispose then
			dispose()
			v9.dispose = nil
		end
	end)
end

return SduiToggleExperienceVoteAction
