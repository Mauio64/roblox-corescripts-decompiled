local ContextActionService = game:GetService("ContextActionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SignalsReact")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DiscoveryUtils").DiscoveryEventErrorLogger

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DataHydration")
local Game = DataHydration.Game
local votesUtils = Game.VotesUtils

local enumGameDetailErrorTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DiscoveryTypes").EnumGameDetailErrorTypes

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/DiscoveryAnalytics")
local fireInExperienceDetailsPromptClosedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptClosedEvent

local fireInExperienceDetailsPromptPlayButtonClickedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptPlayButtonClickedEvent
local fireInExperienceDetailsPromptLoadedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptLoadedEvent

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local InExperienceDetailsPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/InExperienceDetailsPrompt/Features/InExperienceDetailsPrompt")
local fFlagLuaAppIedpOverlayAndNavigationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SharedFlags").FFlagLuaAppIedpOverlayAndNavigationFix
local fFlagLuaAppIedpFixPlayButton = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceDetailsPrompt/SharedFlags").FFlagLuaAppIedpFixPlayButton
local v5 = fFlagLuaAppIedpOverlayAndNavigationFix and "InExperienceDetailsPromptClose" or nil

local function getGameDetailErrorType(p2, p3)
	if p2 == DataHydration.DataStatus.Failed then
		return enumGameDetailErrorTypes.NetworkError
	end

	if p3 and p3.isUnavailable == true then
		return enumGameDetailErrorTypes.ExperienceUnavailable
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

	local v6 = SignalsReact.useSignalState(fetchGameInfo.data)
	local v7 = SignalsReact.useSignalState(fetchAgeRecommendation.data)
	local v8 = SignalsReact.useSignalState(fetchPlayability.data)
	local v9 = SignalsReact.useSignalState(fetchVote.data)

	local v10 = SignalsReact.useSignalState(fetchGameInfo.status)
	local v11 = SignalsReact.useSignalState(fetchPlayability.status)

	local rootPlaceId = if v6 and v6.rootPlaceId then tonumber(v6.rootPlaceId) else nil
	local v12

	if v10 == DataHydration.DataStatus.Failed then
		v12 = enumGameDetailErrorTypes.NetworkError
	elseif v6 and v6.isUnavailable == true then
		v12 = enumGameDetailErrorTypes.ExperienceUnavailable
	else
		v12 = nil
	end

	local v13 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.CentralOverlay,
		isIsolated = true,
		isAutoFocusRoot = true
	})

	local v14 = React.useCallback(function()
		if props.onJoin then
			props.onJoin(rootPlaceId)
		end

		if rootPlaceId then
			fireInExperienceDetailsPromptClosedEvent({
				targetUniverseId = props.universeId,
				targetRootPlaceId = rootPlaceId,
				closeReason = Enum.PromptExperienceDetailsResult.TeleportAttempted.Name,
				isFullyLoaded = v10 ~= DataHydration.DataStatus.NotReady and v11 ~= DataHydration.DataStatus.NotReady,
				isPlayable = v8 and v8.isPlayable,
				playabilityStatus = v8 and v8.playabilityStatus,
				gameInfoErrorType = v12
			})
		end

		fireInExperienceDetailsPromptPlayButtonClickedEvent({
			targetUniverseId = props.universeId,
			targetRootPlaceId = rootPlaceId,
			playabilityRetrievalStatus = v11
		})
	end, {
		props.onClose,
		rootPlaceId,
		props.universeId,
		v10,
		v11,
		v8,
		v12,
		props.onJoin
	})

	local isPlayable = v8 and v8.isPlayable
	local playabilityStatus = v8 and v8.playabilityStatus

	local v15 = React.useCallback(function()
		props.onClose()
		fireInExperienceDetailsPromptClosedEvent({
			targetUniverseId = props.universeId,
			targetRootPlaceId = rootPlaceId,
			gameInfoErrorType = v12,
			closeReason = Enum.PromptExperienceDetailsResult.PromptClosed.Name,
			isPlayable = isPlayable,
			playabilityStatus = playabilityStatus,
			isFullyLoaded = v10 ~= DataHydration.DataStatus.NotReady and v11 ~= DataHydration.DataStatus.NotReady
		})
	end, {
		props.onClose,
		props.universeId,
		rootPlaceId,
		v12,
		isPlayable,
		playabilityStatus,
		v10,
		v11
	})
	local ref

	if fFlagLuaAppIedpOverlayAndNavigationFix then
		ref = React.useRef(nil)

		React.useEffect(function()
			ContextActionService:BindCoreAction(v5, function(p2, p3)
				if p2 == v5 and p3 == Enum.UserInputState.Begin then
					if ref.current and ref.current.close then
						ref.current.close()
					else
						discoveryEventErrorLogger.reportError(
							"InExperienceDetailsPromptCloseError",
							"SheetRef containing close function is not defined",
							{ sheetRef = ref, universeId = props.universeId }
						)
					end
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape, Enum.KeyCode.ButtonStart)

			return function()
				ContextActionService:UnbindCoreAction(v5)
			end
		end, { props.universeId })
	else
		ref = nil
	end

	local ref2 = React.useRef(false)
	React.useEffect(function()
		if
			not ref2.current
			and v10 ~= DataHydration.DataStatus.NotReady
			and v11 ~= DataHydration.DataStatus.NotReady
		then
			fireInExperienceDetailsPromptLoadedEvent({
				targetUniverseId = props.universeId,
				gameInfoRetrievalStatus = v10,
				playabilityRetrievalStatus = v11,
				targetRootPlaceId = rootPlaceId,
				isPlayable = isPlayable,
				playabilityStatus = playabilityStatus,
				gameInfoErrorType = v12
			})

			ref2.current = true
		end
	end, { props.universeId, v10, v11, rootPlaceId, isPlayable, playabilityStatus, v12 })

	return React.createElement(InExperienceDetailsPrompt, {
		name = v6 and v6.name,
		imageUri = v6 and `rbxthumb://type=GameIcon&id={props.universeId}&w=150&h=150`,
		creator = v6 and v6.creator,
		ageRecommendation = v7,
		rating = v9 and votesUtils.getRatingDisplayText(v9),
		playability = v8,
		errorType = v12,
		rootPlaceId = if fFlagLuaAppIedpFixPlayButton then rootPlaceId else nil,
		onJoin = v14,
		onClose = v15,
		focusRootRef = v13,
		sheetRef = if fFlagLuaAppIedpOverlayAndNavigationFix then ref else nil,
		playabilityRetrievalStatus = v11
	})
end

return InExperienceDetailsPromptContainer
