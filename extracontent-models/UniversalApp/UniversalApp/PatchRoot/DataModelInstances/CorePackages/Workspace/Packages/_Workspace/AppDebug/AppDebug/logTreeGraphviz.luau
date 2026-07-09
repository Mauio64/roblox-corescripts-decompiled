local AppDebug = script:FindFirstAncestor("AppDebug")
local AppDebugParent = AppDebug.Parent
local LogTree = require(AppDebug.LogTree)
local Levels = require(AppDebugParent.Lumberyak).Logger.Levels
local t1 = {
	[Levels.Error] = "pink",
	[Levels.Warning] = "orange",
	[Levels.Info] = "yellow",
	[Levels.Debug] = "cyan",
	[Levels.Trace] = "green"
}
local t2 = {
	[Levels.Error] = 1,
	[Levels.Warning] = 2,
	[Levels.Info] = 3,
	[Levels.Debug] = 4,
	[Levels.Trace] = 5
}

local function maxLevelToGraphvizAttr(p1) -- line: 28
	-- upvalues: t1 (copy)
	local v12 = t1[p1]

	return v12 and string.format(" fillcolor=%s style=filled", v12) or ""
end
local function getLevelRank(p2) -- line: 33
	-- upvalues: t2 (copy)
	return t2[p2] or 0
end
local function maxLogLevel(p3, p4) -- line: 37
	-- upvalues: t2 (copy)
	return (t2[p3] or 0) > (t2[p4] or 0) and p3 or p4
end
local function dfsGraphviz(p5, p6) -- line: 41
	-- upvalues: t2 (copy), t1 (copy), dfsGraphviz (copy)
	local str = tostring(p5.name)

	for _, v20 in p5.sinks do
		str ..= "\\n(sink: " .. tostring(v20.maxLevel) .. ")"

		local maxLevel = v20.maxLevel

		p6 = (t2[p6] or 0) > (t2[maxLevel] or 0) and p6 or maxLevel
	end

	local format = string.format
	local name = p5.name
	local v24 = t1[p6]
	local v25 = "" .. format("\"%s\" [label=\"%s\"%s];\n", name, str, v24 and string.format(" fillcolor=%s style=filled", v24) or "")

	for v26, _ in p5.children do
		v25 = (v25 .. string.format("\"%s\" -> \"%s\"\n", tostring(v26.name), p5.name)) .. dfsGraphviz(v26, p6)
	end

	return v25
end

return function() -- line: 56
	-- upvalues: LogTree (copy), dfsGraphviz (copy)
	local v28 = LogTree.logger("*")

	return "digraph {\n" .. dfsGraphviz(v28) .. "}\n"
end
