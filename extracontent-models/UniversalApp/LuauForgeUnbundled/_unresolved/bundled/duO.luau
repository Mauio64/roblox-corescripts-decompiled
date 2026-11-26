local LocalizationService = game:GetService("LocalizationService")

local IXPService = game:GetService("IXPService")

local module = require("@luauforge/bundled/duh")
local none = module.None
local module2 = require("@luauforge/bundled/dui")
local module3 = require("@luauforge/bundled/dul")
local module4 = require("@luauforge/bundled/duf")

local voteStates = module4.App.Indicator.Enum.VoteStates
local rateCount = module4.App.Indicator.RateCount
local withStyle = module4.Core.Style.withStyle
local roactServices = require("@luauforge/bundled/duj").RoactServices
local roactNetworking = require("@luauforge/bundled/dum").RoactNetworking
local appEventIngestService = require("@luauforge/bundled/dum").AppEventIngestService
local roactAppPolicy = require("@luauforge/bundled/duP").RoactAppPolicy
local memoize = require("@luauforge/bundled/dua").memoize
local localization = require("@luauforge/bundled/duQ").Localization
local abbreviateCount = require("@luauforge/bundled/duR").abbreviateCount
local module5 = require("@luauforge/bundled/duS")
local fetchGameVotes = module5.GameVotes.FetchGameVotes
local fetchUserGameVotes = module5.UserGameVotes.FetchUserGameVotes
local patchUserVotes = module5.UserGameVotes.PatchUserVotes
local reasonForNotVoteable = module5.Enums.ReasonForNotVoteable
local voteStatus = module5.Enums.VoteStatus
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local toastType = require("@luauforge/bundled/duT").Enums.ToastType
local setCurrentToastMessage = require("@luauforge/bundled/duT").Actions.SetCurrentToastMessage
local module6 = require("@luauforge/bundled/duU")
local module7 = require("@luauforge/bundled/duV")
local appUserLayers = require("@luauforge/bundled/duW").AppUserLayers
local gamePlayerFeedbackPrompt = require("@luauforge/bundled/duX").GamePlayerFeedbackPrompt
local getGamePlayerFeedbackMetadata = require("@luauforge/bundled/duX").Thunks.GetGamePlayerFeedbackMetadata
local setCentralOverlay = require("@luauforge/bundled/duY").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/dup").CentralOverlayType
local logging = require("@luauforge/bundled/dua").Logging

local vote = require("@luauforge/bundled/dtZ").Vote

local getFFlagEdpPlayerFeedbackEnabled = require("@luauforge/bundled/dtD").GetFFlagEdpPlayerFeedbackEnabled
local getFFlagEdpPlayerFeedbackLogIXPExposure = require("@luauforge/bundled/dtD").GetFFlagEdpPlayerFeedbackLogIXPExposure
local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@luauforge/bundled/dtD").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@luauforge/bundled/dtD").FFlagLuaAppAddUniverseIdToEngagementEvents

local extended = module.PureComponent:extend("ExperienceRatings")

local interface = module3.interface
local v5 = {
	universeId = module3.string,
	shouldHydrateLegacyIxp = 0,
	height = 0,
	styleProps = 0
}
local v6 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then module3.optional(module3.boolean) else nil
v5.shouldHydrateLegacyIxp = v6
v5.height = module3.optional(module3.number)
v5.styleProps = module3.optional(module3.table)
extended.validateProps = interface(v5)

local v7 = {
	[voteStatus.NotVoted] = voteStates.notVoted,
	[voteStatus.VotedDown] = voteStates.votedDown,
	[voteStatus.VotedUp] = voteStates.votedUp
}

