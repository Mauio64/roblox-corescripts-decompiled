local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local GameJoinCardTTI = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Telemetry/GameJoinCardTTI")
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
local fFlagGameJoinCardOptionalActions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagGameJoinCardOptionalActions
local fFlagGameJoinCardContent = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagGameJoinCardContent

local function useJoinCardCtaLoadTime(data)
	local ref = React.useRef(tick())
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(false)
	local ref4 = React.useRef(false)

	local ref5 = React.useRef(data.ctaType)
	ref5.current = data.ctaType
	local ref6 = React.useRef(data.wasCached)
	ref6.current = data.wasCached

	local useEffect = React.useEffect
	local function fn()
		if (fFlagGameJoinCardOptionalActions or fFlagGameJoinCardContent) and data.isDisabled then
			return
		end

		if not ref3.current then
			ref3.current = true
			ref2.current = GameJoinCardTTI.consumeMobileCardClickStartMs()
		end

		if ref4.current or data.isLoading then
			return
		end

		ref4.current = true

		local v5 = tick() * 1000
		local current = ref2.current or ref.current * 1000
		useGameJoinCardAnalytics.logJoinCardCtaLoadTime({
			durationMs = v5 - current,
			ctaType = ref5.current,
			wasCached = ref6.current == true
		})
	end

	local isLoading = data.isLoading
	local v6 = if fFlagGameJoinCardOptionalActions or fFlagGameJoinCardContent then data.isDisabled else nil
	useEffect(fn, { isLoading, v6 })
end

return useJoinCardCtaLoadTime
