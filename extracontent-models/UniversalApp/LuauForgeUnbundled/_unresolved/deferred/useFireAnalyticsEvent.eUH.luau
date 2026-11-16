local module = require("@luauforge/deferred/eUB")
local module2 = require("@luauforge/deferred/egU")

require("@luauforge/deferred/eUz")
local module3 = require("@luauforge/deferred/eUA")
require("@luauforge/deferred/ehU")
local module4 = require("@luauforge/deferred/ehV")

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
