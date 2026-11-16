local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local useLoadingTimers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics").Analytics.Timing.useLoadingTimers

return function(callback)
	local v5 = useLoadingTimers({})
	local ref = React.useRef({})

	local v6 = React.useCallback(function(p2)
		if ref.current[p2] then
			return
		end

		ref.current = Cryo.Dictionary.join(ref.current, { [p2] = true })

		callback(p2, (v5.getTime("carouselLoadingTime")))
	end, {})

	React.useEffect(function()
		v5.start("carouselLoadingTime")
	end, {})

	return { onSuccessfulRender = v6 }
end
