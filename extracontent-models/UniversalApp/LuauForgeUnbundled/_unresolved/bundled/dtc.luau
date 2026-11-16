local makeActionCreator = require("@luauforge/bundled/dqu").makeActionCreator
require("@luauforge/bundled/dqn")

return makeActionCreator("AddExploreOmniItems", function(p2, p3, p4, p5)
	return { appPage = p2, topicInfos = p3, isAppend = p4, omniFeedPageSection = p5 }
end)
