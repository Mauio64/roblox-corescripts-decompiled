local ContextActionService = game:GetService("ContextActionService")
local parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local VotesUtils = Game.VotesUtils

local DiscoveryTypes = require(parent.DiscoveryTypes)
local EnumGameDetailErrorTypes = DiscoveryTypes.EnumGameDetailErrorTypes

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local fireInExperienceDetailsPromptClosedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptClosedEvent

local fireInExperienceDetailsPromptPlayButtonClickedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptPlayButtonClickedEvent
local fireInExperienceDetailsPromptLoadedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptLoadedEvent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local InExperienceDetailsPrompt = require(script.Parent.InExperienceDetailsPrompt)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppIedpOverlayAndNavigationFix = SharedFlags.FFlagLuaAppIedpOverlayAndNavigationFix
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppIedpFixPlayButton = SharedFlags2.FFlagLuaAppIedpFixPlayButton
local v = FFlagLuaAppIedpOverlayAndNavigationFix and "InExperienceDetailsPromptClose" or nil

local function getGameDetailErrorType(p, p2) -- 1 equivalent call inferred from this helper
	if p == DataHydration.DataStatus.Failed then
		return EnumGameDetailErrorTypes.NetworkError
	end

	if p2 and p2.isUnavailable == true then
		return EnumGameDetailErrorTypes.ExperienceUnavailable
	end

	return nil
end

