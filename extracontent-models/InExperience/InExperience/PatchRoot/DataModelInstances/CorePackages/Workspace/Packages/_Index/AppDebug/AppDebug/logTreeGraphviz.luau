local AppDebug = script:FindFirstAncestor("AppDebug")
local parent = AppDebug.Parent
local LogTree = require(AppDebug.LogTree)
local Lumberyak = require(parent.Lumberyak)

local Levels = Lumberyak.Logger.Levels

local v = {
	[Levels.Error] = "pink",
	[Levels.Warning] = "orange",
	[Levels.Info] = "yellow",
	[Levels.Debug] = "cyan",
	[Levels.Trace] = "green"
}

local v2 = {
	[Levels.Error] = 1,
	[Levels.Warning] = 2,
	[Levels.Info] = 3,
	[Levels.Debug] = 4,
	[Levels.Trace] = 5
}

local function maxLevelToGraphvizAttr(p) -- 1 equivalent call inferred from this helper
	local v3 = v[p]
	return v3 and string.format(" fillcolor=%s style=filled", v3) or ""
end

local function getLevelRank(p) -- 4 equivalent calls inferred from this helper
	return v2[p] or 0
end

local function maxLogLevel(p, p2)
	return getLevelRank(p) > getLevelRank(p2) and p or p2 -- inferred equivalent call
end

local function dfsGraphviz(data, p)
	local v3 = tostring(data.name)

	for _, sink in data.sinks do
		v3 ..= "\\n(sink: " .. tostring(sink.maxLevel) .. ")"
		local maxLevel = sink.maxLevel

		if not (getLevelRank(p) > getLevelRank(maxLevel) and p) then -- inferred equivalent call
			p = maxLevel
		end
	end

	local v4 = "" .. string.format("\"%s\" [label=\"%s\"%s];\n", data.name, v3, maxLevelToGraphvizAttr(p)) -- inferred equivalent call

	for k, _ in data.children do
		v4 = (v4 .. string.format("\"%s\" -> \"%s\"\n", tostring(k.name), data.name)) .. dfsGraphviz(k, p)
	end

	return v4
end

return function()
	return "digraph {\n" .. dfsGraphviz((LogTree.logger("*"))) .. "}\n"
end
