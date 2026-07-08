return function(p1: ((...any) -> ...any)) -- line: 1
	local co = coroutine.create(p1)

	return (function(p2: thread, b1: boolean, ...) -- line: 2
		if not b1 then
			return nil
		end

		if coroutine.status(p2) ~= "dead" then
			return nil
		end

		return ...
	end)(co, coroutine.resume(co))
end
