local function handleNoYieldValidation(thread: thread, flag: boolean, ...)
	if not flag then
		local v = ...

		if typeof(v) == "string" then
			error(debug.traceback(thread, v), 2)
		else
			error(tostring(v), 2)
		end
	end

	if coroutine.status(thread) ~= "dead" then
		error(debug.traceback(thread, "Attempted to yield!"), 2)
	end

	return ...
end

local function callWithValidation(callback, ...)
	local thread = coroutine.create(callback)
	return handleNoYieldValidation(thread, coroutine.resume(thread, ...))
end

local function callWithoutValidation(callback, ...)
	return callback(...)
end

if _G.__SIGNALS_VALIDATION_ENABLED__ or _G.__DEV__ then
	return callWithValidation
end

return callWithoutValidation
