local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, state: string, field: string, errorCode: string?, associatedText: string?)
	local v = {}

	if state then
		v.state = state
	end

	if field then
		v.field = field
	end

	if errorCode then
		v.errorCode = errorCode
	end

	if associatedText then
		v.associatedText = associatedText
	end

	checkAndSendEvent(p, "authMsgShown", v)
end
