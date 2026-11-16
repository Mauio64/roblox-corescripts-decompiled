local function resultHandler(thread, p, ...)
	if not p then
		local v = ...
		error(debug.traceback(thread, v), 2)
	end

	if coroutine.status(thread) ~= "dead" then
		error(debug.traceback(thread, "Attempted to yield inside changed event!"), 2)
	end

	return ...
end

local function NoYield(callback, ...)
	local thread = coroutine.create(callback)

	return resultHandler(thread, coroutine.resume(thread, ...))
end

return NoYield
