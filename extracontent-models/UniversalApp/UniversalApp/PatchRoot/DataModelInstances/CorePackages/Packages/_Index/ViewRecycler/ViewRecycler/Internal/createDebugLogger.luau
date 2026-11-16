local ViewRecycler = script:FindFirstAncestor("ViewRecycler")

local DebugFlags = require(ViewRecycler.Internal.DebugFlags)

local function createDebugLogger(p: string)
	return function(formatString, ...)
		if not DebugFlags.shouldLog then
			return
		end

		if typeof(formatString) == "string" then
			print(`[{p}] {string.format(formatString, ...)}`)
		else
			print(`[{p}]`, formatString(...))
		end
	end
end

return createDebugLogger
