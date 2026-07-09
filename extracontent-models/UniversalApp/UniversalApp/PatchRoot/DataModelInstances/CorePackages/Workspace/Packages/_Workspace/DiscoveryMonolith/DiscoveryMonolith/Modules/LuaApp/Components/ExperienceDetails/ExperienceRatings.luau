local LocalizationService = game:GetService("LocalizationService")
local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local IXPService = game:GetService("IXPService")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Roact = require(DiscoveryMonolithParent.Roact)
local RoactRodux = require(DiscoveryMonolithParent.RoactRodux)
local t = require(DiscoveryMonolithParent.t)
local UIBlox = require(DiscoveryMonolithParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(DiscoveryMonolithParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local VoteStates = UIBlox.App.Indicator.Enum.VoteStates
local RateCount = UIBlox.App.Indicator.RateCount
local withStyle = UIBlox.Core.Style.withStyle
local RoactServices = require(DiscoveryMonolithParent.RoactServices).RoactServices
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local AppEventIngestService = require(DiscoveryMonolithParent.RoactServiceTags).AppEventIngestService
local RoactAppPolicy = require(DiscoveryMonolithParent.UniversalAppPolicy).RoactAppPolicy
local memoize = require(DiscoveryMonolithParent.AppCommonLib).memoize
local Localization = require(DiscoveryMonolithParent.RobloxAppLocales).Localization
local abbreviateCount = require(DiscoveryMonolithParent.Localization).abbreviateCount
local GameVotesRodux = require(DiscoveryMonolithParent.GameVotesRodux)
local FetchGameVotes = GameVotesRodux.GameVotes.FetchGameVotes
local FetchUserGameVotes = GameVotesRodux.UserGameVotes.FetchUserGameVotes
local PatchUserVotes = GameVotesRodux.UserGameVotes.PatchUserVotes
local ReasonForNotVoteable = GameVotesRodux.Enums.ReasonForNotVoteable
local VoteStatus = GameVotesRodux.Enums.VoteStatus
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local ToastType = require(DiscoveryMonolithParent.ToastRodux).Enums.ToastType
local SetCurrentToastMessage = require(DiscoveryMonolithParent.ToastRodux).Actions.SetCurrentToastMessage
local GameInfosReducer = require(DiscoveryMonolithParent.GameInfosRodux).GameInfosReducer
local RoactAppExperiment = require(DiscoveryMonolithParent.RoactAppExperiment)
local AppUserLayers = require(DiscoveryMonolithParent.ExperimentLayers).AppUserLayers
local GamePlayerFeedbackPrompt = require(DiscoveryMonolithParent.PlayerFeedback).GamePlayerFeedbackPrompt
local GetGamePlayerFeedbackMetadata = require(DiscoveryMonolithParent.PlayerFeedback).Thunks.GetGamePlayerFeedbackMetadata
local SetCentralOverlay = require(DiscoveryMonolithParent.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(DiscoveryMonolithParent.RobloxAppEnums).CentralOverlayType
local Logging = require(DiscoveryMonolithParent.AppCommonLib).Logging
local Modules = DiscoveryMonolith.Modules
local Vote = require(Modules.LuaApp.Analytics.Events.Games.GameDetailsEvents).Vote
local GetFFlagEdpPlayerFeedbackEnabled = require(DiscoveryMonolithParent.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled
local GetFFlagEdpPlayerFeedbackLogIXPExposure = require(DiscoveryMonolithParent.SharedFlags).GetFFlagEdpPlayerFeedbackLogIXPExposure
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppGameStatsFallbackRendering = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppGameStatsFallbackRendering
local v44 = Roact.PureComponent:extend("ExperienceRatings")

v44.validateProps = t.interface({
	universeId = t.string,
	shouldHydrateLegacyIxp = if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else t.optional(t.boolean),
	height = t.optional(t.number),
	styleProps = t.optional(t.table)
})

local t1 = {
	[VoteStatus.NotVoted] = VoteStates.notVoted,
	[VoteStatus.VotedDown] = VoteStates.votedDown,
	[VoteStatus.VotedUp] = VoteStates.votedUp
}

function v44.init(p1) -- line: 66
	-- upvalues: GetFFlagEdpPlayerFeedbackEnabled (copy), Logging (copy), GetFFlagEdpPlayerFeedbackLogIXPExposure (copy), IXPService (copy), AppUserLayers (copy), VoteStatus (copy), Localization (copy), LocalizationService (copy), memoize (copy), abbreviateCount (copy), ReasonForNotVoteable (copy), RetrievalStatus (copy), Vote (copy), ToastType (copy)
	p1.isMounted = false

	if GetFFlagEdpPlayerFeedbackEnabled() then
		p1.state = {
			isFeedbackPromptOpen = false,
			playerFeedbackMetadata = nil
		}

		function p1.openInlineFeedbackPrompt() -- line: 74
			-- upvalues: p1 (copy)
			p1:setState({
				isFeedbackPromptOpen = true
			})
		end
		function p1.closeInlineFeedbackPrompt() -- line: 79
			-- upvalues: p1 (copy)
			p1:setState({
				isFeedbackPromptOpen = false
			})
		end
		function p1.onClickFeedbackPromptButton() -- line: 84
			-- upvalues: p1 (copy), Logging (copy)
			if not p1.state.playerFeedbackMetadata then
				Logging.warn("Player feedback metadata is not available from feedback prompt")

				return
			end

			p1.props.openFeedbackForm(p1.props.universeId, p1.state.playerFeedbackMetadata, p1.closeInlineFeedbackPrompt)
		end
		function p1.onVoteSuccess(s1: string) -- line: 95
			-- upvalues: GetFFlagEdpPlayerFeedbackLogIXPExposure (copy), IXPService (copy), AppUserLayers (copy), p1 (copy), VoteStatus (copy), Logging (copy)
			if GetFFlagEdpPlayerFeedbackLogIXPExposure() then
				IXPService:LogUserLayerExposure(AppUserLayers.EDPPlayerFeedbackExposureLayer)
			end

			if not p1.props.enablePlayerFeedback then
				return
			end

			local universeId = p1.props.universeId
			local networking = p1.props.networking
			local rootPlaceId = p1.props.rootPlaceId

			if s1 == VoteStatus.NotVoted then
				p1.closeInlineFeedbackPrompt()

				return
			end

			p1.props.getGamePlayerFeedbackMetadata(networking, universeId, s1, rootPlaceId):andThen(function(p2) -- line: 115
				-- upvalues: p1 (copy), universeId (copy)
				if p2 and p2.canSubmitReview then
					if p1.props.showInlineFeedbackPrompt then
						p1:setState({
							playerFeedbackMetadata = p2
						})
						p1.openInlineFeedbackPrompt()

						return
					end

					p1.props.openFeedbackForm(universeId, p2)
				end
			end, function() -- line: 126
				-- upvalues: Logging (copy)
				Logging.warn("Failed to get player feedback metadata")
			end)
		end
	end

	local v50 = Localization.new(LocalizationService.RobloxLocaleId)

	p1.getVoteTexts = memoize(function(p3, p4, p5, p6) -- line: 135
		-- upvalues: abbreviateCount (copy), v50 (copy)
		local v95 = nil

		if p3 and p4 then
			v95 = p3 + p4
		end

		local v96 = v95 and abbreviateCount(v95, v50:GetLocale()) or "--"
		local v97 = if not p5 or not p6 then string.upper(v50:Format("Feature.GameDetails.Label.Upvoted")) else string.upper(v50:Format("Feature.GameDetails.Label.Votes", {
			votes = v96
		}))

		return {
			votePercentageText = v95 and (v95 > 0 and tostring((math.floor(p3 / v95 * 100))) .. "%") or "--",
			totalVotesText = v97
		}
	end)

	local t2 = {
		[ReasonForNotVoteable.PlayGame] = "Feature.Toast.VoteError.PlayGame",
		[ReasonForNotVoteable.FloodCheckThresholdMet] = "Feature.Toast.VoteError.FloodCheckThresholdMet",
		[ReasonForNotVoteable.AssetNotVoteable] = "Feature.Toast.VoteError.AssetNotVoteable",
		Default = "Feature.Toast.VoteError.Default"
	}

	function p1.onVoteButtonActivated(p7) -- line: 167
		-- upvalues: p1 (copy), RetrievalStatus (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), VoteStatus (copy), Vote (copy), t2 (copy), ToastType (copy)
		local universeId = p1.props.universeId
		local networking = p1.props.networking
		local rootPlaceId = p1.props.rootPlaceId

		if p1.props.voteDataIsLoading then
			return
		end

		if not p1.isMounted or not rootPlaceId then
			return
		end

		if not p1.props.voteDataLoadSucceed then
			if p1.props.gameVotesFetchingStatus == RetrievalStatus.Failed then
				p1.props.dispatchFetchGameVotes(networking, universeId)
			else
				local eventIngest = p1.props.eventIngest

				if GetFFlagEdpPlayerFeedbackEnabled() then
					p1.props.patchUserVotes(networking, universeId, p7, VoteStatus.NotVoted):andThen(function(p8) -- line: 191
						-- upvalues: p1 (copy), p7 (ref)
						if p8 ~= nil then
							p1.onVoteSuccess(p7)
						end
					end)
				else
					p1.props.patchUserVotes(networking, universeId, p7, VoteStatus.NotVoted)
				end

				Vote(eventIngest, "GameRatings", rootPlaceId, p7, VoteStatus.NotVoted)
			end

			return
		end

		local userGameVotes = p1.props.userGameVotes
		local reasonForNotVoteable = userGameVotes.reasonForNotVoteable

		if userGameVotes.canVote then
			local eventIngest = p1.props.eventIngest
			local userVote = userGameVotes.userVote

			if userVote == p7 then
				p7 = VoteStatus.NotVoted
			end

			if GetFFlagEdpPlayerFeedbackEnabled() then
				p1.props.patchUserVotes(networking, universeId, p7, userVote):andThen(function(p9) -- line: 218
					-- upvalues: p1 (copy), p7 (ref)
					if p9 ~= nil then
						p1.onVoteSuccess(p7)
					end
				end)
			else
				p1.props.patchUserVotes(networking, universeId, p7, userVote)
			end

			Vote(eventIngest, "GameRatings", rootPlaceId, p7, userVote)
		else
			local v108 = t2[reasonForNotVoteable] or t2.Default

			p1.props.setCurrentToastMessage({
				toastType = ToastType.NetworkingError,
				toastMessage = v108
			})
		end
	end
	function p1.onVoteUpActivated() -- line: 237
		-- upvalues: p1 (copy), VoteStatus (copy)
		p1.onVoteButtonActivated(VoteStatus.VotedUp)
	end
	function p1.onVoteDownActivated() -- line: 241
		-- upvalues: p1 (copy), VoteStatus (copy)
		p1.onVoteButtonActivated(VoteStatus.VotedDown)
	end
end
function v44.render(p10) -- line: 246
	-- upvalues: RetrievalStatus (copy), VoteStatus (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), Roact (copy), RateCount (copy), t1 (copy), withStyle (copy), GamePlayerFeedbackPrompt (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local gameVotes = p10.props.gameVotes
	local userGameVotes = p10.props.userGameVotes
	local gameVotesFetchingStatus = p10.props.gameVotesFetchingStatus
	local voteDataLoadSucceed = p10.props.voteDataLoadSucceed
	local v57 = gameVotes and gameVotes.upVotes
	local v58 = gameVotes and gameVotes.downVotes

	if gameVotesFetchingStatus == RetrievalStatus.Done then
		v57 = v57 or 0
		v58 = v58 or 0
	end

	local v59 = voteDataLoadSucceed and (userGameVotes and userGameVotes.userVote) or VoteStatus.NotVoted
	local showGlobalCounters = p10.props.showGlobalCounters
	local showLikesFavoritesCount = p10.props.showLikesFavoritesCount
	local v62 = p10.getVoteTexts(v57, v58, showGlobalCounters, showLikesFavoritesCount)

	if GetFFlagEdpPlayerFeedbackEnabled() then
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 10)
			}),
			RateCount = Roact.createElement(RateCount, {
				height = p10.props.height,
				rateText = v62.votePercentageText,
				rateLabel = v62.totalVotesText,
				voteState = t1[v59],
				onVoteDownActivated = p10.onVoteDownActivated,
				onVoteUpActivated = p10.onVoteUpActivated,
				styleProps = p10.props.styleProps
			}),
			PlayerFeedbackPrompt = p10.state.isFeedbackPromptOpen and withStyle(function(p11) -- line: 285
				-- upvalues: Roact (copy), GamePlayerFeedbackPrompt (copy), p10 (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
				return Roact.createElement(GamePlayerFeedbackPrompt, {
					placeId = p10.props.rootPlaceId,
					backgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Semantic.Color.Background.Contrast else p11.Tokens.Color.Surface.Surface_100)).Transparency,
					backgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p11.Tokens.Semantic.Color.Background.Contrast else p11.Tokens.Color.Surface.Surface_100)).Color3,
					onDimiss = p10.closeInlineFeedbackPrompt,
					onButtonClick = p10.onClickFeedbackPromptButton
				}) or nil
			end)
		})
	end

	return Roact.createElement(RateCount, {
		rateText = v62.votePercentageText,
		rateLabel = v62.totalVotesText,
		voteState = t1[v59],
		onVoteDownActivated = p10.onVoteDownActivated,
		onVoteUpActivated = p10.onVoteUpActivated
	})
