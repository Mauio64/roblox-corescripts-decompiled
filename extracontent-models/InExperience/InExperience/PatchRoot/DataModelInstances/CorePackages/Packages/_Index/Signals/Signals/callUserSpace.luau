local function handleNoYieldValidation(p1: thread, b1: boolean, ...) -- line: 3
	if not b1 then
		local v6 = ...

		if typeof(v6) == "string" then
			error(debug.traceback(p1, v6), 2)
		else
			error(tostring(v6), 2)
		end
	end

	if coroutine.status(p1) ~= "dead" then
		error(debug.traceback(p1, "Attempted to yield!"), 2)
	end

	return ...
end
local function callWithValidation(p2: ((...any) -> ...any), ...) -- line: 20
	-- upvalues: handleNoYieldValidation (copy)
	local co = coroutine.create(p2)

	return handleNoYieldValidation(co, coroutine.resume(co, ...))
end
local function callWithoutValidation(p3: ((...any) -> ...any), ...) -- line: 25
	return p3(...)
end

if _G.__SIGNALS_VALIDATION_ENABLED__ or _G.__DEV__ then
	return callWithValidation
end

return callWithoutValidation
