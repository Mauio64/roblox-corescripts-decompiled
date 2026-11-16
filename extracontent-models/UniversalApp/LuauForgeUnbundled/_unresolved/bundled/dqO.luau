local makeActionCreator = require("@luauforge/bundled/dqu").makeActionCreator
require("@luauforge/bundled/dqn")

return makeActionCreator("AddOmniRecommendations", function(p2, isAppend)
	return {
		recommendations = { [p2.pageType] = p2 },
		isAppend = isAppend
	}
end)
