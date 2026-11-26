local module = require("@luauforge/deferred/fbA")
local module2 = require("@luauforge/deferred/eko")

require("@luauforge/deferred/fby")
local module3 = require("@luauforge/deferred/fbz")
require("@luauforge/deferred/elo")
local module4 = require("@luauforge/deferred/elp")

local function useFireAnalyticsEvent(p2, p3)
	return module2.useCallback(function(p4, options)
		if p2 ~= nil then
			options = module.Dictionary.join(options or {}, { entrySource = p2 })
		end

		if module4 and p3 ~= nil then
			options = module.Dictionary.join(options or {}, {
				flowSessionId = p3.getFlowSessionId(),
				submitAttempt = p3.getSubmitAttempt()
			})
		end

		module3(p4, options)
	end, { p2, p3 })
end

return useFireAnalyticsEvent
