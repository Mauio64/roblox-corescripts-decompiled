local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local GameJoinCardParent = GameJoinCard.Parent
local React = require(GameJoinCardParent.React)
local GameJoinCardTTI = require(GameJoinCard.Telemetry.GameJoinCardTTI)
local useGameJoinCardAnalytics = require(script.Parent.useGameJoinCardAnalytics)
local FFlagJoinCardAgeCheckUpsell = require(GameJoinCardParent.SharedFlags).FFlagJoinCardAgeCheckUpsell

local function useJoinCardCtaLoadTime(t1: {[any]: any}) -- line: 46
	-- upvalues: React (copy), FFlagJoinCardAgeCheckUpsell (copy), GameJoinCardTTI (copy), useGameJoinCardAnalytics (copy)
	local v9 = React.useRef(tick())
	local v10 = React.useRef(nil)
	local v11 = React.useRef(false)
	local v12 = React.useRef(false)
	local v13 = React.useRef(t1.ctaType)

	v13.current = t1.ctaType

	local v14 = React.useRef(t1.wasCached)

	v14.current = t1.wasCached
	React.useEffect(function() -- line: 57
		-- upvalues: FFlagJoinCardAgeCheckUpsell (copy), v11 (copy), v10 (copy), GameJoinCardTTI (copy), v12 (copy), t1 (copy), v9 (copy), useGameJoinCardAnalytics (copy), v13 (copy), v14 (copy)
		if not FFlagJoinCardAgeCheckUpsell then
			return
		end

		if not v11.current then
			v11.current = true
			v10.current = GameJoinCardTTI.consumeMobileCardClickStartMs()
		end

		if v12.current or t1.isLoading then
			return
		end

		v12.current = true

		local v15 = tick() * 1000
		local v16 = v10.current or v9.current * 1000

		useGameJoinCardAnalytics.logJoinCardCtaLoadTime({
			durationMs = v15 - v16,
			ctaType = v13.current,
			wasCached = v14.current == true
		})
	end, { t1.isLoading })
end

return useJoinCardCtaLoadTime
