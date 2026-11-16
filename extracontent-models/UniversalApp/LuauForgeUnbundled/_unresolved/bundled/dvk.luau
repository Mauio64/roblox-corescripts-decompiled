local makeActionCreator = require("@luauforge/bundled/dqu").makeActionCreator
require("@luauforge/bundled/dqn")

return makeActionCreator("ClearFeedItemRenderedRows", function(p2, p3, p4, p5)
	return { appPage = p2, secondaryKey = p3, feedItemPosition = p4, feedItem = p5 }
end)
