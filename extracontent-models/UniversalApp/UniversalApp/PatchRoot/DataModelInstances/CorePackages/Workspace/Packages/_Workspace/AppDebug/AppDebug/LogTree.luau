local AppDebug = script:FindFirstAncestor("AppDebug")
local AppDebugParent = AppDebug.Parent
local Dash = require(AppDebugParent.Dash)
local Lumberyak = require(AppDebugParent.Lumberyak)
local Levels = Lumberyak.Logger.Levels
local SharedSink = require(AppDebug.SharedSink)
local v7 = Lumberyak.Logger.new(nil, "root")
local timestamp = tick()
local t1 = {
	["*"] = v7
}

local function argToString(p1) -- line: 46
	-- upvalues: Dash (copy)
	if typeof(p1) == "string" then
		return p1
	end

	local mt = getmetatable(p1)

	if mt and mt.__tostring then
		return (tostring(p1))
	end

	return Dash.pretty(p1)
end

v7:setContext({
	tostring = argToString
})

local function newLogger(p2, p3) -- line: 63
	-- upvalues: Lumberyak (copy), t1 (copy)
	local v19 = Lumberyak.Logger.new(p2, p3)

	t1[p3] = v19

	return v19
end
local function createLoggerTree(s1: string) -- line: 69
	-- upvalues: v7 (copy), t1 (copy), Lumberyak (copy)
	local parts = s1:split(".")
	local s2 = ""
	local v23 = v7

	for v24, v25 in parts do
		if v25 == "" then
			error("Invalid log tag: " .. s1)
		end

		s2 = if v24 ~= 1 then s2 .. "." .. v25 else v25

		local v26 = t1[s2]

		if not v26 then
			v26 = Lumberyak.Logger.new(v23, s2)
			t1[s2] = v26
		end

		v23 = v26
	end

	return v23
end
local function parseTag(s3: string) -- line: 92
	-- upvalues: Dash (copy), Levels (copy)
	local parts = s3:split(":")

	if #parts ~= 2 then
		warn("Invalid LogTree value: " .. s3)

		return nil, nil
	end

	local v30, v31 = table.unpack(parts)

	return Dash.trim(v30), Levels.fromString(v31)
end
local function splitNonEmpty(s4: string) -- line: 123
	-- upvalues: Dash (copy)
	local v45 = Dash.splitOn(s4, "%s+")

	return Dash.filter(v45, function(p4) -- line: 125
		return #p4 > 0
	end)
end

return {
	logger = function(s5: string) -- line: 88
		-- upvalues: t1 (copy), createLoggerTree (copy)
		return t1[s5] or createLoggerTree(s5)
	end,
	formatLog = function(p5, p6, p7) -- line: 103
		-- upvalues: timestamp (copy)
		local level = p6.level
		local v36 = string.format("%s [%s] %s", level:sub(1, 1), p6.loggerName, p5)

		if p7 then
			local v37 = tick() - timestamp

			v36 = string.format("[%0.3f] %s", v37, v36)
		end

		return v36
	end,
	logToConsole = function(_, p9, p10) -- line: 113
		-- upvalues: Levels (copy)
		local level = p10.level
		local level2 = p10.level
		local v43 = string.format("%s [%s] %s", level2:sub(1, 1), p10.loggerName, p9)

		if level == Levels.Error or level == Levels.Warning then
			warn(v43)

			return
		end

		print(v43)
	end,
	setLogTags = function(s6: string, p11) -- line: 130
		-- upvalues: SharedSink (copy), Dash (copy), Levels (copy), t1 (copy), createLoggerTree (copy)
		local v48 = SharedSink.new(p11)
		local v49 = Dash.splitOn(s6, "%s+")

		for _, v51 in (Dash.filter(v49, function(p12) -- line: 125
			return #p12 > 0
		end)) do
			local parts = v51:split(":")
			local v53, v54

			if #parts ~= 2 then
				warn("Invalid LogTree value: " .. v51)
				v53 = nil
				v54 = nil
			else
				local v55, v56 = table.unpack(parts)

				v53 = Dash.trim(v55)
				v54 = Levels.fromString(v56)
			end

			if v53 ~= nil then
				local str = tostring(v53);

				(t1[str] or createLoggerTree(str)):addSink((v48:newSink(v54)))
			end
		end
	end
}
