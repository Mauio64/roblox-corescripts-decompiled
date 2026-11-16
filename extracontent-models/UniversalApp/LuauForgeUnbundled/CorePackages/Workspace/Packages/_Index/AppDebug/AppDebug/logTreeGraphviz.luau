local LogTree = require("@game/CorePackages/Workspace/Packages/_Index/AppDebug/AppDebug/LogTree")
local levels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppDebug/Lumberyak").Logger.Levels

local v5 = {
	[levels.Error] = "pink",
	[levels.Warning] = "orange",
	[levels.Info] = "yellow",
	[levels.Debug] = "cyan",
	[levels.Trace] = "green"
}

local v6 = {
	[levels.Error] = 1,
	[levels.Warning] = 2,
	[levels.Info] = 3,
	[levels.Debug] = 4,
	[levels.Trace] = 5
}

local function maxLevelToGraphvizAttr(p2)
	local v7 = v5[p2]
	return v7 and string.format(" fillcolor=%s style=filled", v7) or ""
end

local function getLevelRank(p2)
	return v6[p2] or 0
end

local function maxLogLevel(p2, p3)
	return (v6[p2] or 0) > (v6[p3] or 0) and p2 or p3
end

local function dfsGraphviz(data, p2)
	local v7 = tostring(data.name)

	for k, sink in data.sinks do
		v7 ..= "\\n(sink: " .. tostring(sink.maxLevel) .. ")"
		local maxLevel = sink.maxLevel

		if not ((v6[p2] or 0) > (v6[maxLevel] or 0) and p2) then
			p2 = maxLevel
		end
	end

	local format = string.format
	local name = data.name
	local v9 = v5[p2]
	local v10 = "" .. format(
		"\"%s\" [label=\"%s\"%s];\n",
		name,
		v7,
		v9 and string.format(" fillcolor=%s style=filled", v9) or ""
	)

	for k, child in data.children do
		v10 = (v10 .. string.format("\"%s\" -> \"%s\"\n", tostring(k.name), data.name)) .. dfsGraphviz(k, p2)
	end

	return v10
end

return function()
	return "digraph {\n" .. dfsGraphviz((LogTree.logger("*"))) .. "}\n"
end
