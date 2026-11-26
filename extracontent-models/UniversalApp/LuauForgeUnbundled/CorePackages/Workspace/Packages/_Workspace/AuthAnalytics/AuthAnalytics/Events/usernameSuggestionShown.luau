local checkAndSendEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthAnalytics/AuthAnalytics/Utils/checkAndSendEvent")

return function(p2, p3, list, p4)
	assert(type(list) == "table", "Expected suggestions to be a table")

	checkAndSendEvent(p2, "usernameSuggestionShown", {
		state = p3,
		suggestions = `[{table.concat(list, ",")}]`,
		field = p4
	})
end
