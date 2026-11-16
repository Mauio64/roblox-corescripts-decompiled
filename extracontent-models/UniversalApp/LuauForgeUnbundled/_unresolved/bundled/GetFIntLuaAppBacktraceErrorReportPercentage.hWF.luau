game:DefineFastInt("LuaAppBacktraceErrorReportPercentage", 5)

local v5 = math.random(1, 100)

return function(): boolean
	return v5 <= math.clamp(game:GetFastInt("LuaAppBacktraceErrorReportPercentage"), 0, 100)
end
