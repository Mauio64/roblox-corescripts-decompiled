local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EventIngestService = game:GetService("EventIngestService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagLuaAppDefaultHttpRetry = require(AppChatParent.SharedFlags).FFlagLuaAppDefaultHttpRetry

require(AppChat.types)

local Constants = require(AppChat.Constants)
local constructGameThumbnailUrl = require(AppChat.Utils.constructGameThumbnailUrl)
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local Signals = require(AppChatParent.Signals)
local EventStream = require(AppChatParent.Analytics).AnalyticsReporters.EventStream
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useMemo = React.useMemo
local useSignalState = require(AppChatParent.SignalsReact).useSignalState
local v20 = require(AppChatParent.Loggers).Logger:new("GameCardContainer")
local withLocalization = require(AppChatParent.Localization).withLocalization
local GameParams = require(AppChatParent.ExperienceService).GameParams
local EventIngest = require(AppChatParent.Analytics).AnalyticsReporters.EventIngest
local ApiFetchGameDetails = require(AppChatParent.GameDetailRodux).GameDetails.ApiFetchGameDetails
local ApiFetchPlayabilityStatus = require(AppChatParent.PlayabilityRodux).PlayabilityStatus.ApiFetchPlayabilityStatus
local ReportAnEvent = require(script.Parent.ReportAnEvent)
local AppSessionService = require(AppChatParent.RoactServiceTags).AppSessionService
local SessionType = require(AppChatParent.RobloxAppSessionization).SessionType
local RoactServices = require(AppChatParent.RoactServices).RoactServices
local RoactAnalyticsCommonGameEvents = require(AppChatParent.RoactServiceTags).RoactAnalyticsCommonGameEvents
local GameCardGroupable = require(script.Parent.GameCardGroupable)
local DataHydration = require(AppChatParent.DataHydration)
local RoundedVariant = require(AppChat.Enums.RoundedVariant)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryEvents = require(script.Parent.Parent.ChatConversationTelemetryEvents)
local AppGame = RoactServices.AppGame
local ExperienceService = require(AppChatParent.ExperienceService).ExperienceService
local SetGamePlaySession = require(AppChatParent.RobloxAppSessionization).SetGamePlaySession
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local HttpRequest = require(AppChatParent.HttpRequest)
local v42 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 66
		-- upvalues: v20 (copy), HttpRequest (copy)
		v20:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("GameCardContainerHttpRetryCount", 4)
})
local EnumScreens = require(AppChat.EnumScreens)
local v44 = game:DefineFastFlag("AppChatShutdownBeforeLaunch", false)
local getFFlagAppChatHidePlayButtonsInExp = require(AppChat.Flags.getFFlagAppChatHidePlayButtonsInExp)
local t1 = {
	placeId = nil,
	universeId = nil,
	conversationId = nil,
	luaChatPlayTogetherEnabled = nil,
	networkImpl = v42,
	eventStream = EventStream.new(RbxAnalyticsService),
	eventIngest = EventIngest.new(EventIngestService),
	onDetailsOpened = function() -- line: 111
	end,
	onPlayButtonActivated = function(p4) -- line: 113
		-- upvalues: SetGamePlaySession (copy), SessionType (copy), ReportAnEvent (copy), Cryo (copy), GameParams (copy), v44 (copy), ExperienceService (copy)
		local placeId = p4.placeId
		local senderUserId = p4.senderUserId

		SetGamePlaySession(p4.sessionService, SessionType.StructuralIdentifier.GamePlayFromChat, true)
		ReportAnEvent(p4, "clickBtnFromLinkCardInChat", "touch")

		if placeId then
			local v56 = GameParams.fromParams({
				userId = senderUserId,
				placeId = placeId
			})

			if v44 then
				game:Shutdown()
			end

			ExperienceService:LaunchExperience(v56, "PlayGameFromLinkCard", function(s1: string?) -- line: 122
				-- upvalues: p4 (ref), Cryo (copy), ReportAnEvent (copy)
				p4 = Cryo.Dictionary.join(p4, {
					joinAttemptId = s1
				})
				ReportAnEvent(p4, "gamePlayIntent", "PlayGameFromLinkCard")
			end)
		end
	end,
	openDetails = function(p5) -- line: 140
		-- upvalues: ReportAnEvent (copy)
		local universeId = p5.universeId
		local placeId = p5.placeId

		ReportAnEvent(p5, "clickLinkCardInChat", "touch")
		p5.onDetailsOpened()
		p5.openGameDetailsPage(universeId, "LuaChatAssetCard")

		local v60 = p5.analytics and p5.analytics.reportOpenGameDetailFromChat

		if v60 then
			v60(placeId, p5.conversationId, universeId, "GameDetailFromLinkCard")
		end
	end
}

