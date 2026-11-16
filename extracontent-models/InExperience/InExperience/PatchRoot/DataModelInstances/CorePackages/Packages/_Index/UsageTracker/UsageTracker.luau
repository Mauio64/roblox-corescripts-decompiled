local UsageTracker = {
	isReactComponent = require(script.isReactComponent),
	trackMemberAccess = require(script.trackMemberAccess),
	getFileInfo = require(script.getFileInfo),
	getUsageGraph = 0
}
local UsageGraph = require(script.UsageGraph)
UsageTracker.getUsageGraph = UsageGraph.getUsageGraph
return UsageTracker