function extended:init()
	self.isMounted = false

	if getFFlagEdpPlayerFeedbackEnabled() then
		self.state = { isFeedbackPromptOpen = false, playerFeedbackMetadata = nil }

		function self.openInlineFeedbackPrompt()
			self:setState({ isFeedbackPromptOpen = true })
		end
		function self.closeInlineFeedbackPrompt()
			self:setState({ isFeedbackPromptOpen = false })
		end
		function self.onClickFeedbackPromptButton()
			if self.state.playerFeedbackMetadata then
				self.props.openFeedbackForm(
					self.props.universeId,
					self.state.playerFeedbackMetadata,
					self.closeInlineFeedbackPrompt
				)
			else
				logging.warn("Player feedback metadata is not available from feedback prompt")
			end
		end
		function self.onVoteSuccess(p2)
			if getFFlagEdpPlayerFeedbackLogIXPExposure() then
				IXPService:LogUserLayerExposure(appUserLayers.EDPPlayerFeedbackExposureLayer)
			end

			if not self.props.enablePlayerFeedback then
				return
			end

			local universeId = self.props.universeId
			local networking = self.props.networking
			local rootPlaceId = self.props.rootPlaceId
				or self.state.gameInfo and self.state.gameInfo.rootPlaceId

			if p2 == voteStatus.NotVoted then
				self.closeInlineFeedbackPrompt()
			else
				self.props.getGamePlayerFeedbackMetadata(networking, universeId, p2, rootPlaceId):andThen(
					function(p3)
						if p3 and p3.canSubmitReview then
							if self.props.showInlineFeedbackPrompt then
								self:setState({ playerFeedbackMetadata = p3 })

								self.openInlineFeedbackPrompt()
							else
								self.props.openFeedbackForm(universeId, p3)
							end
						end
					end,
					function()
						logging.warn("Failed to get player feedback metadata")
					end
				)
			end
		end
	end

	self.gameInfoSubscription = module6.subscribeGameInfo({
		universeId = self.props.universeId,
		onChange = function(p2)
			self:setState({
				gameInfo = p2.gameInfo or none,
				storeVotes = p2.votes or none
			})
		end
	})

	local v8 = localization.new(LocalizationService.RobloxLocaleId)

	self.getVoteTexts = memoize(function(p2, p3, p4, p5)
		local v9 = if p2 and p3 then p2 + p3 else nil

		local v10 = v9 and abbreviateCount(v9, v8:GetLocale()) or "--"

		local v11 = if p4 and p5 then string.upper(v8:Format("Feature.GameDetails.Label.Votes", {
			votes = v10
		})) else string.upper(v8:Format("Feature.GameDetails.Label.Upvoted"))

		return {
			votePercentageText = v9 and v9 > 0 and tostring((math.floor(p2 / v9 * 100))) .. "%" or "--",
			totalVotesText = v11
		}
	end)

	local v9 = {
		[reasonForNotVoteable.PlayGame] = "Feature.Toast.VoteError.PlayGame",
		[reasonForNotVoteable.FloodCheckThresholdMet] = "Feature.Toast.VoteError.FloodCheckThresholdMet",
		[reasonForNotVoteable.AssetNotVoteable] = "Feature.Toast.VoteError.AssetNotVoteable",
		Default = "Feature.Toast.VoteError.Default"
	}

	function self.onVoteButtonActivated(p2)
		local universeId = self.props.universeId
		local networking = self.props.networking
		local rootPlaceId = self.props.rootPlaceId
			or self.state.gameInfo and self.state.gameInfo.rootPlaceId

		if self.props.voteDataIsLoading or not (self.isMounted and rootPlaceId) then
			return
		end

		if (self.props.gameVotes or self.state.storeVotes) and self.props.userGameVotes then
			local userGameVotes = self.props.userGameVotes
			local reasonForNotVoteable2 = userGameVotes.reasonForNotVoteable

			if userGameVotes.canVote then
				local eventIngest = self.props.eventIngest
				local userVote = userGameVotes.userVote

				if userVote == p2 then
					p2 = voteStatus.NotVoted
				end

				if getFFlagEdpPlayerFeedbackEnabled() then
					self.props.patchUserVotes(networking, universeId, p2, userVote):andThen(function(p3)
						if p3 ~= nil then
							self.onVoteSuccess(p2)
						end
					end)
				else
					self.props.patchUserVotes(networking, universeId, p2, userVote)
				end

				local v12 = p2

				if not fFlagLuaAppAddUniverseIdToEngagementEvents then
					universeId = nil
				end

				vote(eventIngest, "GameRatings", rootPlaceId, v12, userVote, universeId)
			else
				local v10 = v9[reasonForNotVoteable2] or v9.Default
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = v10
				})
			end
		elseif self.props.gameVotesFetchingStatus == retrievalStatus.Failed then
			self.props.dispatchFetchGameVotes(networking, universeId)
		else
			local eventIngest = self.props.eventIngest

			if getFFlagEdpPlayerFeedbackEnabled() then
				local patchUserVotes2 = self.props.patchUserVotes
				local v10 = p2
				patchUserVotes2(networking, universeId, v10, voteStatus.NotVoted):andThen(function(p3)
					if p3 ~= nil then
						self.onVoteSuccess(p2)
					end
				end)
			else
				local patchUserVotes2 = self.props.patchUserVotes
				local v10 = p2
				patchUserVotes2(networking, universeId, v10, voteStatus.NotVoted)
			end

			local v12 = p2
			local notVoted = voteStatus.NotVoted

			if not fFlagLuaAppAddUniverseIdToEngagementEvents then
				universeId = nil
			end

			vote(eventIngest, "GameRatings", rootPlaceId, v12, notVoted, universeId)
		end
	end

	function self.onVoteUpActivated()
		self.onVoteButtonActivated(voteStatus.VotedUp)
	end

	function self.onVoteDownActivated()
		self.onVoteButtonActivated(voteStatus.VotedDown)
	end
end

