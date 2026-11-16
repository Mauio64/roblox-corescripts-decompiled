local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)
local defineFastFlag = game:DefineFastFlag("ClientErrorAdditionalArgs", false)

return function(p: string, state: string, url: string?, origin: string?)
	local v = {}

	if state then
		v.state = state
	end

	if defineFastFlag and url then
		v.url = url
	end

	if defineFastFlag and origin then
		v.origin = origin
	end

	checkAndSendEvent(p, "authClientError", v)
end
