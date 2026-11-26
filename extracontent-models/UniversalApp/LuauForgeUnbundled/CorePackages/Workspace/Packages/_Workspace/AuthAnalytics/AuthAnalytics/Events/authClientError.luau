local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")
local defineFastFlag = game:DefineFastFlag("ClientErrorAdditionalArgs", false)

return function(p2, state, url, origin)
	local v5 = {}

	if state then
		v5.state = state
	end

	if defineFastFlag and url then
		v5.url = url
	end

	if defineFastFlag and origin then
		v5.origin = origin
	end

	checkAndSendEvent(p2, "authClientError", v5)
end
