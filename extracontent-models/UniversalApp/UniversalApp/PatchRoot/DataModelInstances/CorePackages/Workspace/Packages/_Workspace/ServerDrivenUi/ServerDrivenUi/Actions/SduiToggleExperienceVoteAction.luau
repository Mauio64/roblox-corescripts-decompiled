local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local DataHydration = require(Parent.DataHydration)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Foundation = require(Parent.Foundation)
local Game = DataHydration.Game
local SharedFlags = require(Parent.SharedFlags)
local Signals = require(Parent.Signals)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local gameVote = DiscoveryAnalytics.Events.gameVote
local getSduiPageEntrySnackbarStore = require(Parent.SduiSharedUtilities).getSduiPageEntrySnackbarStore
local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled
local FFlagLuaAppVoteOptimisticUpdateRaceFix = SharedFlags.FFlagLuaAppVoteOptimisticUpdateRaceFix

local function convertBooleanToVoteForAnalytics(b1: boolean?) -- line: 28
	if b1 == true then
		return "UpVoted"
	end

	if b1 == false then
		return "DownVoted"
	end

	return "NotVoted"
end
local function SduiToggleExperienceVoteAction(p1, _, p3, _) -- line: 38
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), Game (copy), FFlagLuaAppVoteOptimisticUpdateRaceFix (copy), Players (copy), gameVote (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), getSduiClientPageScope (copy), Signals (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy)
	local v24 = p1 and p1.actionParams or nil

	if v24 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing action params",
			name = SduiActionType.ToggleExperienceVote
		}, p3.appPage)

		return
	end

	local universeId = v24.universeId
	local voteDirection = v24.voteDirection
	local placeId = v24.placeId

	if universeId == nil or typeof(universeId) ~= "string" or voteDirection == nil or typeof(voteDirection) ~= "boolean" then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing universeId or voteDirection",
			name = SduiActionType.ToggleExperienceVote
		}, p3.appPage)

		return
	end

	local v28 = v24.ctx or ""
	local v29 = Game.getVotesStore(false)
	local v30 = ((if not FFlagLuaAppVoteOptimisticUpdateRaceFix then v29.getAndFetchUserVote(universeId) else v29.getUserVote(universeId))).data(false)
	local v31 = if not v30 then nil else v30.userVote

	if v31 == voteDirection then
		voteDirection = nil
	end

	local v32 = Players.LocalPlayer and Players.LocalPlayer.UserId
	local v33 = gameVote
	local t1 = {
		uid = tostring(v32),
		placeId = tostring(placeId)
	}

	t1.vote = if voteDirection ~= true then voteDirection ~= false and "NotVoted" or "DownVoted" else "UpVoted"
	t1.prevVote = if v31 ~= true then v31 ~= false and "NotVoted" or "DownVoted" else "UpVoted"
	v33(t1, v28)

	if GetFFlagEdpPlayerFeedbackEnabled() and placeId then
		Game.getUserVoteFeedbackMetadataStore(false).clearItem(placeId)

		if p3.configKey then
			getSduiClientPageScope(p3.configKey).set("showPlayerFeedback", false)
		end
	end

	local v35 = v29.updateUserVote(universeId, voteDirection)
	local t2 = {}

	t2.dispose = Signals.createEffect(function(p5) -- line: 110
		-- upvalues: v35 (copy), p3 (copy), getSduiPageEntrySnackbarStore (copy), Foundation (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), placeId (copy), Game (copy), getSduiClientPageScope (copy), t2 (copy)
		local v38 = v35(p5)

		if v38 == nil then
			return
		end

		if v38.type == "error" then
			local configKey = p3.configKey

			if configKey then
				local s1 = "Feature.Toast.VoteError.Default"
				local reasonForNotVoteable = v38.reasonForNotVoteable

				if reasonForNotVoteable == "PlayGame" then
					s1 = "Feature.Toast.VoteError.PlayGame"
				elseif reasonForNotVoteable == "FloodCheckThresholdMet" then
					s1 = "Feature.Toast.VoteError.FloodCheckThresholdMet"
				elseif reasonForNotVoteable == "AssetNotVoteable" then
					s1 = "Feature.Toast.VoteError.AssetNotVoteable"
				end

				local v42 = p3.dependencies.localization:Format(s1)

				getSduiPageEntrySnackbarStore().show(configKey, {
					title = v42,
					icon = Foundation.Enums.IconName.TriangleExclamation
				})
			end
		elseif v38.type == "success" then
			local userVote = v38.userVote

			if GetFFlagEdpPlayerFeedbackEnabled() and userVote ~= nil and placeId then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(placeId)

				if p3.configKey then
					getSduiClientPageScope(p3.configKey).set("showPlayerFeedback", true)
				end
			end
		end

		local dispose = t2.dispose

		if dispose then
			dispose()
			t2.dispose = nil
		end
	end)
end

return SduiToggleExperienceVoteAction
