local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, field, state, origin, p3, associatedText)
	local v5 = {}

	if field then
		v5.field = field
	end

	if state then
		v5.state = state
	end

	if origin then
		v5.origin = origin
	end

	if p3 ~= nil then
		v5.entered = tostring(p3)
	end

	if associatedText then
		v5.associatedText = associatedText
	end

	checkAndSendEvent(p2, "authFormInteraction", v5)
end
