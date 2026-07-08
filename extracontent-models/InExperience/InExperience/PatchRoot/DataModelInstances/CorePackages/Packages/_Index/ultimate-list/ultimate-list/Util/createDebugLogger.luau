local ancestor = script:FindFirstAncestor("ultimate-list")
local DebugFlags = require(ancestor.DebugFlags)

local function createDebugLogger(s1: string) -- line: 7
	-- upvalues: DebugFlags (copy)
	return function(p1, ...) -- line: 8
		-- upvalues: DebugFlags (copy), s1 (copy)
		if not DebugFlags.shouldLog then
			return
		end

		if typeof(p1) == "string" then
			print(`[{ s1 }] { string.format(p1, ...) }`)

			return
		end

		print(`[{ s1 }]`, p1(...))
	end
end

return createDebugLogger
