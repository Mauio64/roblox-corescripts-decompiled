local makeActionCreator = require("@luauforge/bundled/dtw").makeActionCreator
require("@luauforge/bundled/dtp")

return makeActionCreator("AddOmniRecommendations", function(p2, isAppend)
	return {
		recommendations = { [p2.pageType] = p2 },
		isAppend = isAppend
	}
end)
