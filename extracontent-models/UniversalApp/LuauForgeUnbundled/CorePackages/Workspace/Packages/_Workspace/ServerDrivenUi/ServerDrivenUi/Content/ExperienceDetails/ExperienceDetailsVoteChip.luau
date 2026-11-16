local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RoactUtils")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
local votesUtils = Game.VotesUtils

local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ToastRodux")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UniversalAppPolicy")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")

local iconVariant = Foundation.Enums.IconVariant
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local sduiDualActionChip = SduiSharedContent.SduiDualActionChip
local toastType = ToastRodux.Enums.ToastType
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local gameVote = DiscoveryAnalytics.Events.gameVote
local useOptimisticUpdateStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/Hooks/useOptimisticUpdateStatus")

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

local function ExperienceDetailsVoteChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId
	local v5 = useDispatch()

	local v6 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchVote(universeId).data)
	local v7 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchUserVote(universeId).data)

	local gameInfoStore = Game.getGameInfoStore(false)
	local v8 = SignalsReact.useSignalState(gameInfoStore.getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v8 and v8.rootPlaceId

	local v11 = useOptimisticUpdateStatus(React.useCallback(function(p3)
		return Game.getVotesStore(false).updateUserVote(universeId, p3)
	end, { universeId }), (React.useCallback(function(data)
		if data == nil then
			return
		end

		if data.type == "error" then
			local reasonForNotVoteable = data.reasonForNotVoteable
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

			v5(setCurrentToastMessage({
				toastType = toastType.NetworkingError,
				toastMessage = v11
			}))
		elseif data.type == "success" then
			local userVote = data.userVote

			if getFFlagEdpPlayerFeedbackEnabled() and userVote ~= nil and rootPlaceId then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(rootPlaceId)
			end
		end
	end, { rootPlaceId, v5 })))

	local v12 = React.useCallback(function(p3)
		local userVote = v7 and v7.userVote

		if userVote == p3 then
			p3 = nil
		end

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameVote({
				uid = tostring(userId),
				placeId = rootPlaceId,
				vote = p3 == true and "UpVoted" or p3 == false and "DownVoted" or "NotVoted",
				prevVote = userVote == true and "UpVoted" or userVote == false and "DownVoted" or "NotVoted",
				targetId = if fFlagLuaAppAddUniverseIdToEngagementEvents then universeId else nil
			}, "ExperienceDetailsVoteChip")
		end

		if getFFlagEdpPlayerFeedbackEnabled() and rootPlaceId then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)
		end

		v11(p3)
	end, { universeId, v7, rootPlaceId, v11, v5 })

	local v13 = React.useCallback(function()
		v12(true)
	end, { v12 })

	local v14 = React.useCallback(function()
		v12(false)
	end, { v12 })

	local v15 = React.useMemo(function()
		return votesUtils.getRatingDisplayText(v6)
	end, { v6 })

	local v16 = React.useMemo(function()
		if v7 and v7.userVote == true then
			return iconVariant.Filled
		end

		return iconVariant.Regular
	end, { v7 })

	local v17 = React.useMemo(function()
		if v7 and v7.userVote == false then
			return iconVariant.Filled
		end

		return iconVariant.Regular
	end, { v7 })

	if useAppPolicy(function(p3)
		return p3.getGamePlaysAndRatings()
	end) then
		return React.createElement(sduiDualActionChip, {
			text = v15,
			leadingIconName = Foundation.Enums.IconName.ThumbUp,
			leadingIconVariant = v16,
			leadingOnActivated = v13,
			trailingIconName = Foundation.Enums.IconName.ThumbDown,
			trailingIconVariant = v17,
			trailingOnActivated = v14,
			layoutOrder = layoutOrder
		})
	end

	return nil
end

return React.memo(ExperienceDetailsVoteChip)
