local parent = script:FindFirstAncestor("Foundation").Parent
local Lumberyak = require(parent.Lumberyak)

local logger = Lumberyak.Logger
local foundationSink = {
	maxLevel = logger.Levels.Info,
	log = function(_, p, p2)
		if p2.level == logger.Levels.Error or p2.level == logger.Levels.Warning then
			warn(p)
		else
			print(p)
		end
	end
}

local function fn(p) -- 1 equivalent call inferred from this helper
	local logger2 = Lumberyak.Logger.new(nil, p)
	logger2:setContext({ prefix = "[{loggerName} - {level}] - " })
	logger2:addSink(foundationSink)
	return logger2
end

local logger2 = fn("Foundation") -- inferred equivalent call
local Logger = {
	foundationSink = foundationSink,
	setLogLevel = function(self, maxLevel: string)
		self.foundationSink.maxLevel = maxLevel
		self:addSink(self.foundationSink)
	end,
	enableTraceLog = function(self)
		self:setLogLevel(logger.Levels.Trace)
	end
}

setmetatable(Logger, { __index = logger2 })

return Logger
