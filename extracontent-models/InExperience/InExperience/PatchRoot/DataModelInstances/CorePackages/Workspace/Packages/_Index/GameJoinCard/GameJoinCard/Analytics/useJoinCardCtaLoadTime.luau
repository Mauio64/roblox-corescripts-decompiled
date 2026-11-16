local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)

local GameJoinCardTTI = require(GameJoinCard.Telemetry.GameJoinCardTTI)
local useGameJoinCardAnalytics = require(script.Parent.useGameJoinCardAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagGameJoinCardOptionalActions = SharedFlags.FFlagGameJoinCardOptionalActions
local SharedFlags2 = require(parent.SharedFlags)
local FFlagGameJoinCardContent = SharedFlags2.FFlagGameJoinCardContent

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
		if (FFlagGameJoinCardOptionalActions or FFlagGameJoinCardContent) and data.isDisabled then
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

		local v = tick() * 1000
		local current = ref2.current or ref.current * 1000
		useGameJoinCardAnalytics.logJoinCardCtaLoadTime({
			durationMs = v - current,
			ctaType = ref5.current,
			wasCached = ref6.current == true
		})
	end

	local isLoading = data.isLoading
	local v

	if FFlagGameJoinCardOptionalActions or FFlagGameJoinCardContent then
		v = data.isDisabled
	end

	useEffect(fn, { isLoading, v })
end

return useJoinCardCtaLoadTime
