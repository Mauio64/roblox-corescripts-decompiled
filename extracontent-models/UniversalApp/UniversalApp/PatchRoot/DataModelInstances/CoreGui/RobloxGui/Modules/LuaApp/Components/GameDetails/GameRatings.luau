local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local abbreviateCount = require(CorePackages.Workspace.Packages.Localization).abbreviateCount
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local GameVotesRodux = require(CorePackages.Workspace.Packages.GameVotesRodux)
local ReasonForNotVoteable = GameVotesRodux.Enums.ReasonForNotVoteable
local VoteStatus = GameVotesRodux.Enums.VoteStatus
local FetchGameVotes = GameVotesRodux.GameVotes.FetchGameVotes
local FetchUserGameVotes = GameVotesRodux.UserGameVotes.FetchUserGameVotes
local PatchUserVotes = GameVotesRodux.UserGameVotes.PatchUserVotes
local ToastType = require(CorePackages.Workspace.Packages.ToastRodux).Enums.ToastType
local SetCurrentToastMessage = require(CorePackages.Workspace.Packages.ToastRodux).Actions.SetCurrentToastMessage
local GameInfosReducer = require(CorePackages.Workspace.Packages.GameInfosRodux).GameInfosReducer
local withStyle = require(CorePackages.Packages.UIBlox).Style.withStyle
local Vote = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents.Vote
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local GenericIconButton = require(Modules.LuaApp.Components.GenericIconButton)
local DEPRECATED_ImageSetLabel = require(Modules.LuaApp.Components.DEPRECATED_ImageSetLabel)
local PrimaryStatWidget = require(Modules.LuaApp.Components.PrimaryStatWidget)
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local GetFFlagEdpPlayerFeedbackEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local rect = Rect.new(9, 9, 9, 9)
local v30 = Roact.PureComponent:extend("GameRatings")

function v30.init(p1) -- line: 57
	-- upvalues: RetrievalStatus (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), VoteStatus (copy), Vote (copy), ReasonForNotVoteable (copy), ToastType (copy)
	p1.isMounted = false

	function p1.onVoteButtonActivated(p2) -- line: 59
		-- upvalues: p1 (copy), RetrievalStatus (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), VoteStatus (copy), Vote (copy), ReasonForNotVoteable (copy), ToastType (copy)
		local universeId = p1.props.universeId
		local networking = p1.props.networking
		local rootPlaceId = p1.props.rootPlaceId

		if not p1.isMounted or not rootPlaceId then
			return
		end

		if not p1.props.dataLoadSucceed then
			if p1.props.gameVotesFetchingStatus == RetrievalStatus.Failed then
				p1.props.dispatchFetchGameVotes(networking, universeId)
			else
				local eventIngest = p1.props.eventIngest

				if GetFFlagEdpPlayerFeedbackEnabled() then
					p1.props.patchUserVotes(networking, universeId, p2, VoteStatus.NotVoted):andThen(function(p3) -- line: 78
						-- upvalues: p1 (copy), p2 (ref)
						if p3 ~= nil then
							p1.props.onVoteSuccess(p2)
						end
					end)
				else
					p1.props.patchUserVotes(networking, universeId, p2, VoteStatus.NotVoted)
				end

				Vote(eventIngest, "GameRatings", rootPlaceId, p2, VoteStatus.NotVoted)
			end

			return
		end

		local userGameVotes = p1.props.userGameVotes
		local reasonForNotVoteable = userGameVotes.reasonForNotVoteable

		if userGameVotes.canVote then
			local eventIngest = p1.props.eventIngest
			local userVote = userGameVotes.userVote

			if userVote == p2 then
				p2 = VoteStatus.NotVoted
			end

			if GetFFlagEdpPlayerFeedbackEnabled() then
				p1.props.patchUserVotes(networking, universeId, p2, userVote):andThen(function(p4) -- line: 104
					-- upvalues: p1 (copy), p2 (ref)
					if p4 ~= nil then
						p1.props.onVoteSuccess(p2)
					end
				end)
			else
				p1.props.patchUserVotes(networking, universeId, p2, userVote)
			end

			Vote(eventIngest, "GameRatings", rootPlaceId, p2, userVote)
		elseif reasonForNotVoteable == ReasonForNotVoteable.PlayGame then
			p1.props.setCurrentToastMessage({
				toastMessage = "Feature.Toast.VoteError.PlayGame",
				toastType = ToastType.NetworkingError
			})
		elseif reasonForNotVoteable == ReasonForNotVoteable.FloodCheckThresholdMet then
			p1.props.setCurrentToastMessage({
				toastMessage = "Feature.Toast.VoteError.FloodCheckThresholdMet",
				toastType = ToastType.NetworkingError
			})
		elseif reasonForNotVoteable == ReasonForNotVoteable.AssetNotVoteable then
			p1.props.setCurrentToastMessage({
				toastMessage = "Feature.Toast.VoteError.AssetNotVoteable",
				toastType = ToastType.NetworkingError
			})
		else
			p1.props.setCurrentToastMessage({
				toastMessage = "Feature.Toast.VoteError.Default",
				toastType = ToastType.NetworkingError
			})
		end
	end
	function p1.onVoteUpActivated() -- line: 136
		-- upvalues: p1 (copy), VoteStatus (copy)
		p1.onVoteButtonActivated(VoteStatus.VotedUp)
	end
	function p1.onVoteDownActivated() -- line: 140
		-- upvalues: p1 (copy), VoteStatus (copy)
		p1.onVoteButtonActivated(VoteStatus.VotedDown)
	end
