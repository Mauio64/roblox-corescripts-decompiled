local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AppDebug/Dash")
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/AppDebug/Lumberyak")
local levels = Lumberyak.Logger.Levels
local SharedSink = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/SharedSink")

local logger = Lumberyak.Logger.new(nil, "root")

local lastTime = tick()

local v5 = { ["*"] = logger }

local function argToString(value)
	if typeof(value) == "string" then
		return value
	end

	local metatable = getmetatable(value)

	if metatable and metatable.__tostring then
		return (tostring(value))
	end

	return Dash.pretty(value)
end

logger:setContext({ tostring = argToString })

local function newLogger(p2, p3)
	local logger2 = Lumberyak.Logger.new(p2, p3)
	v5[p3] = logger2
	return logger2
end

local function createLoggerTree(value)
	local parts = value:split(".")

	local loggerTree = logger
	local v6 = ""

	for k, part in parts do
		if part == "" then
			error("Invalid log tag: " .. value)
		end

		v6 = if k == 1 then part else v6 .. "." .. part

		local v7 = v5[v6]

		if not v7 then
			v7 = Lumberyak.Logger.new(loggerTree, v6)
			v5[v6] = v7
		end

		loggerTree = v7
	end

	return loggerTree
end

local function parseTag(value)
	local parts = value:split(":")

	if #parts == 2 then
		local v6, v7 = table.unpack(parts)
		return Dash.trim(v6), levels.fromString(v7)
	end

	warn("Invalid LogTree value: " .. value)
	return nil, nil
end

local function splitNonEmpty(p2)
	local splitOn = Dash.splitOn(p2, "%s+")
	return Dash.filter(splitOn, function(list): boolean
		return #list > 0
	end)
end

return {
	logger = function(p2)
		return v5[p2] or createLoggerTree(p2)
	end,
	formatLog = function(p2, p3, p4)
		local level = p3.level
		local v6 = string.format("%s [%s] %s", level:sub(1, 1), p3.loggerName, p2)

		if p4 then
			local v7 = tick() - lastTime
			v6 = string.format("[%0.3f] %s", v7, v6)
		end

		return v6
	end,
	logToConsole = function(p2, p3, p4)
		local level = p4.level
		local level2 = p4.level
		local v6 = string.format("%s [%s] %s", level2:sub(1, 1), p4.loggerName, p3)

		if level == levels.Error or level == levels.Warning then
			warn(v6)
		else
			print(v6)
		end
	end,
	setLogTags = function(p2, p3)
		local v6 = SharedSink.new(p3)
		local splitOn = Dash.splitOn(p2, "%s+")
		local filtered = Dash.filter(splitOn, function(list): boolean
			return #list > 0
		end)

		for k, v7 in filtered do
			local parts = v7:split(":")
			local trimmed, v8

			if #parts == 2 then
				local v9, v10 = table.unpack(parts)
				trimmed = Dash.trim(v9)
				v8 = levels.fromString(v10)
			else
				warn("Invalid LogTree value: " .. v7)
			end

			if trimmed == nil then
				continue
			end

			local v9 = tostring(trimmed);
			(v5[v9] or createLoggerTree(v9)):addSink((v6:newSink(v8)))
		end
	end
}
