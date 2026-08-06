local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local TiltLoadingScreenParent = TiltLoadingScreen.Parent
local TiltLoadingScreenParentParent = TiltLoadingScreenParent.Parent
local React = require(TiltLoadingScreenParentParent.React)
local SignalsReact = require(TiltLoadingScreenParentParent.SignalsReact)
local Constants = require(TiltLoadingScreen.Constants)
local createTiltLoadingScreenModel = require(TiltLoadingScreen.Models.createTiltLoadingScreenModel)
local LoadingScreenTelemetry = require(TiltLoadingScreenParent.LoadingScreenTelemetry)
local useScreenSize = require(script.Parent.useScreenSize)
local SharedFlags = require(TiltLoadingScreenParentParent.SharedFlags)

require(TiltLoadingScreen.Types)

local FFlagAddAutoTranslateToLoadingScreen = SharedFlags.FFlagAddAutoTranslateToLoadingScreen
local FFlagAutoTranslateSkipZeroUniverseId = SharedFlags.FFlagAutoTranslateSkipZeroUniverseId

local function useTiltLoadingScreenViewModel(n1: number) -- line: 22
	-- upvalues: React (copy), createTiltLoadingScreenModel (copy), SignalsReact (copy), useScreenSize (copy), FFlagAddAutoTranslateToLoadingScreen (copy), FFlagAutoTranslateSkipZeroUniverseId (copy), LoadingScreenTelemetry (copy), Constants (copy)
	local v15 = React.useMemo(function() -- line: 23
		-- upvalues: createTiltLoadingScreenModel (copy), n1 (copy)
		return createTiltLoadingScreenModel(n1)
	end, { n1 })
	local v16 = SignalsReact.useSignalState(v15.getAssetInfo)
	local v17 = SignalsReact.useSignalState(v15.getUniverseId)
	local v18 = SignalsReact.useSignalState(v15.getFollowUserId)
	local v19 = SignalsReact.useSignalState(v15.getIsAutoTranslated)
	local v20 = SignalsReact.useSignalState(v15.getIsSubjectToChinaPolicies)
	local v21 = SignalsReact.useSignalState(v15.getJoinState)
	local v22 = SignalsReact.useSignalState(v15.getQueuePosition)
	local v23 = SignalsReact.useSignalState(v15.getQueueTreatment)
	local v24 = SignalsReact.useSignalState(v15.getServerStatusText)
	local v25 = useScreenSize()
	local v26 = React.useRef(v19)
	local v27 = React.useRef(false)

	React.useEffect(function() -- line: 39
		-- upvalues: v15 (copy)
		v15.start()

		return v15.destroy
	end, { v15 })
	v26.current = v19
	v27.current = FFlagAddAutoTranslateToLoadingScreen and not (FFlagAutoTranslateSkipZeroUniverseId and v17 <= 0)
	React.useEffect(function() -- line: 46
		-- upvalues: v27 (copy), v26 (copy), LoadingScreenTelemetry (copy)
		return function() -- line: 47
			-- upvalues: v27 (copy), v26 (copy), LoadingScreenTelemetry (copy)
			if v27.current and v26.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	local v28 = React.useCallback(function(n2: number?) -- line: 54
		-- upvalues: v15 (copy)
		v15.logQueuedStateButtonClick("JoinNewServer", n2)
		v15.launchExperience()
	end, { v15 })
	local v29 = React.useCallback(function() -- line: 58
		-- upvalues: v15 (copy)
		v15.launchExperience()
	end, { v15 })
	local v30 = React.useCallback(function(n3: number?) -- line: 61
		-- upvalues: v15 (copy)
		v15.logQueuedStateButtonClick("JoinTheLine", n3)
	end, { v15 })
	local v31 = React.useCallback(function() -- line: 64
		-- upvalues: v15 (copy)
		v15.showConnectionHealth()
	end, { v15 })
	local v32 = React.useMemo(function() -- line: 67
		-- upvalues: v16 (copy)
		if v16 then
			return {
				name = v16.name or "",
				creator = v16.creatorName or "",
				verified = v16.creatorHasVerifiedBadge == true
			}
		end

		return nil
	end, { v16 })

	return {
		isMobile = math.min(v25.X, v25.Y) <= Constants.MOBILE_BREAKPOINT,
		gameData = v32,
		thumbnailUrl = not (v17 > 0) and "" or string.format("rbxthumb://type=GameIcon&id=%d&w=256&h=256", v17),
		isAutoTranslated = v19,
		statusPanel = {
			status = v21,
			statusText = v24,
			queuePosition = v22,
			queueTreatment = v23,
			followUserId = v18,
			isSubjectToChinaPolicies = v20,
			onAutoJoinNewServer = v29,
			onJoinNewServer = v28,
			onJoinTheLine = v30,
			onShowConnectionHealth = v31
		}
	}
end

return useTiltLoadingScreenViewModel
