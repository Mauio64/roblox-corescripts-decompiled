local module = require("@luauforge/deferred/eeO")
local useSelector = require("@luauforge/deferred/efh").Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/deferred/efi")
local shallowEqual = require("@luauforge/deferred/eeP").shallowEqual

local roduxAnalytics = require("@luauforge/deferred/efj").RoduxAnalytics
local RECOMMENDATION_SESSION_ID_KEY = require("@luauforge/deferred/efP").RECOMMENDATION_SESSION_ID_KEY
local getSessionIdByKey = roduxAnalytics.Selectors.getSessionIdByKey

local module3 = require("@luauforge/deferred/eeY")
local module4 = require("@luauforge/deferred/efQ")

local fFlagAddFriendsPymkSessionService = require("@luauforge/deferred/efc").FFlagAddFriendsPymkSessionService
local module5 = require("@luauforge/deferred/efS")

return function(current)
	local v5

	if fFlagAddFriendsPymkSessionService then
		v5 = nil
	else
		v5 = useSelector(function(p2)
			return getSessionIdByKey(p2)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local v6 = module.useMemo(function()
		return module3({
			infoForAllEvents = { recommendationSessionId = v5 }
		}).fireAnalyticsEvent
	end, { v5 })

	if module5 then
		local ref = module.useRef(current)

		if not shallowEqual(ref.current, current) then
			ref.current = current
		end

		current = ref.current
	end

	local function fn(p2, options)
		local v7 = fFlagAddFriendsPymkSessionService
			and { recommendationSessionId = module4.getPymkSessionId() }
			or {}
		return v6(p2, module2.Dictionary.join(options or {}, current or {}, v7))
	end

	return module.useCallback(fn, { current, if module5 then v6 else nil })
end
