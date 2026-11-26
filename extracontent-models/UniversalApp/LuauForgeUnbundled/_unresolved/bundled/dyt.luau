local makeActionCreator = require("@luauforge/bundled/dtw").makeActionCreator
require("@luauforge/bundled/dtp")

return makeActionCreator("SetFeedItemRenderedRows", function(p2, p3, p4, p5, p6)
	return {
		appPage = p2,
		secondaryKey = p3,
		feedItemPosition = p4,
		feedItem = p5,
		actualNumberOfRows = p6
	}
end)
