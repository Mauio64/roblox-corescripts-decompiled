local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, btn, state, url, is_alt_attempt, origin, ctype, associatedText)
	local v5 = {}

	if btn then
		v5.btn = btn
	end

	if state then
		v5.state = state
	end

	if url then
		v5.url = url
	end

	if is_alt_attempt ~= nil then
		v5.is_alt_attempt = is_alt_attempt
	end

	if origin then
		v5.origin = origin
	end

	if ctype then
		v5.ctype = ctype
	end

	if associatedText then
		v5.associatedText = associatedText
	end

	checkAndSendEvent(p2, "authButtonClick", v5)
end
