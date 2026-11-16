local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local ArgCheck = require(parent.ArgCheck)

local defineFastInt = game:DefineFastInt("LuaAppJoinGameFailureInfluxHundredthsPercentage", 0)

return function(object, p, options)
	ArgCheck.isType(p, "string", "documentName")
	object:reportSeries(p, options or {}, defineFastInt)
end
