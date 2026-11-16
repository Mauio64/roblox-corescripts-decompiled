local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, btn: string, state: string?, origin: string?)
	local v = { btn = btn }

	if state then
		v.state = state
	end

	if origin then
		v.origin = origin
	end

	checkAndSendEvent(p, "authButtonShown", v)
end
