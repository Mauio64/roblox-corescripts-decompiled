local function resultHandler(p1: thread, b1: boolean, ...) -- line: 28
	if not b1 then
		local v5 = ...

		if typeof(v5) == "string" then
			error(debug.traceback(p1, v5), 3)
		else
			error(v5, 3)
		end
	end

	if coroutine.status(p1) ~= "dead" then
		error(debug.traceback(p1, "\nYielding is not allowed inside components or hooks.\n\nYielding in a component stalls React's scheduler, freezing the entire application until the yield completes.\nCheck the stack trace below to find the exact location of the yield.\n\nFor more details and how to fix this, see: go/react-yield-error\n"), 3)
	end

	return ...
end
local function NoYield(p2: ((...any) -> ...any), ...) -- line: 52
	-- upvalues: resultHandler (copy)
	local co = coroutine.create(p2)

	return resultHandler(co, coroutine.resume(co, ...))
end

return NoYield
