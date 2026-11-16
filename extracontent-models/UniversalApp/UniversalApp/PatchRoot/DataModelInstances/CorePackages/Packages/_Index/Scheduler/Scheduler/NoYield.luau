local function resultHandler(thread: thread, flag: boolean, ...)
	if not flag then
		local v = ...

		if typeof(v) == "string" then
			error(debug.traceback(thread, v), 3)
		else
			error(v, 3)
		end
	end

	if coroutine.status(thread) ~= "dead" then
		error(
			debug.traceback(
				thread,
				"\nYielding is not allowed inside components or hooks.\n\nYielding in a component stalls React's scheduler, freezing the entire application until the yield completes.\nCheck the stack trace below to find the exact location of the yield.\n\nFor more details and how to fix this, see: go/react-yield-error\n"
			),
			3
		)
	end

	return ...
end

local function NoYield(callback, ...)
	local thread = coroutine.create(callback)
	return resultHandler(thread, coroutine.resume(thread, ...))
end

return NoYield
