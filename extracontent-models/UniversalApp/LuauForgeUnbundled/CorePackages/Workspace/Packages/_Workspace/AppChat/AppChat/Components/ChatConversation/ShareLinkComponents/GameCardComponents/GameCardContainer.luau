local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EventIngestService = game:GetService("EventIngestService")

local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppDefaultHttpRetry
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local constructGameThumbnailUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/constructGameThumbnailUrl")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").AnalyticsReporters.EventStream
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsExternalNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsExternalNavigationAvailable")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useMemo = React.useMemo
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger
local v5 = logger.new(logger, "GameCardContainer")

local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").withLocalization
local gameParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ExperienceService").GameParams
local eventIngest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Analytics").AnalyticsReporters.EventIngest

local apiFetchGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/GameDetailRodux").GameDetails.ApiFetchGameDetails
local apiFetchPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlayabilityRodux").PlayabilityStatus.ApiFetchPlayabilityStatus
local ReportAnEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/ReportAnEvent")

local appSessionService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServiceTags").AppSessionService
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppSessionization").SessionType
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServices").RoactServices
local roactAnalyticsCommonGameEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactServiceTags").RoactAnalyticsCommonGameEvents

local GameCardGroupable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardGroupable")
local GameAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameAssetCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local RoundedVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Enums/RoundedVariant")

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")

local appGame = roactServices.AppGame
local experienceService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ExperienceService").ExperienceService