end
function v30.render(p5) -- line: 145
	-- upvalues: RetrievalStatus (copy), abbreviateCount (copy), withStyle (copy), Roact (copy), DEPRECATED_ImageSetLabel (copy), rect (copy), PrimaryStatWidget (copy), GenericIconButton (copy), VoteStatus (copy)
	local propsPosition = p5.props.Position
	local propsLayoutOrder = p5.props.LayoutOrder
	local width = p5.props.width
	local gameVotes = p5.props.gameVotes
	local userGameVotes = p5.props.userGameVotes
	local gameVotesFetchingStatus = p5.props.gameVotesFetchingStatus
	local isLoading = p5.props.isLoading
	local dataLoadSucceed = p5.props.dataLoadSucceed
	local showGlobalCounters = p5.props.showGlobalCounters
	local showLikesFavoritesCount = p5.props.showLikesFavoritesCount
	local localization = p5.props.localization
	local v45 = gameVotes and gameVotes.upVotes or 0
	local v46 = v45 + (gameVotes and gameVotes.downVotes or 0)
	local v47 = gameVotesFetchingStatus == RetrievalStatus.Done and abbreviateCount(v46, localization:GetLocale()) or "--"
	local u48 = if not showGlobalCounters or not showLikesFavoritesCount then string.upper(localization:Format("Feature.GameDetails.Label.Upvoted")) else string.upper(localization:Format("Feature.GameDetails.Label.Votes", {
		votes = v47
	}))
	local v49 = v46 > 0 and tostring((math.floor(v45 / v46 * 100))) .. "%" or "--"
	local v50 = dataLoadSucceed and (userGameVotes and userGameVotes.userVote)

	return withStyle(function(p6) -- line: 178
		-- upvalues: Roact (copy), DEPRECATED_ImageSetLabel (copy), width (copy), propsPosition (copy), propsLayoutOrder (copy), rect (copy), PrimaryStatWidget (copy), v49 (copy), u48 (ref), GenericIconButton (copy), v50 (copy), VoteStatus (copy), isLoading (copy), p5 (copy)
		return Roact.createElement(DEPRECATED_ImageSetLabel, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "LuaApp/buttons/buttonFill",
			Size = UDim2.new(0, width, 0, 70),
			Position = propsPosition,
			LayoutOrder = propsLayoutOrder,
			ImageColor3 = p6.Theme.UIEmphasis.Color,
			ImageTransparency = p6.Theme.UIEmphasis.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = rect
		}, {
			RatingsStat = Roact.createElement(PrimaryStatWidget, {
				icon = "LuaApp/icons/GameDetails/rating_large",
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				number = v49,
				label = u48,
				width = width - 88 - 30
			}),
			VoteUp = Roact.createElement(GenericIconButton, {
				withNewThemeProvider = true,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -10, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				iconImage = v50 ~= VoteStatus.VotedUp and "LuaApp/icons/GameDetails/voteUpOff" or "LuaApp/icons/GameDetails/voteUpOn",
				iconSize = UDim2.new(0, 36, 0, 36),
				isChecked = v50 == VoteStatus.VotedUp,
				isLoading = isLoading,
				onActivated = p5.onVoteUpActivated
			}),
			VoteDown = Roact.createElement(GenericIconButton, {
				withNewThemeProvider = true,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -64, 0.5, 0),
				Size = UDim2.new(0, 44, 0, 44),
				iconImage = v50 ~= VoteStatus.VotedDown and "LuaApp/icons/GameDetails/voteDownOff" or "LuaApp/icons/GameDetails/voteDownOn",
				iconSize = UDim2.new(0, 36, 0, 36),
				isChecked = v50 == VoteStatus.VotedDown,
				isLoading = isLoading,
				onActivated = p5.onVoteDownActivated
			})
		})
	end)