function extended.render(props)
	local gameVotes = props.props.gameVotes or props.state.storeVotes
	local userGameVotes = props.props.userGameVotes
	local gameVotesFetchingStatus = props.props.gameVotesFetchingStatus
	local userGameVotes2 = gameVotes and props.props.userGameVotes

	local v8 = gameVotes and gameVotes.upVotes
	local v9 = gameVotes and gameVotes.downVotes

	if gameVotesFetchingStatus == retrievalStatus.Done then
		v8 = v8 or 0
		v9 = v9 or 0
	end

	local userVote = userGameVotes2 and userGameVotes and userGameVotes.userVote or voteStatus.NotVoted
	local showGlobalCounters = props.props.showGlobalCounters
	local showLikesFavoritesCount = props.props.showLikesFavoritesCount
	local voteTexts = props.getVoteTexts(v8, v9, showGlobalCounters, showLikesFavoritesCount)

	if getFFlagEdpPlayerFeedbackEnabled() then
		return module.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1
			},
			{
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 10)
				}),
				RateCount = module.createElement(rateCount, {
					height = props.props.height,
					rateText = voteTexts.votePercentageText,
					rateLabel = voteTexts.totalVotesText,
					voteState = v7[userVote],
					onVoteDownActivated = props.onVoteDownActivated,
					onVoteUpActivated = props.onVoteUpActivated,
					styleProps = props.props.styleProps
				}),
				PlayerFeedbackPrompt = props.state.isFeedbackPromptOpen and withStyle(function(p2)
					return module.createElement(gamePlayerFeedbackPrompt, {
						placeId = props.props.rootPlaceId or props.state.gameInfo and props.state.gameInfo.rootPlaceId,
						backgroundTransparency = p2.Tokens.Color.Surface.Surface_100.Transparency,
						backgroundColor3 = p2.Tokens.Color.Surface.Surface_100.Color3,
						onDimiss = props.closeInlineFeedbackPrompt,
						onButtonClick = props.onClickFeedbackPromptButton
					}) or nil
				end)
			}
		)
	end

	return module.createElement(rateCount, {
		rateText = voteTexts.votePercentageText,
		rateLabel = voteTexts.totalVotesText,
		voteState = v7[userVote],
		onVoteDownActivated = props.onVoteDownActivated,
		onVoteUpActivated = props.onVoteUpActivated
	})
end

function extended:didMount()
	self.isMounted = true
end

function extended.didUpdate(p2)
	p2.gameInfoSubscription.update(p2.props.universeId)
end

function extended:willUnmount()
	self.isMounted = false
	self.gameInfoSubscription.dispose()
end

local v8 = module2.connect(function(data, p2)
	local universeId = p2.universeId
	local fetchingStatus = fetchGameVotes.GetFetchingStatus(data, universeId)
	local fetchingStatus2 = fetchUserGameVotes.GetFetchingStatus(data, universeId)
	local patchingStatus = patchUserVotes.GetPatchingStatus(data, universeId)

	local gameVote = data.GameVotes[universeId]

	local userGameVote = data.UserGameVotes[p2.universeId]

	local v9 = if data.GameDetailsV2 and data.GameDetailsV2[p2.universeId] then data.GameDetailsV2 and data.GameDetailsV2[p2.universeId].rootPlaceId else nil

	return {
		gameVotesFetchingStatus = fetchingStatus,
		voteDataIsLoading = fetchingStatus == retrievalStatus.Fetching or fetchingStatus2 == retrievalStatus.Fetching or patchingStatus == retrievalStatus.Fetching,
		voteDataLoadSucceed = gameVote and userGameVote,
		gameVotes = gameVote,
		userGameVotes = userGameVote,
		rootPlaceId = v9
	}
end, function(callback)
	return {
		dispatchFetchGameVotes = function(p2, p3)
			return callback(fetchGameVotes.Fetch(p2, p3))
		end,
		patchUserVotes = function(p2, p3, p4, p5)
			return callback(patchUserVotes.Patch(p2, p3, p4, p5))
		end,
		openFeedbackForm = getFFlagEdpPlayerFeedbackEnabled() and function(p2, p3, onSubmitted)
			return callback(setCentralOverlay(centralOverlayType.GamePlayerFeedbackForm, {
				universeId = p2,
				playerFeedbackMetadata = p3,
				onSubmitted = onSubmitted
			}))
		end or nil,
		getGamePlayerFeedbackMetadata = getFFlagEdpPlayerFeedbackEnabled() and function(p2, p3, p4, p5)
			return callback(getGamePlayerFeedbackMetadata.Get(p2, p3, p5, p4))
		end or nil,
		setCurrentToastMessage = function(p2)
			return callback(setCurrentToastMessage(p2))
		end
	}
end)(extended)

if getFFlagEdpPlayerFeedbackEnabled() then
	v8 = module7.connectUserLayer({ appUserLayers.EDPPlayerFeedbackExposureLayer }, function(p2, p3)
		local v9 = p2[appUserLayers.EDPPlayerFeedbackExposureLayer] or {}
		return {
			enablePlayerFeedback = v9.ShowFeedbackForm,
			showInlineFeedbackPrompt = v9.ShowInlinePrompt
		}
	end, false)(v8)
end

local v9 = roactServices.connect({
	networking = roactNetworking,
	eventIngest = appEventIngestService
})(v8)

return (roactAppPolicy.connect(function(p2)
	return {
		showGlobalCounters = p2.getShowGlobalCounters(),
		showLikesFavoritesCount = p2.getEnableAggregateLikesFavoritesCount()
	}
end)(v9))
