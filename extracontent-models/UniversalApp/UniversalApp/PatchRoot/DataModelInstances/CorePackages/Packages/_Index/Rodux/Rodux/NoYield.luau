local function resultHandler(p1, p2, ...) -- line: 12
	if not p2 then
		error(debug.traceback(p1, (...)), 2)
	end

	if coroutine.status(p1) ~= "dead" then
		error(debug.traceback(p1, "Attempted to yield inside changed event!"), 2)
	end

	return ...
end
local function NoYield(p3, ...) -- line: 25
	-- upvalues: resultHandler (copy)
	local co = coroutine.create(p3)

	return resultHandler(co, coroutine.resume(co, ...))
end

return NoYield
