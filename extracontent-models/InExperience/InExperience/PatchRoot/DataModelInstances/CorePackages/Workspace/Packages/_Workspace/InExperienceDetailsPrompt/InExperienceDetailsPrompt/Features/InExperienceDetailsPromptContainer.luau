local TeleportService = game:GetService("TeleportService")
local ContextActionService = game:GetService("ContextActionService")
local Parent = script:FindFirstAncestor("InExperienceDetailsPrompt").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local DataHydration = require(Parent.DataHydration)
local Game = DataHydration.Game
local VotesUtils = Game.VotesUtils
local EnumGameDetailErrorTypes = require(Parent.DiscoveryTypes).EnumGameDetailErrorTypes
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local fireInExperienceDetailsPromptClosedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptClosedEvent
local fireInExperienceDetailsPromptPlayButtonClickedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptPlayButtonClickedEvent
local fireInExperienceDetailsPromptLoadedEvent = DiscoveryAnalytics.Events.fireInExperienceDetailsPromptLoadedEvent
local FocusNavigationUtils = require(Parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local InExperienceDetailsPrompt = require(script.Parent.InExperienceDetailsPrompt)
local FFlagLuaAppIedpOverlayAndNavigationFix = require(Parent.SharedFlags).FFlagLuaAppIedpOverlayAndNavigationFix
local FFlagLuaAppIedpFixPlayButton = require(Parent.SharedFlags).FFlagLuaAppIedpFixPlayButton
local FFlagLuaAppIedpControlledJoin = require(Parent.SharedFlags).FFlagLuaAppIedpControlledJoin
local v22 = if not FFlagLuaAppIedpOverlayAndNavigationFix then nil else "InExperienceDetailsPromptClose"

local function getGameDetailErrorType(p1, p2) -- line: 45
	-- upvalues: DataHydration (copy), EnumGameDetailErrorTypes (copy)
	if p1 == DataHydration.DataStatus.Failed then
		return EnumGameDetailErrorTypes.NetworkError
	end

	if p2 and p2.isUnavailable == true then
		return EnumGameDetailErrorTypes.ExperienceUnavailable
	end

	return nil
end
local function InExperienceDetailsPromptContainer(t1: {[any]: any}) -- line: 60
	-- upvalues: Game (copy), SignalsReact (copy), DataHydration (copy), EnumGameDetailErrorTypes (copy), useFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), React (copy), FFlagLuaAppIedpControlledJoin (copy), fireInExperienceDetailsPromptClosedEvent (copy), fireInExperienceDetailsPromptPlayButtonClickedEvent (copy), TeleportService (copy), DiscoveryEventErrorLogger (copy), FFlagLuaAppIedpOverlayAndNavigationFix (copy), v22 (copy), ContextActionService (copy), fireInExperienceDetailsPromptLoadedEvent (copy), InExperienceDetailsPrompt (copy), VotesUtils (copy), FFlagLuaAppIedpFixPlayButton (copy)
	local v28 = Game.getGameInfoStore(false)
	local v29 = Game.getAgeRecommendationStore(false)
	local v30 = Game.getPlayabilityStore(false)
	local v31 = Game.getVotesStore(false)
	local v32 = v28.getAndFetchGameInfo(t1.universeId)
	local v33 = v29.getAndFetchAgeRecommendation(t1.universeId)
	local v34 = v30.getAndFetchPlayability(t1.universeId)
	local v35 = v31.getAndFetchVote(t1.universeId)
	local v36 = SignalsReact.useSignalState(v32.data)
	local v37 = SignalsReact.useSignalState(v33.data)
	local v38 = SignalsReact.useSignalState(v34.data)
	local v39 = SignalsReact.useSignalState(v35.data)
	local v40 = SignalsReact.useSignalState(v32.status)
	local v41 = SignalsReact.useSignalState(v34.status)
	local v42 = if not v36 or not v36.rootPlaceId then nil else tonumber(v36.rootPlaceId)
	local v43 = if v40 ~= DataHydration.DataStatus.Failed then if not v36 or v36.isUnavailable ~= true then nil else EnumGameDetailErrorTypes.ExperienceUnavailable else EnumGameDetailErrorTypes.NetworkError
	local v44 = useFocusRoot({
		isIsolated = true,
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
	})
	local v45 = React.useCallback(function() -- line: 90
		-- upvalues: FFlagLuaAppIedpControlledJoin (copy), t1 (copy), v42 (copy), fireInExperienceDetailsPromptClosedEvent (copy), v40 (copy), DataHydration (copy), v41 (copy), v38 (copy), v43 (copy), fireInExperienceDetailsPromptPlayButtonClickedEvent (copy), TeleportService (copy), DiscoveryEventErrorLogger (copy)
		if FFlagLuaAppIedpControlledJoin then
			if t1.onJoin then
				t1.onJoin(v42)
			end

			if v42 then
				fireInExperienceDetailsPromptClosedEvent({
					targetUniverseId = t1.universeId,
					targetRootPlaceId = v42,
					closeReason = Enum.PromptExperienceDetailsResult.TeleportAttempted.Name,
					isFullyLoaded = v40 ~= DataHydration.DataStatus.NotReady and v41 ~= DataHydration.DataStatus.NotReady,
					isPlayable = v38 and v38.isPlayable,
					playabilityStatus = v38 and v38.playabilityStatus,
					gameInfoErrorType = v43
				})
			end

			fireInExperienceDetailsPromptPlayButtonClickedEvent({
				targetUniverseId = t1.universeId,
				targetRootPlaceId = v42,
				playabilityRetrievalStatus = v41
			})

			return
		end

		if v42 then
			t1.onClose()
			TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.TeleportAttempted)
			TeleportService:Teleport(v42)
			fireInExperienceDetailsPromptClosedEvent({
				targetUniverseId = t1.universeId,
				targetRootPlaceId = v42,
				closeReason = Enum.PromptExperienceDetailsResult.TeleportAttempted.Name,
				isFullyLoaded = v40 ~= DataHydration.DataStatus.NotReady and v41 ~= DataHydration.DataStatus.NotReady,
				isPlayable = v38 and v38.isPlayable,
				playabilityStatus = v38 and v38.playabilityStatus,
				gameInfoErrorType = v43
			})
		else
			DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptContainerOnJoinMissingRootPlaceId", "Missing valid root place id for universe id", {
				universeId = t1.universeId,
				rootPlaceId = v42
			})
		end

		fireInExperienceDetailsPromptPlayButtonClickedEvent({
			targetUniverseId = t1.universeId,
			targetRootPlaceId = v42,
			playabilityRetrievalStatus = v41
		})
	end, {
		t1.onClose,
		v42,
		t1.universeId,
		v40,
		v41,
		v38,
		v43,
		if not FFlagLuaAppIedpControlledJoin then nil else t1.onJoin
	})
	local v46 = v38 and v38.isPlayable
	local v47 = v38 and v38.playabilityStatus
	local v48 = React.useCallback(function() -- line: 162
		-- upvalues: t1 (copy), FFlagLuaAppIedpControlledJoin (copy), TeleportService (copy), fireInExperienceDetailsPromptClosedEvent (copy), v42 (copy), v43 (copy), v46 (copy), v47 (copy), v40 (copy), DataHydration (copy), v41 (copy)
		t1.onClose()

		if not FFlagLuaAppIedpControlledJoin then
			TeleportService:PromptExperienceDetailsCompleted(Enum.PromptExperienceDetailsResult.PromptClosed)
		end

		fireInExperienceDetailsPromptClosedEvent({
			targetUniverseId = t1.universeId,
			targetRootPlaceId = v42,
			gameInfoErrorType = v43,
			closeReason = Enum.PromptExperienceDetailsResult.PromptClosed.Name,
			isPlayable = v46,
			playabilityStatus = v47,
			isFullyLoaded = v40 ~= DataHydration.DataStatus.NotReady and v41 ~= DataHydration.DataStatus.NotReady
		})
	end, {
		t1.onClose,
		t1.universeId,
		v42,
		v43,
		v46,
		v47,
		v40,
		v41
	})
	local u49 = nil

	if FFlagLuaAppIedpOverlayAndNavigationFix then
		u49 = React.useRef(nil)
		React.useEffect(function() -- line: 194
			-- upvalues: v22 (copy), u49 (ref), DiscoveryEventErrorLogger (copy), t1 (copy), ContextActionService (copy)
			ContextActionService:BindCoreAction(v22, function(p3, p4) -- line: 195
				-- upvalues: v22 (copy), u49 (ref), DiscoveryEventErrorLogger (copy), t1 (copy)
				if p3 == v22 and p4 == Enum.UserInputState.Begin then
					if u49.current and u49.current.close then
						u49.current.close()
					else
						DiscoveryEventErrorLogger.reportError("InExperienceDetailsPromptCloseError", "SheetRef containing close function is not defined", {
							sheetRef = u49,
							universeId = t1.universeId
						})
					end
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape, Enum.KeyCode.ButtonStart)

			return function() -- line: 220
				-- upvalues: ContextActionService (copy), v22 (copy)
				ContextActionService:UnbindCoreAction(v22)
			end
		end, { t1.universeId })
	end

	local v50 = React.useRef(false)

	React.useEffect(function() -- line: 228
		-- upvalues: v50 (copy), v40 (copy), DataHydration (copy), v41 (copy), fireInExperienceDetailsPromptLoadedEvent (copy), t1 (copy), v42 (copy), v46 (copy), v47 (copy), v43 (copy)
		if not v50.current and (v40 ~= DataHydration.DataStatus.NotReady and v41 ~= DataHydration.DataStatus.NotReady) then
			fireInExperienceDetailsPromptLoadedEvent({
				targetUniverseId = t1.universeId,
				gameInfoRetrievalStatus = v40,
				playabilityRetrievalStatus = v41,
				targetRootPlaceId = v42,
				isPlayable = v46,
				playabilityStatus = v47,
				gameInfoErrorType = v43
			})
			v50.current = true
		end
	end, {
		t1.universeId,
		v40,
		v41,
		v42,
		v46,
		v47,
		v43
	})

	return React.createElement(InExperienceDetailsPrompt, {
		name = v36 and v36.name,
		imageUri = v36 and `rbxthumb://type=GameIcon&id={ t1.universeId }&w=150&h=150`,
		creator = v36 and v36.creator,
		ageRecommendation = v37,
		rating = v39 and VotesUtils.getRatingDisplayText(v39),
		playability = v38,
		errorType = v43,
		rootPlaceId = if not FFlagLuaAppIedpFixPlayButton then nil else v42,
		onJoin = v45,
		onClose = v48,
		focusRootRef = v44,
		sheetRef = if not FFlagLuaAppIedpOverlayAndNavigationFix then nil else u49,
		playabilityRetrievalStatus = v41
	})
end

return InExperienceDetailsPromptContainer
