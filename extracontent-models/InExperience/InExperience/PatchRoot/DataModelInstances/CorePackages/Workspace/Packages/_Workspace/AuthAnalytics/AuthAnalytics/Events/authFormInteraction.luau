local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, field: string?, state: string?, origin: string?, p2, associatedText: string?)
	local v = {}

	if field then
		v.field = field
	end

	if state then
		v.state = state
	end

	if origin then
		v.origin = origin
	end

	if p2 ~= nil then
		v.entered = tostring(p2)
	end

	if associatedText then
		v.associatedText = associatedText
	end

	checkAndSendEvent(p, "authFormInteraction", v)
end
