local LocalizationService = game:GetService("LocalizationService")

local IXPService = game:GetService("IXPService")

local module = require("@luauforge/bundled/drf")
local none = module.None
local module2 = require("@luauforge/bundled/drg")
local module3 = require("@luauforge/bundled/drj")
local module4 = require("@luauforge/bundled/drd")

local voteStates = module4.App.Indicator.Enum.VoteStates
local rateCount = module4.App.Indicator.RateCount
local withStyle = module4.Core.Style.withStyle
local roactServices = require("@luauforge/bundled/drh").RoactServices
local roactNetworking = require("@luauforge/bundled/drk").RoactNetworking
local appEventIngestService = require("@luauforge/bundled/drk").AppEventIngestService
local roactAppPolicy = require("@luauforge/bundled/drN").RoactAppPolicy
local memoize = require("@luauforge/bundled/dqY").memoize
local localization = require("@luauforge/bundled/drO").Localization
local abbreviateCount = require("@luauforge/bundled/drP").abbreviateCount
local module5 = require("@luauforge/bundled/drQ")
local fetchGameVotes = module5.GameVotes.FetchGameVotes
local fetchUserGameVotes = module5.UserGameVotes.FetchUserGameVotes
local patchUserVotes = module5.UserGameVotes.PatchUserVotes
local reasonForNotVoteable = module5.Enums.ReasonForNotVoteable
local voteStatus = module5.Enums.VoteStatus
local retrievalStatus = require("@luauforge/bundled/drq").Enum.RetrievalStatus
local toastType = require("@luauforge/bundled/drR").Enums.ToastType
local setCurrentToastMessage = require("@luauforge/bundled/drR").Actions.SetCurrentToastMessage
local gameInfosReducer = require("@luauforge/bundled/dqm").GameInfosReducer
local module6 = require("@luauforge/bundled/drS")
local module7 = require("@luauforge/bundled/drT")
local appUserLayers = require("@luauforge/bundled/drU").AppUserLayers
local gamePlayerFeedbackPrompt = require("@luauforge/bundled/drV").GamePlayerFeedbackPrompt
local getGamePlayerFeedbackMetadata = require("@luauforge/bundled/drV").Thunks.GetGamePlayerFeedbackMetadata
local setCentralOverlay = require("@luauforge/bundled/drW").Actions.SetCentralOverlay
local centralOverlayType = require("@luauforge/bundled/drn").CentralOverlayType
local logging = require("@luauforge/bundled/dqY").Logging

local vote = require("@luauforge/bundled/dqX").Vote

