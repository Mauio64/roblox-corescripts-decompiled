local Parent = script:FindFirstAncestor("SocialCarousel").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local useLoadingTimers = require(Parent.SocialLuaAnalytics).Analytics.Timing.useLoadingTimers

return function(p1: ((...any) -> ...any)) -- line: 10
	-- upvalues: useLoadingTimers (copy), React (copy), Cryo (copy)
	local v6 = useLoadingTimers({})
	local v7 = React.useRef({})
	local v8 = React.useCallback(function(s1: string) -- line: 16
		-- upvalues: v7 (copy), Cryo (copy), v6 (copy), p1 (copy)
		if v7.current[s1] then
			return
		end

		v7.current = Cryo.Dictionary.join(v7.current, {
			[s1] = true
		})

		local v10 = v6.getTime("carouselLoadingTime")

		p1(s1, v10)
	end, {})

	React.useEffect(function() -- line: 29
		-- upvalues: v6 (copy)
		v6.start("carouselLoadingTime")
	end, {})

	return {
		onSuccessfulRender = v8
	}
end
