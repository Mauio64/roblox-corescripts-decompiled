local function resultHandler(p1, p2, ...) -- line: 10
	if not p2 then
		error(..., 2)
	end

	if coroutine.status(p1) ~= "dead" then
		error(debug.traceback(p1, "Attempted to yield inside Changed event!"), 2)
	end

	return ...
end
local function NoYield(p3, ...) -- line: 23
	-- upvalues: resultHandler (copy)
	local co = coroutine.create(p3)

	return resultHandler(co, coroutine.resume(co, ...))
end

return NoYield
