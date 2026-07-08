local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.SduiCoreSystem)

return makeActionCreator(script.Name, function(s1: string, p1, n1: number, t1: {[any]: any}?, s2: string?) -- line: 15
	return {
		page = s1,
		rootConfig = p1,
		dataUpdatedTimestamp = n1,
		expectedSduiFeedItems = t1,
		customFeedStoreKey = s2
	}
end)