end
function v30.didMount(p7) -- line: 225
	p7.isMounted = true
end
function v30.willUnmount(p8) -- line: 229
	p8.isMounted = false
end

local v31 = RoactRodux.connect(function(p9, p10) -- line: 233
	-- upvalues: PatchUserVotes (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), FetchGameVotes (copy), FetchUserGameVotes (copy), GameInfosReducer (copy), RetrievalStatus (copy)
	local v55 = PatchUserVotes.GetPatchingStatus(p9, p10.universeId)
	local v56, v57

	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p10.shouldHydrateLegacyIxp then
		v56 = ApiFetchExperienceDetailsPage.GetFetchingStatus(p9, p10.universeId)
		v57 = ApiFetchExperienceDetailsPage.GetFetchingStatus(p9, p10.universeId)
	else
		v56 = FetchGameVotes.GetFetchingStatus(p9, p10.universeId)
		v57 = FetchUserGameVotes.GetFetchingStatus(p9, p10.universeId)
	end

	local v58 = p9.GameVotes[p10.universeId]
	local v59 = p9.UserGameVotes[p10.universeId]
	local v60 = nil

	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p10.shouldHydrateLegacyIxp then
		if p9.GameDetailsV2 and p9.GameDetailsV2[p10.universeId] then
			v60 = p9.GameDetailsV2 and p9.GameDetailsV2[p10.universeId].rootPlaceId
		else
			local v61 = p9.Personalization[GameInfosReducer.key][p10.universeId]

			if v61 then
				v60 = v61.placeId
			end
		end
	elseif p9.GameDetails and p9.GameDetails[p10.universeId] then
		v60 = p9.GameDetails and p9.GameDetails[p10.universeId].rootPlaceId
	else
		local v62 = p9.Personalization[GameInfosReducer.key][p10.universeId]

		if v62 then
			v60 = v62.placeId
		end
	end

	return {
		gameVotes = v58,
		userGameVotes = v59,
		rootPlaceId = v60,
		gameVotesFetchingStatus = v56,
		isLoading = v56 == RetrievalStatus.Fetching or (v57 == RetrievalStatus.Fetching or v55 == RetrievalStatus.Fetching),
		dataLoadSucceed = v58 and v59
	}
end, function(p11) -- line: 286
	-- upvalues: SetCurrentToastMessage (copy), FetchGameVotes (copy), PatchUserVotes (copy)
	return {
		setCurrentToastMessage = function(p12) -- line: 288
			-- upvalues: p11 (copy), SetCurrentToastMessage (copy)
			return p11(SetCurrentToastMessage(p12))
		end,
		dispatchFetchGameVotes = function(p13, p14) -- line: 291
			-- upvalues: p11 (copy), FetchGameVotes (copy)
			return p11(FetchGameVotes.Fetch(p13, p14))
		end,
		patchUserVotes = function(p15, p16, p17, p18) -- line: 294
			-- upvalues: p11 (copy), PatchUserVotes (copy)
			return p11(PatchUserVotes.Patch(p15, p16, p17, p18))
		end
	}
end)(v30)

return RoactServices.connect({
	localization = RoactLocalization,
	networking = RoactNetworking,
	eventIngest = AppEventIngestService
})(v31)
