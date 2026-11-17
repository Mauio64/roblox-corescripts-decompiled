local parent = script:FindFirstAncestor("FriendsCarousel").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local useLocalUserId = RobloxAppHooks.useLocalUserId
local useLoadingTimers = SocialLuaAnalytics.Analytics.Timing.useLoadingTimers
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus

local AnalyticsSetup = require(script.Parent.AnalyticsSetup)
local EventNames = require(script.Parent.EventNames)
local UILoadingEvents = require(script.Parent.UILoadingEvents)

local function CarouselWithLoadingTimer(p)
	local v = useLocalUserId()
	local v2 = useLoadingTimers({})
	local ref = React.useRef({})

	local v3 = React.useMemo(function()
		local uid

		if v then
			uid = tostring(v)
		end

		return AnalyticsSetup({
			infoForAllEvents = { uid = uid }
		})
	end, { v })

	React.useEffect(function()
		v2.start("carouselLoadingTime")
	end, {})

	local function fn(fetch: string, time: number)
		local loadingTime = (not time or typeof(time) ~= "number" or time < 0) and 0 or time

		v3.fireAnalyticsEvent(EventNames.FriendsCarouselUILoadingTime, {
			loadingTime = loadingTime,
			fetch = fetch,
			status = RetrievalStatus.Done.rawValue()
		})
	end

	local function onSuccessfulRender(fetch: string)
		if
			ref.current[UILoadingEvents.EmptyHint]
			or ref.current[`{UILoadingEvents.EmptyHint}{UILoadingEvents.ExperimentSuffix}`]
			or (not fetch or ref.current[fetch])
		then
			return
		end

		ref.current[fetch] = true

		fn(fetch, v2.getTime("carouselLoadingTime"))
	end

	return p.renderComponent({ onSuccessfulRender = onSuccessfulRender })
end

return CarouselWithLoadingTimer
