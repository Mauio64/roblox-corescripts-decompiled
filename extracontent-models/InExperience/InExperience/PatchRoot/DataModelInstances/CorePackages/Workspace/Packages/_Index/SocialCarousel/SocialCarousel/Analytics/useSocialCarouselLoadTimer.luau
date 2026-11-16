local parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local useLoadingTimers = SocialLuaAnalytics.Analytics.Timing.useLoadingTimers

return function(callback)
	local v = useLoadingTimers({})
	local ref = React.useRef({})

	local onSuccessfulRender = React.useCallback(function(p: string)
		if ref.current[p] then
			return
		end

		ref.current = Cryo.Dictionary.join(ref.current, { [p] = true })

		callback(p, (v.getTime("carouselLoadingTime")))
	end, {})

	React.useEffect(function()
		v.start("carouselLoadingTime")
	end, {})

	return { onSuccessfulRender = onSuccessfulRender }
end
