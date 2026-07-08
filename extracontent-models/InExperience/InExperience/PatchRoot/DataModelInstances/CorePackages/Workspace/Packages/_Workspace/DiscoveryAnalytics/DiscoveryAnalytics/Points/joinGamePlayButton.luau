local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local ArgCheck = require(Parent.ArgCheck)
local v3 = game:DefineFastInt("LuaAppJoinGameFailureInfluxHundredthsPercentage", 0)

return function(p1, p2, p3) -- line: 8
	-- upvalues: ArgCheck (copy), v3 (copy)
	local v7 = p3 or {}

	ArgCheck.isType(p2, "string", "documentName")
	p1:reportSeries(p2, v7, v3)
end
