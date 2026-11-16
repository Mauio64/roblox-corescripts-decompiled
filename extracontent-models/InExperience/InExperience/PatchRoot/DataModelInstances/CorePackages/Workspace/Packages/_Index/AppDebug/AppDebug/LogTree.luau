local AppDebug = script:FindFirstAncestor("AppDebug")
local parent = AppDebug.Parent
local Dash = require(parent.Dash)
local Lumberyak = require(parent.Lumberyak)
local Levels = Lumberyak.Logger.Levels
local SharedSink = require(AppDebug.SharedSink)

local logger = Lumberyak.Logger.new(nil, "root")

local lastTime = tick()

local v = { ["*"] = logger }

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

local function newLogger(p, p2)
	local logger2 = Lumberyak.Logger.new(p, p2)
	v[p2] = logger2
	return logger2
end

local function createLoggerTree(value: string)
	local parts = value:split(".")

	local loggerTree = logger
	local v2 = ""

	for k, part in parts do
		if part == "" then
			error("Invalid log tag: " .. value)
		end

		if k == 1 then
			v2 = part
		else
			v2 ..= "." .. part
		end

		local v3 = v[v2]

		if not v3 then
			v3 = Lumberyak.Logger.new(loggerTree, v2)
			v[v2] = v3
		end

		loggerTree = v3
	end

	return loggerTree
end

local function logger2(p: string) -- 1 equivalent call inferred from this helper
	return v[p] or createLoggerTree(p)
end

local function parseTag(value: string)
	local parts = value:split(":")

	if #parts == 2 then
		local v2, v3 = table.unpack(parts)
		return Dash.trim(v2), Levels.fromString(v3)
	end

	warn("Invalid LogTree value: " .. value)
	return nil, nil
end

local function formatLog(p, p2, p3) -- 1 equivalent call inferred from this helper
	local level = p2.level
	local v2 = string.format("%s [%s] %s", level:sub(1, 1), p2.loggerName, p)

	if p3 then
		local v3 = tick() - lastTime
		return (string.format("[%0.3f] %s", v3, v2))
	end

	return v2
end

local function splitNonEmpty(p: string)
	local splitOn = Dash.splitOn(p, "%s+")
	return Dash.filter(splitOn, function(list): boolean
		return #list > 0
	end)
end

local LogTree = {}
LogTree.logger = logger2
LogTree.formatLog = formatLog

function LogTree.logToConsole(_, p, p2)
	local level = p2.level
	local v2 = formatLog(p, p2) -- inferred equivalent call

	if level == Levels.Error or level == Levels.Warning then
		warn(v2)
	else
		print(v2)
	end
end

function LogTree.setLogTags(p: string, p2)
	local v2 = SharedSink.new(p2)
	local splitOn = Dash.splitOn(p, "%s+")
	local filtered = Dash.filter(splitOn, function(list): boolean
		return #list > 0
	end)

	for _, v3 in filtered do
		local parts = v3:split(":")
		local trimmed, v4

		if #parts == 2 then
			local v5, v6 = table.unpack(parts)
			trimmed = Dash.trim(v5)
			v4 = Levels.fromString(v6)
		else
			warn("Invalid LogTree value: " .. v3)
		end

		if trimmed ~= nil then
			logger2(tostring(trimmed)):addSink((v2:newSink(v4))) -- inferred equivalent call
		end
	end
end

return LogTree
