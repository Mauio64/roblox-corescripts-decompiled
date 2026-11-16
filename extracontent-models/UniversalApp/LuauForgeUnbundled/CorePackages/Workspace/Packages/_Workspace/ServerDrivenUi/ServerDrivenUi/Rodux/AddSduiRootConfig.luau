local makeActionCreator = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Rodux").makeActionCreator

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

return makeActionCreator("AddSduiRootConfig", function(p2, p3, p4, p5, p6)
	return {
		page = p2,
		rootConfig = p3,
		dataUpdatedTimestamp = p4,
		expectedSduiFeedItems = p5,
		customFeedStoreKey = p6
	}
end)
