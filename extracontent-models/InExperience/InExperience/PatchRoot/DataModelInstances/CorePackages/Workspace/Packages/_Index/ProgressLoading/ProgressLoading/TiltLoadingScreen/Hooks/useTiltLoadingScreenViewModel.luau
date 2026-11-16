local TiltLoadingScreen = script:FindFirstAncestor("TiltLoadingScreen")
local parent = TiltLoadingScreen.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SignalsReact = require(parent2.SignalsReact)

local Constants = require(TiltLoadingScreen.Constants)
local createTiltLoadingScreenModel = require(TiltLoadingScreen.Models.createTiltLoadingScreenModel)
local LoadingScreenTelemetry = require(parent.LoadingScreenTelemetry)

require(TiltLoadingScreen.Types)

local function useTiltLoadingScreenViewModel(p: number, vector2: Vector2, p2: number?)
	local v = React.useMemo(function()
		return createTiltLoadingScreenModel(p, nil, p2)
	end, { p, p2 })
	local v2 = SignalsReact.useSignalState(v.getAssetInfo)
	local v3 = SignalsReact.useSignalState(v.getUniverseId)
	local followUserId = SignalsReact.useSignalState(v.getFollowUserId)
	local v4 = SignalsReact.useSignalState(v.getIsAutoTranslated)
	local isSubjectToChinaPolicies = SignalsReact.useSignalState(v.getIsSubjectToChinaPolicies)
	local status = SignalsReact.useSignalState(v.getJoinState)
	local queuePosition = SignalsReact.useSignalState(v.getQueuePosition)
	local queueTreatment = SignalsReact.useSignalState(v.getQueueTreatment)
	local statusText = SignalsReact.useSignalState(v.getServerStatusText)
	local ref = React.useRef(v4)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		v.start()
		return v.destroy
	end, { v })
	ref.current = v4
	ref2.current = not (v3 <= 0)
	React.useEffect(function()
		return function()
			if ref2.current and ref.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	local onJoinNewServer = React.useCallback(function(p3: number?)
		v.logQueuedStateButtonClick("JoinNewServer", p3)
		v.launchExperience()
	end, { v })
	local onAutoJoinNewServer = React.useCallback(function()
		v.launchExperience()
	end, { v })
	local onJoinTheLine = React.useCallback(function(p3: number?)
		v.logQueuedStateButtonClick("JoinTheLine", p3)
	end, { v })
	local onShowConnectionHealth = React.useCallback(function()
		v.showConnectionHealth()
	end, { v })
	local gameData = React.useMemo(function()
		if v2 then
			return {
				name = v2.name or "",
				creator = v2.creatorName or "",
				verified = v2.creatorHasVerifiedBadge == true
			}
		end

		return nil
	end, { v2 })

	return {
		isMobile = math.min(vector2.X, vector2.Y) <= Constants.MOBILE_BREAKPOINT,
		gameData = gameData,
		thumbnailUrl = not (v3 > 0) and "" or string.format("rbxthumb://type=GameIcon&id=%d&w=256&h=256", v3),
		isAutoTranslated = v4,
		statusPanel = {
			status = status,
			statusText = statusText,
			queuePosition = queuePosition,
			queueTreatment = queueTreatment,
			followUserId = followUserId,
			isSubjectToChinaPolicies = isSubjectToChinaPolicies,
			onAutoJoinNewServer = onAutoJoinNewServer,
			onJoinNewServer = onJoinNewServer,
			onJoinTheLine = onJoinTheLine,
			onShowConnectionHealth = onShowConnectionHealth
		}
	}
end

return useTiltLoadingScreenViewModel
