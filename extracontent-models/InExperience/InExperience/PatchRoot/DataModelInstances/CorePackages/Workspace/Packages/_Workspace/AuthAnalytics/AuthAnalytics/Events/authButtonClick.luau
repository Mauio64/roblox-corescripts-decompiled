local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, btn: string, state: string?, url: string?, is_alt_attempt: boolean?, origin: string?, ctype: string?, associatedText: string?)
	local v = {}

	if btn then
		v.btn = btn
	end

	if state then
		v.state = state
	end

	if url then
		v.url = url
	end

	if is_alt_attempt ~= nil then
		v.is_alt_attempt = is_alt_attempt
	end

	if origin then
		v.origin = origin
	end

	if ctype then
		v.ctype = ctype
	end

	if associatedText then
		v.associatedText = associatedText
	end

	checkAndSendEvent(p, "authButtonClick", v)
end