local function InExperienceDetailsPromptContainer(props)
	local gameInfoStore = Game.getGameInfoStore(false)
	local ageRecommendationStore = Game.getAgeRecommendationStore(false)
	local playabilityStore = Game.getPlayabilityStore(false)
	local votesStore = Game.getVotesStore(false)

	local fetchGameInfo = gameInfoStore.getAndFetchGameInfo(props.universeId)
	local fetchAgeRecommendation = ageRecommendationStore.getAndFetchAgeRecommendation(props.universeId)
	local fetchPlayability = playabilityStore.getAndFetchPlayability(props.universeId)
	local fetchVote = votesStore.getAndFetchVote(props.universeId)

	local v2 = SignalsReact.useSignalState(fetchGameInfo.data)
	local ageRecommendation = SignalsReact.useSignalState(fetchAgeRecommendation.data)
	local playability = SignalsReact.useSignalState(fetchPlayability.data)
	local v3 = SignalsReact.useSignalState(fetchVote.data)

	local gameInfoRetrievalStatus = SignalsReact.useSignalState(fetchGameInfo.status)
	local playabilityRetrievalStatus = SignalsReact.useSignalState(fetchPlayability.status)
	local rootPlaceId

	if v2 and v2.rootPlaceId then
		rootPlaceId = tonumber(v2.rootPlaceId)
	else
		rootPlaceId = nil
	end

	local gameDetailErrorType = getGameDetailErrorType(gameInfoRetrievalStatus, v2) -- inferred equivalent call
	local focusRootRef = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isIsolated = true,
		isAutoFocusRoot = true
	})

	local onJoin = React.useCallback(function()
		if props.onJoin then
			props.onJoin(rootPlaceId)
		end

		if rootPlaceId then
			fireInExperienceDetailsPromptClosedEvent({
				targetUniverseId = props.universeId,
				targetRootPlaceId = rootPlaceId,
				closeReason = Enum.PromptExperienceDetailsResult.TeleportAttempted.Name,
				isFullyLoaded = gameInfoRetrievalStatus ~= DataHydration.DataStatus.NotReady and playabilityRetrievalStatus ~= DataHydration.DataStatus.NotReady,
				isPlayable = playability and playability.isPlayable,
				playabilityStatus = playability and playability.playabilityStatus,
				gameInfoErrorType = gameDetailErrorType
			})
		end

		fireInExperienceDetailsPromptPlayButtonClickedEvent({
			targetUniverseId = props.universeId,
			targetRootPlaceId = rootPlaceId,
			playabilityRetrievalStatus = playabilityRetrievalStatus
		})
	end, {
		props.onClose,
		rootPlaceId,
		props.universeId,
		gameInfoRetrievalStatus,
		playabilityRetrievalStatus,
		playability,
		gameDetailErrorType,
		props.onJoin
	})

	local isPlayable = playability and playability.isPlayable
	local playabilityStatus = playability and playability.playabilityStatus

	local onClose = React.useCallback(function()
		props.onClose()
		fireInExperienceDetailsPromptClosedEvent({
			targetUniverseId = props.universeId,
			targetRootPlaceId = rootPlaceId,
			gameInfoErrorType = gameDetailErrorType,
			closeReason = Enum.PromptExperienceDetailsResult.PromptClosed.Name,
			isPlayable = isPlayable,
			playabilityStatus = playabilityStatus,
			isFullyLoaded = gameInfoRetrievalStatus ~= DataHydration.DataStatus.NotReady and playabilityRetrievalStatus ~= DataHydration.DataStatus.NotReady
		})
	end, {
		props.onClose,
		props.universeId,
		rootPlaceId,
		gameDetailErrorType,
		isPlayable,
		playabilityStatus,
		gameInfoRetrievalStatus,
		playabilityRetrievalStatus
	})
	local ref

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		ref = React.useRef(nil)

		React.useEffect(function()
			ContextActionService:BindCoreAction(v, function(p, p2)
				if p == v and p2 == Enum.UserInputState.Begin then
					if ref.current and ref.current.close then
						ref.current.close()
					else
						DiscoveryEventErrorLogger.reportError(
							"InExperienceDetailsPromptCloseError",
							"SheetRef containing close function is not defined",
							{ sheetRef = ref, universeId = props.universeId }
						)
					end
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape, Enum.KeyCode.ButtonStart)

			return function()
				ContextActionService:UnbindCoreAction(v)
			end
		end, { props.universeId })
	else
		ref = nil
	end

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if
			not ref2.current
			and gameInfoRetrievalStatus ~= DataHydration.DataStatus.NotReady
			and playabilityRetrievalStatus ~= DataHydration.DataStatus.NotReady
		then
			fireInExperienceDetailsPromptLoadedEvent({
				targetUniverseId = props.universeId,
				gameInfoRetrievalStatus = gameInfoRetrievalStatus,
				playabilityRetrievalStatus = playabilityRetrievalStatus,
				targetRootPlaceId = rootPlaceId,
				isPlayable = isPlayable,
				playabilityStatus = playabilityStatus,
				gameInfoErrorType = gameDetailErrorType
			})

			ref2.current = true
		end
	end, {
		props.universeId,
		gameInfoRetrievalStatus,
		playabilityRetrievalStatus,
		rootPlaceId,
		isPlayable,
		playabilityStatus,
		gameDetailErrorType
	})

	local createElement = React.createElement
	local v4 = {
		name = v2 and v2.name,
		imageUri = v2 and `rbxthumb://type=GameIcon&id={props.universeId}&w=150&h=150`,
		creator = v2 and v2.creator,
		ageRecommendation = ageRecommendation,
		rating = v3 and VotesUtils.getRatingDisplayText(v3),
		playability = playability,
		errorType = gameDetailErrorType,
		rootPlaceId = 0,
		onJoin = 0,
		onClose = 0,
		focusRootRef = 0,
		sheetRef = 0,
		playabilityRetrievalStatus = 0
	}
	local rootPlaceId2

	if FFlagLuaAppIedpFixPlayButton then
		rootPlaceId2 = rootPlaceId
	end

	v4.rootPlaceId = rootPlaceId2
	v4.onJoin = onJoin
	v4.onClose = onClose
	v4.focusRootRef = focusRootRef
	local sheetRef

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		sheetRef = ref
	end

	v4.sheetRef = sheetRef
	v4.playabilityRetrievalStatus = playabilityRetrievalStatus
	return createElement(InExperienceDetailsPrompt, v4)
end

return InExperienceDetailsPromptContainer
