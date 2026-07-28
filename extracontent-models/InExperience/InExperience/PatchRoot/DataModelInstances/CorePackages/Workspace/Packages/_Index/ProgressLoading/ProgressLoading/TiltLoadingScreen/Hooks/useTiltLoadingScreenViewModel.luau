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
	local v18 = SignalsReact.useSignalState(v15.getIsAutoTranslated)
	local v19 = useScreenSize()
	local v20 = React.useRef(v18)
	local v21 = React.useRef(false)

	React.useEffect(function() -- line: 33
		-- upvalues: v15 (copy)
		v15.start()

		return v15.destroy
	end, { v15 })
	v20.current = v18
	v21.current = FFlagAddAutoTranslateToLoadingScreen and not (FFlagAutoTranslateSkipZeroUniverseId and v17 <= 0)
	React.useEffect(function() -- line: 40
		-- upvalues: v21 (copy), v20 (copy), LoadingScreenTelemetry (copy)
		return function() -- line: 41
			-- upvalues: v21 (copy), v20 (copy), LoadingScreenTelemetry (copy)
			if v21.current and v20.current == nil then
				LoadingScreenTelemetry.countPlayerLocalizationChoiceNotReady()
			end
		end
	end, {})

	local v22 = React.useMemo(function() -- line: 48
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
		isMobile = math.min(v19.X, v19.Y) <= Constants.MOBILE_BREAKPOINT,
		gameData = v22,
		thumbnailUrl = not (v17 > 0) and "" or string.format("rbxthumb://type=GameIcon&id=%d&w=256&h=256", v17),
		isAutoTranslated = v18
	}
end

return useTiltLoadingScreenViewModel
