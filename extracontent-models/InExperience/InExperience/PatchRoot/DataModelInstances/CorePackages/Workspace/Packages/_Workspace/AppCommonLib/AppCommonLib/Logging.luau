game:DefineFastFlag("LoggingRethrowUsingError", false)

local function GetFFlagLoggingRethrowUsingError() -- line: 8
	return game:GetFastFlag("LoggingRethrowUsingError")
end

local u2 = true
local t1 = {}

local function createLogInfo() -- line: 15
	local t2 = {
		warnings = {}
	}

	setmetatable(t2, {
		__tostring = function(p1) -- line: 21
			return ("LogInfo\n\tWarnings (%d):\n\t\t%s"):format(#p1.warnings, table.concat(p1.warnings, "\n\t\t"))
		end
	})

	return t2
end

return {
	capture = function(p2) -- line: 31
		-- upvalues: createLogInfo (copy), u2 (ref), t1 (copy)
		local v7 = createLogInfo()
		local v8 = u2

		u2 = false
		t1[v7] = true

		local ok, result = pcall(p2)

		t1[v7] = nil
		u2 = v8

		if game:GetFastFlag("LoggingRethrowUsingError") then
			if not ok then
				error(result)

				return v7
			end
		else
			assert(ok, result)
		end

		return v7
	end,
	warn = function(p3) -- line: 54
		-- upvalues: t1 (copy), u2 (ref)
		for k in pairs(t1) do
			table.insert(k.warnings, p3)
		end

		if u2 then
			warn(p3)
		end
	end
}
