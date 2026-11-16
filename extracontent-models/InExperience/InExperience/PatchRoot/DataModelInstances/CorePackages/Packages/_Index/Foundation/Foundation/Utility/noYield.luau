return function(callback)
	local thread = coroutine.create(callback)
	return (function(thread2: thread, flag: boolean, ...)
		if not flag then
			return nil
		end

		if coroutine.status(thread2) == "dead" then
			return ...
		end

		return nil
	end)(thread, coroutine.resume(thread))
end