end
function v44.didMount(p12) -- line: 310
	p12.isMounted = true
end
function v44.willUnmount(p13) -- line: 314
	p13.isMounted = false
end

local function getGameVotesWithFallback(p14, p15) -- line: 318
	-- upvalues: FFlagLuaAppGameStatsFallbackRendering (copy), GameInfosReducer (copy)
	local v67 = p14.GameVotes[p15]

	if v67 then
		return v67
	end

	if FFlagLuaAppGameStatsFallbackRendering then
		local v68 = p14.Personalization[GameInfosReducer.key][p15]

		if v68 then
			return {
				upVotes = v68.totalUpVotes or 0,
				downVotes = v68.totalDownVotes or 0
			}
		end
	end

	return nil
end

local v47 = RoactRodux.connect(function(p16, p17) -- line: 338
	-- upvalues: FetchGameVotes (copy), FetchUserGameVotes (copy), PatchUserVotes (copy), FFlagLuaAppGameStatsFallbackRendering (copy), GameInfosReducer (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), RetrievalStatus (copy)
	local universeId = p17.universeId
	local v72 = FetchGameVotes.GetFetchingStatus(p16, universeId)
	local v73 = FetchUserGameVotes.GetFetchingStatus(p16, universeId)
	local v74 = PatchUserVotes.GetPatchingStatus(p16, universeId)
	local v75 = p16.GameVotes[universeId]
	local g76 = nil
	local v77 = nil

	if v75 then
		g76 = true
	end

	repeat
		if g76 or (g76 or FFlagLuaAppGameStatsFallbackRendering) then
			if not g76 then
				if not g76 then
					v77 = p16.Personalization[GameInfosReducer.key][universeId]
				end
			end

			if g76 or (g76 or v77) then
				if not g76 then
					if not g76 then
						v75 = {
							upVotes = v77.totalUpVotes or 0,
							downVotes = v77.totalDownVotes or 0
						}
					end
				end

				g76 = false

				local v78 = p16.UserGameVotes[p17.universeId]
				local v79 = nil

				if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p17.shouldHydrateLegacyIxp then
					if p16.GameDetailsV2 and p16.GameDetailsV2[p17.universeId] then
						v79 = p16.GameDetailsV2 and p16.GameDetailsV2[p17.universeId].rootPlaceId
					else
						local v80 = p16.Personalization[GameInfosReducer.key][p17.universeId]

						if v80 then
							v79 = v80.placeId
						end
					end
				elseif p16.GameDetails and p16.GameDetails[p17.universeId] then
					v79 = p16.GameDetails and p16.GameDetails[p17.universeId].rootPlaceId
				else
					local v81 = p16.Personalization[GameInfosReducer.key][p17.universeId]

					if v81 then
						v79 = v81.placeId
					end
				end

				return {
					gameVotesFetchingStatus = v72,
					voteDataIsLoading = v72 == RetrievalStatus.Fetching or (v73 == RetrievalStatus.Fetching or v74 == RetrievalStatus.Fetching),
					voteDataLoadSucceed = v75 and v78,
					gameVotes = v75,
					userGameVotes = v78,
					rootPlaceId = v79
				}
			end
		end

		v75 = nil
		g76 = true
	until not g76
end, function(p18) -- line: 382
	-- upvalues: FetchGameVotes (copy), PatchUserVotes (copy), GetFFlagEdpPlayerFeedbackEnabled (copy), SetCentralOverlay (copy), CentralOverlayType (copy), GetGamePlayerFeedbackMetadata (copy), SetCurrentToastMessage (copy)
	return {
		dispatchFetchGameVotes = function(p19, p20) -- line: 384
			-- upvalues: p18 (copy), FetchGameVotes (copy)
			return p18(FetchGameVotes.Fetch(p19, p20))
		end,
		patchUserVotes = function(p21, p22, p23, p24) -- line: 387
			-- upvalues: p18 (copy), PatchUserVotes (copy)
			return p18(PatchUserVotes.Patch(p21, p22, p23, p24))
		end,
		openFeedbackForm = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else function(p25, p26, p27) -- line: 391
			-- upvalues: p18 (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
			return p18(SetCentralOverlay(CentralOverlayType.GamePlayerFeedbackForm, {
				universeId = p25,
				playerFeedbackMetadata = p26,
				onSubmitted = p27
			}))
		end,
		getGamePlayerFeedbackMetadata = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else function(p28, p29, p30, p31) -- line: 400
			-- upvalues: p18 (copy), GetGamePlayerFeedbackMetadata (copy)
			return p18(GetGamePlayerFeedbackMetadata.Get(p28, p29, p31, p30))
		end,
		setCurrentToastMessage = function(p32) -- line: 404
			-- upvalues: p18 (copy), SetCurrentToastMessage (copy)
			return p18(SetCurrentToastMessage(p32))
		end
	}
end)(v44)

if GetFFlagEdpPlayerFeedbackEnabled() then
	v47 = RoactAppExperiment.connectUserLayer({ AppUserLayers.EDPPlayerFeedbackExposureLayer }, function(p33, _) -- line: 413
		-- upvalues: AppUserLayers (copy)
		local v85 = p33[AppUserLayers.EDPPlayerFeedbackExposureLayer] or {}

		return {
			enablePlayerFeedback = v85.ShowFeedbackForm,
			showInlineFeedbackPrompt = v85.ShowInlinePrompt
		}
	end, false)(v47)
end

local v48 = RoactServices.connect({
	networking = RoactNetworking,
	eventIngest = AppEventIngestService
})(v47)

return (RoactAppPolicy.connect(function(p35) -- line: 427
	return {
		showGlobalCounters = p35.getShowGlobalCounters(),
		showLikesFavoritesCount = p35.getEnableAggregateLikesFavoritesCount()
	}
end)(v48))
