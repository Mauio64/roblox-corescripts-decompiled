local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useSelector = require(AddFriendsParent.RoactUtils).Hooks.RoactRodux.useSelector
local Cryo = require(AddFriendsParent.Cryo)
local RoduxAnalytics = require(AddFriendsParent.AddFriendsState).RoduxAnalytics
local RECOMMENDATION_SESSION_ID_KEY = require(AddFriends.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local getSessionIdByKey = RoduxAnalytics.Selectors.getSessionIdByKey
local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

return function(t1: {[any]: any}?) -- line: 14
	-- upvalues: useSelector (copy), getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy), React (copy), AnalyticsSetup (copy), Cryo (copy)
	local v11 = useSelector(function(p1) -- line: 15
		-- upvalues: getSessionIdByKey (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
		return getSessionIdByKey(p1)(RECOMMENDATION_SESSION_ID_KEY)
	end)
	local v12 = React.useMemo(function() -- line: 19
		-- upvalues: AnalyticsSetup (copy), v11 (copy)
		return AnalyticsSetup({
			infoForAllEvents = {
				recommendationSessionId = v11
			}
		}).fireAnalyticsEvent
	end, { v11 })

	return React.useCallback(function(p2, t2: {[any]: any}?) -- line: 27
		-- upvalues: v12 (copy), Cryo (copy), t1 (copy)
		return v12(p2, Cryo.Dictionary.join(t2 or {}, t1 or {}))
	end, { t1 })
end
