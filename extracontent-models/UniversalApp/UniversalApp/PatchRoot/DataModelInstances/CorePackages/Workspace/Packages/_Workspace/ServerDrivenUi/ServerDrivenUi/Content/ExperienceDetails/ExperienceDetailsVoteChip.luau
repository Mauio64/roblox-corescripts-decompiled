local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local Players = game:GetService("Players")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local RoactUtils = require(ServerDrivenUiParent.RoactUtils)
local Game = require(ServerDrivenUiParent.DataHydration).Game
local VotesUtils = Game.VotesUtils
local SduiSharedContent = require(ServerDrivenUiParent.SduiSharedContent)
local ToastRodux = require(ServerDrivenUiParent.ToastRodux)
local DiscoveryAnalytics = require(ServerDrivenUiParent.DiscoveryAnalytics)
local UniversalAppPolicy = require(ServerDrivenUiParent.UniversalAppPolicy)
local SharedFlags = require(ServerDrivenUiParent.SharedFlags)
local IconVariant = Foundation.Enums.IconVariant
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local SduiDualActionChip = SduiSharedContent.SduiDualActionChip
local ToastType = ToastRodux.Enums.ToastType
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local gameVote = DiscoveryAnalytics.Events.gameVote
local useOptimisticUpdateStatus = require(script.Parent.Hooks.useOptimisticUpdateStatus)
local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled

local function convertBooleanToVoteForAnalytics(b1: boolean?) -- line: 37
	if b1 == true then
		return "UpVoted"
	end

	if b1 == false then
		return "DownVoted"
	end

	return "NotVoted"
end
local function ExperienceDetailsVoteChip(t1: {[any]: any}) -- line: 47
	-- upvalues: useDispatch (copy), SignalsReact (copy), Game (copy), React (copy), SetCurrentToastMessage (copy), ToastType (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), useOptimisticUpdateStatus (copy), Players (copy), gameVote (copy), VotesUtils (copy), IconVariant (copy), useAppPolicy (copy), SduiDualActionChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v30 = useDispatch()
	local v31 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchVote(universeId).data)
	local v32 = SignalsReact.useSignalState(Game.getVotesStore(false).getAndFetchUserVote(universeId).data)
	local v33 = Game.getGameInfoStore(false)
	local v34 = SignalsReact.useSignalState(v33.getAndFetchGameInfo(universeId).data)
	local v35 = v34 and v34.rootPlaceId
	local v36 = React.useCallback(function(b2: boolean?) -- line: 59
		-- upvalues: Game (copy), universeId (copy)
		return Game.getVotesStore(false).updateUserVote(universeId, b2)
	end, { universeId })
	local v37 = React.useCallback(function(p1) -- line: 64
		-- upvalues: v30 (copy), SetCurrentToastMessage (copy), ToastType (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), v35 (copy), Game (copy)
		if p1 == nil then
			return
		end

		if p1.type == "error" then
			local s1 = "Feature.Toast.VoteError.Default"
			local reasonForNotVoteable = p1.reasonForNotVoteable

			if reasonForNotVoteable == "PlayGame" then
				s1 = "Feature.Toast.VoteError.PlayGame"
			elseif reasonForNotVoteable == "FloodCheckThresholdMet" then
				s1 = "Feature.Toast.VoteError.FloodCheckThresholdMet"
			elseif reasonForNotVoteable == "AssetNotVoteable" then
				s1 = "Feature.Toast.VoteError.AssetNotVoteable"
			end

			v30(SetCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = s1
			}))

			return
		end

		if p1.type == "success" then
			local userVote = p1.userVote

			if GetFFlagEdpPlayerFeedbackEnabled() and userVote ~= nil and v35 then
				Game.getUserVoteFeedbackMetadataStore(false).getAndFetchUserVoteFeedbackMetadata(v35)
			end
		end
	end, {
		v35,
		v30
	})
	local v38 = useOptimisticUpdateStatus(v36, v37)
	local v39 = React.useCallback(function(b3: boolean?) -- line: 98
		-- upvalues: v32 (copy), v35 (copy), Players (copy), gameVote (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), Game (copy), v38 (copy)
		local v51 = v32 and v32.userVote

		if v51 == b3 then
			b3 = nil
		end

		if v35 then
			local v52 = Players.LocalPlayer and Players.LocalPlayer.UserId
			local v53 = gameVote
			local t2 = {
				uid = tostring(v52),
				placeId = v35
			}

			t2.vote = if b3 ~= true then b3 ~= false and "NotVoted" or "DownVoted" else "UpVoted"
			t2.prevVote = if v51 ~= true then v51 ~= false and "NotVoted" or "DownVoted" else "UpVoted"
			v53(t2, "ExperienceDetailsVoteChip")
		end

		if GetFFlagEdpPlayerFeedbackEnabled() and v35 then
			Game.getUserVoteFeedbackMetadataStore(false).clearItem(v35)
		end

		v38(b3)
	end, {
		universeId,
		v32,
		v35,
		v38,
		v30
	})
	local v40 = React.useCallback(function() -- line: 137
		-- upvalues: v39 (copy)
		v39(true)
	end, { v39 })
	local v41 = React.useCallback(function() -- line: 141
		-- upvalues: v39 (copy)
		v39(false)
	end, { v39 })
	local v42 = React.useMemo(function() -- line: 145
		-- upvalues: VotesUtils (copy), v31 (copy)
		return VotesUtils.getRatingDisplayText(v31)
	end, { v31 })
	local v43 = React.useMemo(function() -- line: 149
		-- upvalues: v32 (copy), IconVariant (copy)
		if v32 and v32.userVote == true then
			return IconVariant.Filled
		end

		return IconVariant.Regular
	end, { v32 })
	local v44 = React.useMemo(function() -- line: 156
		-- upvalues: v32 (copy), IconVariant (copy)
		if v32 and v32.userVote == false then
			return IconVariant.Filled
		end

		return IconVariant.Regular
	end, { v32 })

	if not useAppPolicy(function(p2) -- line: 163
		return p2.getGamePlaysAndRatings()
	end) then
		return nil
	end

	return React.createElement(SduiDualActionChip, {
		text = v42,
		leadingIconName = Foundation.Enums.IconName.ThumbUp,
		leadingIconVariant = v43,
		leadingOnActivated = v40,
		trailingIconName = Foundation.Enums.IconName.ThumbDown,
		trailingIconVariant = v44,
		trailingOnActivated = v41,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsVoteChip)
