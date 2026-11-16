local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/ArgCheck")

local defineFastInt = game:DefineFastInt("LuaAppJoinGameFailureInfluxHundredthsPercentage", 0)

return function(object, p2, options)
	ArgCheck.isType(p2, "string", "documentName")
	object:reportSeries(p2, options or {}, defineFastInt)
end
