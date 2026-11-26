local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SignalsReact")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Constants")
local createTiltLoadingScreenModel = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Models/createTiltLoadingScreenModel")
local LoadingScreenTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenTelemetry")

require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/TiltLoadingScreen/Types")

local function useTiltLoadingScreenViewModel(p2, p3, p4)
	local v5 = React.useMemo(function()
		return createTiltLoadingScreenModel(p2, nil, p4)
	end, { p2, p4 })
	local v6 = SignalsReact.useSignalState(v5.getAssetInfo)
	local v7 = SignalsReact.useSignalState(v5.getUniverseId)
	local v8 = SignalsReact.useSignalState(v5.getFollowUserId)
	local v9 = SignalsReact.useSignalState(v5.getIsAutoTranslated)
	local v10 = SignalsReact.useSignalState(v5.getIsSubjectToChinaPolicies)
	local v11 = SignalsReact.useSignalState(v5.getJoinState)
	local v12 = SignalsReact.useSignalState(v5.getQueuePosition)
	local v13 = SignalsReact.useSignalState(v5.getQueueTreatment)
	local v14 = SignalsReact.useSignalState(v5.getServerStatusText)
	local ref = React.useRef(v9)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		v5.start()
		return v5.destroy
	end, { v5 })
	ref.current = v9
	ref2.current = not (v7 <= 0)
	React.useEffect(function()
		return function()
			if ref2.current and ref.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	local v15 = React.useCallback(function(p5)
		v5.logQueuedStateButtonClick("JoinNewServer", p5)
		v5.launchExperience()
	end, { v5 })
	local v16 = React.useCallback(function()
		v5.launchExperience()
	end, { v5 })
	local v17 = React.useCallback(function(p5)
		v5.logQueuedStateButtonClick("JoinTheLine", p5)
	end, { v5 })
	local v18 = React.useCallback(function()
		v5.showConnectionHealth()
	end, { v5 })
	local v19 = React.useMemo(function()
		if v6 then
			return {
				name = v6.name or "",
				creator = v6.creatorName or "",
				verified = v6.creatorHasVerifiedBadge == true
			}
		end

		return nil
	end, { v6 })

	return {
		isMobile = math.min(p3.X, p3.Y) <= Constants.MOBILE_BREAKPOINT,
		gameData = v19,
		thumbnailUrl = not (v7 > 0) and "" or string.format(
			"rbxthumb://type=GameIcon&id=%d&w=256&h=256",
			v7
		),
		isAutoTranslated = v9,
		statusPanel = {
			status = v11,
			statusText = v14,
			queuePosition = v12,
			queueTreatment = v13,
			followUserId = v8,
			isSubjectToChinaPolicies = v10,
			onAutoJoinNewServer = v16,
			onJoinNewServer = v15,
			onJoinTheLine = v17,
			onShowConnectionHealth = v18
		}
	}
end

return useTiltLoadingScreenViewModel