local getFFlagEdpPlayerFeedbackEnabled = require("@luauforge/bundled/dqB").GetFFlagEdpPlayerFeedbackEnabled
local getFFlagEdpPlayerFeedbackLogIXPExposure = require("@luauforge/bundled/dqB").GetFFlagEdpPlayerFeedbackLogIXPExposure

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@luauforge/bundled/dqB").FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@luauforge/bundled/dqB").FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local fFlagLuaAppGameStatsFallbackRendering = require("@luauforge/bundled/dqB").FFlagLuaAppGameStatsFallbackRendering
local fFlagMigrateGameInfoToStore = require("@luauforge/bundled/dqB").FFlagMigrateGameInfoToStore

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@luauforge/bundled/dqB").FFlagLuaAppAddUniverseIdToEngagementEvents

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
			local rootPlaceId

			if fFlagMigrateGameInfoToStore then
				rootPlaceId = self.props.rootPlaceId
					or self.state.gameInfo and self.state.gameInfo.rootPlaceId
			else
				rootPlaceId = self.props.rootPlaceId
			end

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

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription = module6.subscribeGameInfo({
			universeId = self.props.universeId,
			onChange = function(p2)
				self:setState({
					gameInfo = p2.gameInfo or none,
					storeVotes = p2.votes or none
				})
			end
		})
	end

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
		local rootPlaceId

		if fFlagMigrateGameInfoToStore then
			rootPlaceId = self.props.rootPlaceId or self.state.gameInfo and self.state.gameInfo.rootPlaceId
		else
			rootPlaceId = self.props.rootPlaceId
		end

		if self.props.voteDataIsLoading or not (self.isMounted and rootPlaceId) then
			return
		end

		local v10

		if fFlagMigrateGameInfoToStore then
			v10 = (if fFlagLuaAppGameStatsFallbackRendering then self.props.gameVotes or self.state.storeVotes else self.props.gameVotes)
				and self.props.userGameVotes
		else
			v10 = self.props.voteDataLoadSucceed
		end

		if v10 then
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

				local v13 = p2

				if not fFlagLuaAppAddUniverseIdToEngagementEvents then
					universeId = nil
				end

				vote(eventIngest, "GameRatings", rootPlaceId, v13, userVote, universeId)
			else
				local v11 = v9[reasonForNotVoteable2] or v9.Default
				self.props.setCurrentToastMessage({
					toastType = toastType.NetworkingError,
					toastMessage = v11
				})
			end
		elseif self.props.gameVotesFetchingStatus == retrievalStatus.Failed then
			self.props.dispatchFetchGameVotes(networking, universeId)
		else
			local eventIngest = self.props.eventIngest

			if getFFlagEdpPlayerFeedbackEnabled() then
				local patchUserVotes2 = self.props.patchUserVotes
				local v11 = p2
				patchUserVotes2(networking, universeId, v11, voteStatus.NotVoted):andThen(function(p3)
					if p3 ~= nil then
						self.onVoteSuccess(p2)
					end
				end)
			else
				local patchUserVotes2 = self.props.patchUserVotes
				local v11 = p2
				patchUserVotes2(networking, universeId, v11, voteStatus.NotVoted)
			end

			local v13 = p2
			local notVoted = voteStatus.NotVoted

			if not fFlagLuaAppAddUniverseIdToEngagementEvents then
				universeId = nil
			end

			vote(eventIngest, "GameRatings", rootPlaceId, v13, notVoted, universeId)
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
	local gameVotes

	if fFlagMigrateGameInfoToStore then
		if fFlagLuaAppGameStatsFallbackRendering then
			gameVotes = props.props.gameVotes or props.state.storeVotes
		else
			gameVotes = props.props.gameVotes
		end
	else
		gameVotes = props.props.gameVotes
	end

	local userGameVotes = props.props.userGameVotes
	local gameVotesFetchingStatus = props.props.gameVotesFetchingStatus
	local v8

	if fFlagMigrateGameInfoToStore then
		v8 = gameVotes and props.props.userGameVotes
	else
		v8 = props.props.voteDataLoadSucceed
	end

	local v9 = gameVotes and gameVotes.upVotes
	local v10 = gameVotes and gameVotes.downVotes

	if gameVotesFetchingStatus == retrievalStatus.Done then
		v9 = v9 or 0
		v10 = v10 or 0
	end

	local userVote = v8 and userGameVotes and userGameVotes.userVote or voteStatus.NotVoted
	local showGlobalCounters = props.props.showGlobalCounters
	local showLikesFavoritesCount = props.props.showLikesFavoritesCount
	local voteTexts = props.getVoteTexts(v9, v10, showGlobalCounters, showLikesFavoritesCount)

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
					local createElement = module.createElement

					local v13 = if fFlagMigrateGameInfoToStore then props.props.rootPlaceId or props.state.gameInfo and props.state.gameInfo.rootPlaceId else props.props.rootPlaceId
					return createElement(gamePlayerFeedbackPrompt, {
						placeId = v13,
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
	if fFlagMigrateGameInfoToStore then
		p2.gameInfoSubscription.update(p2.props.universeId)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if fFlagMigrateGameInfoToStore then
		self.gameInfoSubscription.dispose()
	end
end

local function getGameVotesWithFallback(p2, p3)
	local gameVote = p2.GameVotes[p3]

	if gameVote then
		return gameVote
	end

	local v8 = fFlagLuaAppGameStatsFallbackRendering and p2.Personalization[gameInfosReducer.key][p3]

	if v8 then
		return {
			upVotes = v8.totalUpVotes or 0,
			downVotes = v8.totalDownVotes or 0
		}
	end

	return nil
end

local v8 = module2.connect(function(data, p2)
	local universeId = p2.universeId
	local fetchingStatus = fetchGameVotes.GetFetchingStatus(data, universeId)
	local fetchingStatus2 = fetchUserGameVotes.GetFetchingStatus(data, universeId)
	local patchingStatus = patchUserVotes.GetPatchingStatus(data, universeId)
	local v9

	if fFlagMigrateGameInfoToStore then
		v9 = data.GameVotes[universeId]
	else
		v9 = data.GameVotes[universeId]

		if not v9 then
			if fFlagLuaAppGameStatsFallbackRendering then
				local v10 = data.Personalization[gameInfosReducer.key][universeId]

				v9 = v10 and {
					upVotes = v10.totalUpVotes or 0,
					downVotes = v10.totalDownVotes or 0
				} or nil
			else
				v9 = nil
			end
		end
	end

	local userGameVote = data.UserGameVotes[p2.universeId]

	local v10 = nil

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p2.shouldHydrateLegacyIxp
	then
		if data.GameDetailsV2 and data.GameDetailsV2[p2.universeId] then
			v10 = data.GameDetailsV2 and data.GameDetailsV2[p2.universeId].rootPlaceId
		elseif not fFlagMigrateGameInfoToStore then
			local v11 = data.Personalization[gameInfosReducer.key][p2.universeId]

			if v11 then
				v10 = v11.placeId
			end
		end
	elseif data.GameDetails and data.GameDetails[p2.universeId] then
		v10 = data.GameDetails and data.GameDetails[p2.universeId].rootPlaceId
	elseif not fFlagMigrateGameInfoToStore then
		local v11 = data.Personalization[gameInfosReducer.key][p2.universeId]

		if v11 then
			v10 = v11.placeId
		end
	end

	return {
		gameVotesFetchingStatus = fetchingStatus,
		voteDataIsLoading = fetchingStatus == retrievalStatus.Fetching or fetchingStatus2 == retrievalStatus.Fetching or patchingStatus == retrievalStatus.Fetching,
		voteDataLoadSucceed = v9 and userGameVote,
		gameVotes = v9,
		userGameVotes = userGameVote,
		rootPlaceId = v10
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