local function getGameDetails(p6, p7) -- line: 157
	return p6.GameDetails[p7] or {}
end
local function getGamePlayabilityStatus(p8, p9) -- line: 161
	return p8.PlayabilityStatus[p9] or {}
end

function GameCardContainer(p10) -- line: 165
	-- upvalues: Cryo (copy), t1 (copy), useSelector (copy), useCallback (copy), constructGameThumbnailUrl (copy), Constants (copy), useIsExternalNavigationAvailable (copy), EnumScreens (copy), useDispatch (copy), ApiFetchGameDetails (copy), ApiFetchPlayabilityStatus (copy), DataHydration (copy), Signals (copy), useMemo (copy), useSignalState (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useEffect (copy), ChatConversationTelemetryEvents (copy), RoundedVariant (copy), React (copy), GameCardGroupable (copy), useIsInExperience (copy), getFFlagAppChatHidePlayButtonsInExp (copy), withLocalization (copy)
	local v66 = Cryo.Dictionary.join(t1, p10)

	if not v66.universeId then
		assert("universeId does not exist", "universeId does not exist")
	end

	local v67 = useSelector(useCallback(function(p11) -- line: 171
		-- upvalues: v66 (copy)
		local universeId = v66.universeId

		return p11.GameDetails[universeId] or {}
	end, { v66.universeId }))
	local v68 = useSelector(useCallback(function(p12) -- line: 175
		-- upvalues: v66 (copy)
		local universeId = v66.universeId

		return p12.PlayabilityStatus[universeId] or {}
	end, { v66.universeId }))
	local v69 = constructGameThumbnailUrl(v66.placeId, Constants.GameCard.THUMBNAIL_WIDTH, Constants.GameCard.THUMBNAIL_HEIGHT)
	local v70 = `rbxthumb://type=GameIcon&id={ v66.universeId }&w={ 150 }&h={ 150 }`
	local v71 = useIsExternalNavigationAvailable({ EnumScreens.GameDetail })
	local v72 = v66.placeId or v67.rootPlaceId
	local name = v67.name
	local v74 = v67.description or ""
	local v75 = v67.price or 0
	local v76 = useDispatch()

	local function v77(p13, p14) -- line: 197
		-- upvalues: v76 (copy), ApiFetchGameDetails (copy), ApiFetchPlayabilityStatus (copy)
		v76(ApiFetchGameDetails.Fetch(p13, { p14 }))
		v76(ApiFetchPlayabilityStatus.Fetch(p13, { p14 }))
	end

	local v78 = DataHydration.Game.getVotesStore(false)
	local v79 = Signals.createSignal(nil)
	local v80 = Signals.createSignal("NotReady")
	local v81 = useMemo(function() -- line: 207
		-- upvalues: v66 (copy), v79 (copy), v80 (copy), v78 (copy)
		if not v66.universeId then
			return {
				data = v79,
				status = v80
			}
		end

		return v78.getAndFetchVotes({ v66.universeId })[v66.universeId] or {
			data = v79,
			status = v80
		}
	end, {
		v78,
		v66.universeId
	})
	local v82 = useSignalState(v81.data)
	local v83 = useSignalState(v81.status)
	local v84 = useMemo(function() -- line: 227
		-- upvalues: v82 (copy)
		if v82 and (v82.upVotes and v82.downVotes) then
			local v99 = v82.upVotes + v82.downVotes

			if v99 > 0 then
				return tostring((math.floor(v82.upVotes / v99 * 100))) .. "%"
			end
		end

		return "--"
	end, { v82 })
	local v85 = useTelemetry(ChatConversationTelemetryLayer.Context)

	useEffect(function() -- line: 239
		-- upvalues: v66 (copy), v77 (copy)
		local universeId = v66.universeId

		if not universeId then
			return
		end

		v77(v66.networkImpl, universeId)
	end, {
		v66.universeId,
		v66.networkImpl
	})

	local v86 = useCallback(function() -- line: 249
		-- upvalues: v85 (copy), ChatConversationTelemetryEvents (copy), v66 (copy), v72 (copy)
		v85.emit(ChatConversationTelemetryEvents.GameCardThumbnailClicked, {
			universeId = v66.universeId,
			placeId = v72
		})
		v66.openDetails(v66)
	end, {
		v85,
		v66.openDetails,
		v66.universeId,
		v72
	})
	local v87 = useCallback(function() -- line: 257
		-- upvalues: v85 (copy), ChatConversationTelemetryEvents (copy), v66 (copy), v72 (copy)
		v85.emit(ChatConversationTelemetryEvents.GameCardPlayButtonClicked, {
			universeId = v66.universeId,
			placeId = v72
		})
		v66.onPlayButtonActivated(v66)
	end, {
		v85,
		v66.onPlayButtonActivated,
		v66.universeId,
		v72
	})
	local v88 = useCallback(function() -- line: 265
		-- upvalues: v85 (copy), ChatConversationTelemetryEvents (copy), v66 (copy), v72 (copy)
		v85.emit(ChatConversationTelemetryEvents.GameCardMetadataClicked, {
			universeId = v66.universeId,
			placeId = v72
		})
		v66.openDetails(v66)
	end, {
		v85,
		v66.openDetails,
		v66.universeId,
		v72
	})

	local function renderCard(p15) -- line: 273
		-- upvalues: RoundedVariant (copy), v86 (copy), v87 (copy), v88 (copy), React (copy), GameCardGroupable (copy)
		local v102 = not p15.universeId or (not p15.gameName or (not p15.gameThumbnail or (p15.votesStatus == "NotReady" or not p15.gamePlayerCount)))
		local v103 = false

		if p15.isPlayButtonEnabled and p15.playabilityStatus then
			v103 = p15.playabilityStatus.isPlayable == true
		end

		local v104 = if not p15.isStartOfGroup then if not p15.isIncoming then RoundedVariant.TopLeft else RoundedVariant.TopRight else RoundedVariant.Top
		local v105 = if not p15.openDetails then nil else v86
		local v106 = if not p15.onPlayButtonActivated then nil else v87
		local v107 = if not p15.openDetails then nil else v88

		return React.createElement(GameCardGroupable, {
			thumbnailAspectRatio = 1.7777777777777777,
			gameName = p15.gameName,
			gameDescription = p15.gameDescription,
			gameThumbnail = p15.gameThumbnail,
			gameRating = p15.gameRating,
			gamePlayerCount = p15.gamePlayerCount,
			thumbnailRoundedVariant = v104,
			shouldShowPlayButton = v103,
			onPlayButtonActivated = v106,
			onThumbnailActivated = v105,
			onMetadataActivated = v107,
			isRepliedTo = p15.isRepliedTo,
			isIncoming = p15.isIncoming,
			isPending = p15.isPending,
			isLoading = v102,
			LayoutOrder = p15.layoutOrder
		})
	end

	local v90 = useIsInExperience()
	local v91 = not getFFlagAppChatHidePlayButtonsInExp() or not v90

	return withLocalization({
		purchaseGameText = "Feature.GameDetails.Heading.PurchaseGame",
		viewDetailsText = "Feature.Chat.Action.ViewAssetDetails",
		playText = "Common.VisitGame.Label.Play",
		noDescriptionText = "Feature.Chat.Label.NoDescriptionYet"
	})(function(_) -- line: 324
		-- upvalues: Cryo (copy), v66 (copy), v67 (copy), v68 (copy), v70 (copy), v72 (copy), name (copy), v74 (copy), v75 (copy), v91 (copy), v71 (copy), EnumScreens (copy), v77 (copy), v69 (copy), v84 (copy), v83 (copy), renderCard (copy)
		local v109 = Cryo.Dictionary.join(v66, {
			details = v67,
			playabilityStatus = v68,
			gameIcon = v70,
			placeId = v72,
			gameName = name,
			gameDescription = v74,
			gamePrice = v75,
			isPlayButtonEnabled = v91,
			viewDetailsEnabled = v71[EnumScreens.GameDetail],
			fetchGameData = v77,
			gameThumbnail = v69,
			gameRating = v84,
			gamePlayerCount = v67.playing or 0,
			votesStatus = v83
		})

		return renderCard(v109)
	end)
end

return RoactServices.connect({
	game = AppGame,
	sessionService = AppSessionService,
	analytics = RoactAnalyticsCommonGameEvents
})(memo(GameCardContainer))
