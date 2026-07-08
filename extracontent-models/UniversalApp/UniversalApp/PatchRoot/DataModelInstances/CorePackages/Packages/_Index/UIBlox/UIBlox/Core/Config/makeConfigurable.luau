local Config = require(script.Parent.Config)

local function trimTrailingNewline(p1) -- line: 4
	if p1:sub(-1, -1) == "\n" then
		return p1:sub(1, -2)
	end

	return p1
end

return function(p2, p3, p4) -- line: 12
	-- upvalues: Config (copy)
	if typeof(p3) ~= "string" then
		error("Bad argument #2 - expected a string for the name of the library")
	end

	if typeof(p4) ~= "table" then
		error("Bad argument #3 - expected a default config table for the library")
	end

	local t1 = {}
	local v8 = Config.new(p4)

	function t1.init(p5) -- line: 23
		-- upvalues: t1 (copy), v8 (copy), p2 (copy), p3 (copy)
		setmetatable(t1, nil)

		if p5 then
			v8.set(p5)
		end

		t1.Config = v8.get()

		local v10 = p2(t1.Config)

		for k, v in pairs(v10) do
			t1[k] = v
		end

		local trace = debug.traceback()
		local v14 = if trace:sub(-1, -1) ~= "\n" then trace else trace:sub(1, -2)

		function t1.init(p6) -- line: 38
			-- upvalues: p5 (copy), p3 (copy), v14 (copy)
			if p6 == p5 then
				return
			end

			local trace2 = debug.traceback()
			local v22 = if trace2:sub(-1, -1) ~= "\n" then trace2 else trace2:sub(1, -2)

			warn(string.format("%s has already been configured\nFirst init traceback:\n%s\nCurrent init traceback:\n%s", p3, v14, v22))
		end

		if _G.__UIBLOX_TRACK_USAGE__ then
			return (setmetatable(t1, (getmetatable(v10))))
		end

		return (setmetatable(t1, {
			__index = function(_, p8) -- line: 63
				-- upvalues: p3 (copy)
				local v25 = ("%q (%s) is not a valid member of %s"):format(tostring(p8), typeof(p8), p3)

				error(v25, 2)
			end,
			__newindex = function(_, p10, _) -- line: 69
				-- upvalues: p3 (copy)
				local v29 = ("%q (%s) is not a valid member of %s"):format(tostring(p10), typeof(p10), p3)

				error(v29, 2)
			end
		}))
	end

	return (setmetatable(t1, {
		__index = function(_, _) -- line: 78
			-- upvalues: p3 (copy)
			error(("You must call %s.init(config) before using it!"):format(p3), 2)
		end,
		__newindex = function(_, _, _) -- line: 82
			-- upvalues: p3 (copy)
			error(("You must call %s.init(config) before using it!"):format(p3), 2)
		end
	}))
end
