local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local Players = game:GetService("Players")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local VotesUtils = Game.VotesUtils

local SduiSharedContent = require(parent.SduiSharedContent)
local ToastRodux = require(parent.ToastRodux)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local SharedFlags = require(parent.SharedFlags)

local IconVariant = Foundation.Enums.IconVariant
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SduiDualActionChip = SduiSharedContent.SduiDualActionChip
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local gameVote = DiscoveryAnalytics.Events.gameVote
local useOptimisticUpdateStatus = require(script.Parent.Hooks.useOptimisticUpdateStatus)

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

local function ExperienceDetailsVoteChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId
	local v = useDispatch()

	local v2 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchVote(universeId).data)
	local v3 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchUserVote(universeId).data)

	local gameInfoStore = Game.getGameInfoStore(false)
	local v4 = SignalsReact.useSignalState(gameInfoStore.getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v4 and v4.rootPlaceId

	local v5 = useOptimisticUpdateStatus(React.useCallback(function(flag: boolean?)
		return Game.getVotesStore(false).updateUserVote(universeId, flag)
	end, { universeId }), (React.useCallback(function(data)
		if data == nil then
			return
		end

		if data.type == "error" then
			local reasonForNotVoteable = data.reasonForNotVoteable
			local toastMessage

			if reasonForNotVoteable == "PlayGame" then
				toastMessage = "Feature.Toast.VoteError.PlayGame"
			elseif reasonForNotVoteable == "FloodCheckThresholdMet" then
				toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet"
			elseif reasonForNotVoteable == "AssetNotVoteable" then
				toastMessage = "Feature.Toast.VoteError.AssetNotVoteable"
			else
				toastMessage = "Feature.Toast.VoteError.Default"
			end

			v(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = toastMessage
			}))
		elseif data.type == "success" then
			local userVote = data.userVote

			if GetFFlagEdpPlayerFeedbackEnabled() and userVote ~= nil and rootPlaceId then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(rootPlaceId)
			end
		end
	end, { rootPlaceId, v })))

	local v6 = React.useCallback(function(flag: boolean?)
		local userVote = v3 and v3.userVote

		if userVote == flag then
			flag = nil
		end

		if rootPlaceId then
			local v6 = {
				uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
				placeId = rootPlaceId,
				vote = convertBooleanToVoteForAnalytics(flag), -- inferred equivalent call
				prevVote = convertBooleanToVoteForAnalytics(userVote), -- inferred equivalent call
				targetId = 0
			}
			local targetId

			if FFlagLuaAppAddUniverseIdToEngagementEvents then
				targetId = universeId
			end

			v6.targetId = targetId
			gameVote(v6, "ExperienceDetailsVoteChip")
		end

		if GetFFlagEdpPlayerFeedbackEnabled() and rootPlaceId then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(rootPlaceId)
		end

		v5(flag)
	end, { universeId, v3, rootPlaceId, v5, v })

	local leadingOnActivated = React.useCallback(function()
		v6(true)
	end, { v6 })

	local trailingOnActivated = React.useCallback(function()
		v6(false)
	end, { v6 })

	local text = React.useMemo(function()
		return VotesUtils.getRatingDisplayText(v2)
	end, { v2 })

	local leadingIconVariant = React.useMemo(function()
		if v3 and v3.userVote == true then
			return IconVariant.Filled
		end

		return IconVariant.Regular
	end, { v3 })

	local trailingIconVariant = React.useMemo(function()
		if v3 and v3.userVote == false then
			return IconVariant.Filled
		end

		return IconVariant.Regular
	end, { v3 })

	if useAppPolicy(function(p2)
		return p2.getGamePlaysAndRatings()
	end) then
		return React.createElement(SduiDualActionChip, {
			text = text,
			leadingIconName = Foundation.Enums.IconName.ThumbUp,
			leadingIconVariant = leadingIconVariant,
			leadingOnActivated = leadingOnActivated,
			trailingIconName = Foundation.Enums.IconName.ThumbDown,
			trailingIconVariant = trailingIconVariant,
			trailingOnActivated = trailingOnActivated,
			layoutOrder = layoutOrder
		})
	end

	return nil
end

return React.memo(ExperienceDetailsVoteChip)