local setGamePlaySession = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppSessionization").SetGamePlaySession

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpRequest")
local config = HttpRequest.config
local v6 = {
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("GameCardContainerHttpRetryCount", 4) else nil
v6.maxRetryCount = v7
local v8 = config(v6)

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local defineFastFlag = game:DefineFastFlag("AppChatShutdownBeforeLaunch", false)
local FFlagAppChatEarlyTestingLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEarlyTestingLinks")

local v9 = {
	networkImpl = v8,
	eventStream = eventStream.new(RbxAnalyticsService),
	eventIngest = eventIngest.new(EventIngestService),
	placeId = nil,
	universeId = nil,
	conversationId = nil,
	luaChatPlayTogetherEnabled = nil,
	onDetailsOpened = function() end,
	onPlayButtonActivated = function(data)
		local placeId = data.placeId
		local senderUserId = data.senderUserId

		setGamePlaySession(data.sessionService, sessionType.StructuralIdentifier.GamePlayFromChat, true)

		ReportAnEvent(data, "clickBtnFromLinkCardInChat", "touch")

		if placeId then
			local function fn(p2)
				data = Cryo.Dictionary.join(data, { joinAttemptId = p2 })

				ReportAnEvent(data, "gamePlayIntent", "PlayGameFromLinkCard")
			end

			local v10

			if FFlagAppChatEarlyTestingLinks and data.isEarlyTesting then
				v10 = gameParams.fromParams({ placeId = placeId, isEarlyTesting = true })
			else
				v10 = gameParams.fromParams({ userId = senderUserId, placeId = placeId })
			end

			if defineFastFlag then
				game:Shutdown()
			end

			experienceService:LaunchExperience(v10, "PlayGameFromLinkCard", fn)
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

local function getGameDetails(p2, p3)
	return p2.GameDetails[p3] or {}
end

local function getGamePlayabilityStatus(p2, p3)
	return p2.PlayabilityStatus[p3] or {}
end

function LUAUFORGE_MODULE_GLOBALS_hwu_GameCardContainer(p2)
	local joined = Cryo.Dictionary.join(v9, p2)

	if not joined.universeId then
		assert("universeId does not exist", "universeId does not exist")
	end

	local v10 = useSelector(useCallback(function(p3)
		local universeId = joined.universeId
		return p3.GameDetails[universeId] or {}
	end, { joined.universeId }))

	local v11 = useSelector(useCallback(function(p3)
		local universeId = joined.universeId
		return p3.PlayabilityStatus[universeId] or {}
	end, { joined.universeId }))

	local v12 = constructGameThumbnailUrl(joined.placeId, Constants.GameCard.THUMBNAIL_WIDTH, Constants.GameCard.THUMBNAIL_HEIGHT)

	local formatted = `rbxthumb://type=GameIcon&id={joined.universeId}&w={150}&h={150}`

	local v13 = useIsExternalNavigationAvailable({ EnumScreens.GameDetail })

	local placeId = joined.placeId or v10.rootPlaceId
	local name = v10.name
	local description = v10.description or ""
	local price = v10.price or 0

	local v14 = useDispatch()
	local function fn(networkImpl, universeId)
		v14(apiFetchGameDetails.Fetch(networkImpl, { universeId }))
		v14(apiFetchPlayabilityStatus.Fetch(networkImpl, { universeId }))
	end

	local votesStore = DataHydration.Game.getVotesStore(false)

	local signal = Signals.createSignal(nil)
	local signal2 = Signals.createSignal("NotReady")

	local v15 = useMemo(function()
		if joined.universeId then
			return votesStore.getAndFetchVotes({ joined.universeId })[joined.universeId]
				or { data = signal, status = signal2 }
		end

		return { data = signal, status = signal2 }
	end, { votesStore, joined.universeId })

	local v16 = useSignalState(v15.data)
	local v17 = useSignalState(v15.status)

	local v18 = useMemo(function()
		if v16 and v16.upVotes and v16.downVotes then
			local v19 = v16.upVotes + v16.downVotes

			if v19 > 0 then
				return tostring((math.floor(v16.upVotes / v19 * 100))) .. "%"
			end
		end

		return "--"
	end, { v16 })

	local v19 = useTelemetry(ChatDetailsTelemetryLayer.Context)

	useEffect(function()
		local universeId = joined.universeId

		if not universeId then
			return
		end

		fn(joined.networkImpl, universeId)
	end, { joined.universeId, joined.networkImpl })

	local v20 = useCallback(function()
		v19.emit(ChatConversationTelemetryEvents.GameCardThumbnailClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.openDetails(joined)
	end, { v19, joined.openDetails, joined.universeId, placeId })

	local v21 = useCallback(function()
		v19.emit(ChatConversationTelemetryEvents.GameCardPlayButtonClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.onPlayButtonActivated(joined)
	end, {
		v19,
		joined.onPlayButtonActivated,
		joined.universeId,
		placeId,
		joined.isEarlyTesting
	})

	local v22 = useCallback(function()
		v19.emit(ChatConversationTelemetryEvents.GameCardMetadataClicked, {
			universeId = joined.universeId,
			placeId = placeId
		})

		joined.openDetails(joined)
	end, { v19, joined.openDetails, joined.universeId, placeId })

	local function renderCard(props)
		local v23 = not (props.universeId and props.gameName)
			or not props.gameThumbnail
			or props.votesStatus == "NotReady"
			or not props.gamePlayerCount

		local v24 = if props.openDetails then v20 else nil
		local v25 = if props.onPlayButtonActivated then v21 else nil
		local v26 = if props.openDetails then v22 else nil

		if props.groupShape then
			return React.createElement(GameAssetCard, {
				gameName = props.gameName,
				gameThumbnail = props.gameThumbnail,
				gameRating = props.gameRating,
				gamePlayerCount = props.gamePlayerCount,
				isLoading = v23,
				onPlayButtonActivated = v25,
				playButtonLabel = props.playButtonLabel,
				onThumbnailActivated = v24,
				onMetadataActivated = v26,
				groupShape = props.groupShape,
				mediaRef = props.mediaRef,
				LayoutOrder = props.layoutOrder
			})
		end

		local v27 = if props.isPlayButtonEnabled and props.playabilityStatus then props.playabilityStatus.isPlayable == true else false

		local v28 = FFlagAppChatEarlyTestingLinks and props.isPlayButtonEnabled and props.isEarlyTesting and true or v27
		local v29

		if props.isStartOfGroup then
			v29 = RoundedVariant.Top
		else
			v29 = if props.isIncoming then RoundedVariant.TopRight else RoundedVariant.TopLeft
		end

		return React.createElement(GameCardGroupable, {
			gameName = props.gameName,
			gameDescription = props.gameDescription,
			gameThumbnail = props.gameThumbnail,
			gameRating = props.gameRating,
			gamePlayerCount = props.gamePlayerCount,
			thumbnailAspectRatio = 16 / 9,
			thumbnailRoundedVariant = v29,
			shouldShowPlayButton = v28,
			onPlayButtonActivated = v25,
			playButtonLabel = props.playButtonLabel,
			onThumbnailActivated = v24,
			onMetadataActivated = v26,
			isRepliedTo = props.isRepliedTo,
			isIncoming = props.isIncoming,
			isPending = props.isPending,
			isLoading = v23,
			LayoutOrder = props.layoutOrder
		})
	end

	return withLocalization({
		purchaseGameText = "Feature.GameDetails.Heading.PurchaseGame",
		viewDetailsText = "Feature.Chat.Action.ViewAssetDetails",
		playText = "Common.VisitGame.Label.Play",
		noDescriptionText = "Feature.Chat.Label.NoDescriptionYet",
		previewText = "Feature.ExperienceDetails.PlayButtonText.Playtest"
	})(function(p3)
		local join = Cryo.Dictionary.join
		local v24 = {
			details = v10,
			playabilityStatus = v11,
			gameIcon = formatted,
			placeId = placeId,
			gameName = name,
			gameDescription = description,
			gamePrice = price,
			isPlayButtonEnabled = true,
			viewDetailsEnabled = v13[EnumScreens.GameDetail],
			fetchGameData = fn,
			gameThumbnail = v12,
			gameRating = v18,
			gamePlayerCount = v10.playing or 0,
			votesStatus = v17,
			playButtonLabel = 0
		}

		local v25 = if FFlagAppChatEarlyTestingLinks and joined.isEarlyTesting then p3.previewText else nil
		v24.playButtonLabel = v25
		return renderCard(join(joined, v24))
	end)
end

return roactServices.connect({
	game = appGame,
	sessionService = appSessionService,
	analytics = roactAnalyticsCommonGameEvents
})(memo(LUAUFORGE_MODULE_GLOBALS_hwu_GameCardContainer))
