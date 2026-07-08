local Parent = script:FindFirstAncestor("FriendsCarousel").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLoadingTimers = SocialLuaAnalytics.Analytics.Timing.useLoadingTimers
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local AnalyticsSetup = require(script.Parent.AnalyticsSetup)
local EventNames = require(script.Parent.EventNames)
local UILoadingEvents = require(script.Parent.UILoadingEvents)

local function CarouselWithLoadingTimer(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalUserId (copy), useLoadingTimers (copy), React (copy), AnalyticsSetup (copy), EventNames (copy), RetrievalStatus (copy), UILoadingEvents (copy)
	local v14 = useLocalUserId()
	local v15 = useLoadingTimers({})
	local v16 = React.useRef({})
	local v17 = React.useMemo(function() -- line: 32
		-- upvalues: AnalyticsSetup (copy), v14 (copy)
		return AnalyticsSetup({
			infoForAllEvents = {
				uid = if not v14 then nil else tostring(v14)
			}
		})
	end, { v14 })

	React.useEffect(function() -- line: 40
		-- upvalues: v15 (copy)
		v15.start("carouselLoadingTime")
	end, {})

	local function v18(s1: string, n1: number) -- line: 44
		-- upvalues: v17 (copy), EventNames (copy), RetrievalStatus (copy)
		local v21 = if not not n1 and (typeof(n1) == "number" and not (n1 < 0)) then n1 else 0

		v17.fireAnalyticsEvent(EventNames.FriendsCarouselUILoadingTime, {
			loadingTime = v21,
			fetch = s1,
			status = RetrievalStatus.Done.rawValue()
		})
	end

	return t1.renderComponent({
		onSuccessfulRender = function(s2: string) -- line: 57
			-- upvalues: v16 (copy), UILoadingEvents (copy), v15 (copy), v18 (copy)
			if v16.current[UILoadingEvents.EmptyHint] or v16.current[`{ UILoadingEvents.EmptyHint }{ UILoadingEvents.ExperimentSuffix }`] then
				return
			end

			if not s2 or v16.current[s2] then
				return
			end

			v16.current[s2] = true

			local v23 = v15.getTime("carouselLoadingTime")

			v18(s2, v23)
		end
	})
end

return CarouselWithLoadingTimer
