local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EventIngestService = game:GetService("EventIngestService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
require(AppChat.types)

local Constants = require(AppChat.Constants)
local constructGameThumbnailUrl = require(AppChat.Utils.constructGameThumbnailUrl)

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local Analytics = require(parent.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local useMemo = React.useMemo
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local v = Logger.new(Logger, "GameCardContainer")

local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local ExperienceService = require(parent.ExperienceService)
local GameParams = ExperienceService.GameParams
local Analytics2 = require(parent.Analytics)
local EventIngest = Analytics2.AnalyticsReporters.EventIngest

local GameDetailRodux = require(parent.GameDetailRodux)
local ApiFetchGameDetails = GameDetailRodux.GameDetails.ApiFetchGameDetails
local PlayabilityRodux = require(parent.PlayabilityRodux)
local ApiFetchPlayabilityStatus = PlayabilityRodux.PlayabilityStatus.ApiFetchPlayabilityStatus
local ReportAnEvent = require(script.Parent.ReportAnEvent)

local RoactServiceTags = require(parent.RoactServiceTags)
local AppSessionService = RoactServiceTags.AppSessionService
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local RoactServiceTags2 = require(parent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags2.RoactAnalyticsCommonGameEvents

local GameCardGroupable = require(script.Parent.GameCardGroupable)
local GameAssetCard = require(script.Parent.GameAssetCard)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)
local DataHydration = require(parent.DataHydration)
local RoundedVariant = require(AppChat.Enums.RoundedVariant)

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ChatConversationTelemetryEvents = require(script.Parent.Parent.Parent.ChatConversationTelemetryEvents)

local AppGame = roactServices.AppGame
local ExperienceService2 = require(parent.ExperienceService)
local experienceService = ExperienceService2.ExperienceService

local RobloxAppSessionization2 = require(parent.RobloxAppSessionization)
local SetGamePlaySession = RobloxAppSessionization2.SetGamePlaySession

local HttpRequest = require(parent.HttpRequest)
local config = HttpRequest.config
local v2 = {
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("GameCardContainerHttpRetryCount", 4)
end

v2.maxRetryCount = maxRetryCount
local networkImpl2 = config(v2)

local EnumScreens = require(AppChat.EnumScreens)
local defineFastFlag = game:DefineFastFlag("AppChatShutdownBeforeLaunch", false)
local FFlagAppChatEarlyTestingLinks = require(AppChat.Flags.FFlagAppChatEarlyTestingLinks)

local v3 = {
	networkImpl = networkImpl2,
	eventStream = EventStream.new(RbxAnalyticsService),
	eventIngest = EventIngest.new(EventIngestService),
	placeId = nil,
	universeId = nil,
	conversationId = nil,
	luaChatPlayTogetherEnabled = nil,
	onDetailsOpened = function() end,
	onPlayButtonActivated = function(data)
		local placeId = data.placeId
		local senderUserId = data.senderUserId

		SetGamePlaySession(data.sessionService, SessionType.StructuralIdentifier.GamePlayFromChat, true)

		ReportAnEvent(data, "clickBtnFromLinkCardInChat", "touch")

		if placeId then
			local function fn(joinAttemptId: string?)
				data = Cryo.Dictionary.join(data, { joinAttemptId = joinAttemptId })

				ReportAnEvent(data, "gamePlayIntent", "PlayGameFromLinkCard")
			end

			local v3

			if FFlagAppChatEarlyTestingLinks and data.isEarlyTesting then
				v3 = GameParams.fromParams({ placeId = placeId, isEarlyTesting = true })
			else
				v3 = GameParams.fromParams({ userId = senderUserId, placeId = placeId })
			end

			if defineFastFlag then
				game:Shutdown()
			end

			experienceService:LaunchExperience(v3, "PlayGameFromLinkCard", fn)
		end
	end,
	openDetails = function(data)
		local universeId = data.universeId
		local placeId = data.placeId

		ReportAnEvent(data, "clickLinkCardInChat", "touch")
		data.onDetailsOpened()

		data.openGameDetailsPage(universeId, "LuaChatAssetCard")

		local reportOpenGameDetailFromChat = data.analytics and data.analytics.reportOpenGameDetailFromChat

		if reportOpenGameDetailFromChat then
			reportOpenGameDetailFromChat(placeId, data.conversationId, universeId, "GameDetailFromLinkCard")
		end
	end
}

local function getGameDetails(p, universeId) -- 1 equivalent call inferred from this helper
	return p.GameDetails[universeId] or {}
end

local function getGamePlayabilityStatus(p, universeId) -- 1 equivalent call inferred from this helper
	return p.PlayabilityStatus[universeId] or {}
end

function GameCardContainer(p)
	local joined = Cryo.Dictionary.join(v3, p)

	if not joined.universeId then
		assert("universeId does not exist", "universeId does not exist")
	end

	local details = useSelector(useCallback(function(p2)
		return getGameDetails(p2, joined.universeId) -- inferred equivalent call
	end, { joined.universeId }))

	local playabilityStatus = useSelector(useCallback(function(p2)
		return getGamePlayabilityStatus(p2, joined.universeId) -- inferred equivalent call
	end, { joined.universeId }))

	local gameThumbnail = constructGameThumbnailUrl(
		joined.placeId,
		Constants.GameCard.THUMBNAIL_WIDTH,
		Constants.GameCard.THUMBNAIL_HEIGHT
	)

	local formatted = `rbxthumb://type=GameIcon&id={joined.universeId}&w={150}&h={150}`

	local v4 = useIsExternalNavigationAvailable({ EnumScreens.GameDetail })

	local placeId = joined.placeId or details.rootPlaceId
	local name = details.name
	local description = details.description or ""
	local price = details.price or 0

	local v5 = useDispatch()
	local function fn(networkImpl, universeId)
		v5(ApiFetchGameDetails.Fetch(networkImpl, { universeId }))
		v5(ApiFetchPlayabilityStatus.Fetch(networkImpl, { universeId }))
	end

	local votesStore = DataHydration.Game.getVotesStore(false)

	local signal = Signals.createSignal(nil)
	local signal2 = Signals.createSignal("NotReady")

	local v6 = useMemo(function()
		if joined.universeId then
			return votesStore.getAndFetchVotes({ joined.universeId })[joined.universeId]
				or { data = signal, status = signal2 }
		end

		return { data = signal, status = signal2 }
	end, { votesStore, joined.universeId })

	local v7 = useSignalState(v6.data)
	local votesStatus = useSignalState(v6.status)

	local gameRating = useMemo(function()
		if v7 and v7.upVotes and v7.downVotes then
			local v8 = v7.upVotes + v7.downVotes

			if v8 > 0 then
				return tostring((math.floor(v7.upVotes / v8 * 100))) .. "%"
			end
		end

		return "--"
	end, { v7 })

	local v8 = useTelemetry(ChatConversationTelemetryLayer.Context)

	useEffect(function()
		local universeId = joined.universeId

		if not universeId then
			return
		end

		fn(joined.networkImpl, universeId)
	end, { joined.universeId, joined.networkImpl })

	local v9 = useCallback(function()
		v8.emit(ChatConversationTelemetryEvents.GameCardThumbnailClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.openDetails(joined)
	end, { v8, joined.openDetails, joined.universeId, placeId })

	local v10 = useCallback(function()
		v8.emit(ChatConversationTelemetryEvents.GameCardPlayButtonClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.onPlayButtonActivated(joined)
	end, { v8, joined.onPlayButtonActivated, joined.universeId, placeId, joined.isEarlyTesting })

	local v11 = useCallback(function()
		v8.emit(ChatConversationTelemetryEvents.GameCardMetadataClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.openDetails(joined)
	end, { v8, joined.openDetails, joined.universeId, placeId })

	local function renderCard(props)
		local isLoading = not (props.universeId and props.gameName)
			or not props.gameThumbnail
			or props.votesStatus == "NotReady"
			or not props.gamePlayerCount
		local onThumbnailActivated

		if props.openDetails then
			onThumbnailActivated = v9
		end

		local onPlayButtonActivated

		if props.onPlayButtonActivated then
			onPlayButtonActivated = v10
		end

		local onMetadataActivated

		if props.openDetails then
			onMetadataActivated = v11
		end

		if props.groupShape then
			return React.createElement(GameAssetCard, {
				gameName = props.gameName,
				gameThumbnail = props.gameThumbnail,
				gameRating = props.gameRating,
				gamePlayerCount = props.gamePlayerCount,
				isLoading = isLoading,
				onPlayButtonActivated = onPlayButtonActivated,
				playButtonLabel = props.playButtonLabel,
				onThumbnailActivated = onThumbnailActivated,
				onMetadataActivated = onMetadataActivated,
				groupShape = props.groupShape,
				mediaRef = props.mediaRef,
				LayoutOrder = props.layoutOrder
			})
		end

		local v12

		if props.isPlayButtonEnabled and props.playabilityStatus then
			v12 = props.playabilityStatus.isPlayable == true
		else
			v12 = false
		end

		local shouldShowPlayButton = FFlagAppChatEarlyTestingLinks
			and props.isPlayButtonEnabled
			and props.isEarlyTesting
			and true
			or v12
		local thumbnailRoundedVariant

		if props.isStartOfGroup then
			thumbnailRoundedVariant = RoundedVariant.Top
		elseif props.isIncoming then
			thumbnailRoundedVariant = RoundedVariant.TopRight
		else
			thumbnailRoundedVariant = RoundedVariant.TopLeft
		end

		return React.createElement(GameCardGroupable, {
			gameName = props.gameName,
			gameDescription = props.gameDescription,
			gameThumbnail = props.gameThumbnail,
			gameRating = props.gameRating,
			gamePlayerCount = props.gamePlayerCount,
			thumbnailAspectRatio = 16 / 9,
			thumbnailRoundedVariant = thumbnailRoundedVariant,
			shouldShowPlayButton = shouldShowPlayButton,
			onPlayButtonActivated = onPlayButtonActivated,
			playButtonLabel = props.playButtonLabel,
			onThumbnailActivated = onThumbnailActivated,
			onMetadataActivated = onMetadataActivated,
			isRepliedTo = props.isRepliedTo,
			isIncoming = props.isIncoming,
			isPending = props.isPending,
			isLoading = isLoading,
			LayoutOrder = props.layoutOrder
		})
	end

	return withLocalization({
		purchaseGameText = "Feature.GameDetails.Heading.PurchaseGame",
		viewDetailsText = "Feature.Chat.Action.ViewAssetDetails",
		playText = "Common.VisitGame.Label.Play",
		noDescriptionText = "Feature.Chat.Label.NoDescriptionYet",
		previewText = "Feature.ExperienceDetails.PlayButtonText.Playtest"
	})(function(p2)
		local join = Cryo.Dictionary.join
		local v12 = {
			details = details,
			playabilityStatus = playabilityStatus,
			gameIcon = formatted,
			placeId = placeId,
			gameName = name,
			gameDescription = description,
			gamePrice = price,
			isPlayButtonEnabled = true,
			viewDetailsEnabled = v4[EnumScreens.GameDetail],
			fetchGameData = fn,
			gameThumbnail = gameThumbnail,
			gameRating = gameRating,
			gamePlayerCount = details.playing or 0,
			votesStatus = votesStatus,
			playButtonLabel = 0
		}
		local playButtonLabel

		if FFlagAppChatEarlyTestingLinks and joined.isEarlyTesting then
			playButtonLabel = p2.previewText
		end

		v12.playButtonLabel = playButtonLabel
		return renderCard(join(joined, v12))
	end)
end

return roactServices.connect({
	game = AppGame,
	sessionService = AppSessionService,
	analytics = RoactAnalyticsCommonGameEvents
})(memo(GameCardContainer))
