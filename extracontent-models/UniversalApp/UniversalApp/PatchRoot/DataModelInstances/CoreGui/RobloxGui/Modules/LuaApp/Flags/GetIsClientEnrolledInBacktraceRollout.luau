game:DefineFastInt("LuaAppBacktraceErrorReportPercentage", 5)

local v1 = math.random(1, 100)

return function() -- line: 5
	-- upvalues: v1 (copy)
	return math.clamp(game:GetFastInt("LuaAppBacktraceErrorReportPercentage"), 0, 100) >= v1
end
