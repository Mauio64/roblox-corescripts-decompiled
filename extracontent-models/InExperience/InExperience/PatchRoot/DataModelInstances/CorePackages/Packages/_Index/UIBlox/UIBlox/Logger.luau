local ParentParent = script.Parent.Parent
local Lumberyak = require(ParentParent.Lumberyak)
local Logger = Lumberyak.Logger
local t1 = {
	maxLevel = Logger.Levels.Info,
	log = function(_, p2, p3) -- line: 18
		-- upvalues: Logger (copy)
		if p3.level == Logger.Levels.Error or p3.level == Logger.Levels.Warning then
			warn(p2)

			return
		end

		print(p2)
	end
}
local v5 = Lumberyak.Logger.new(nil, "UIBlox")

v5:setContext({
	prefix = "[{loggerName} - {level}] - "
})
v5:addSink(t1)

local t2 = {
	uibloxSink = t1,
	setLogLevel = function(p4, s1: string) -- line: 38
		p4.uibloxSink.maxLevel = s1
		p4:addSink(p4.uibloxSink)
	end,
	enableTraceLog = function(p5) -- line: 42
		-- upvalues: Logger (copy)
		p5:setLogLevel(Logger.Levels.Trace)
	end
}

setmetatable(t2, {
	__index = v5
})

return t2
