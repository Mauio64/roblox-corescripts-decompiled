return function(p1, n1: number?) -- line: 1
	local u3 = false
	local v4 = n1 or 1

	return function(...) -- line: 4
		-- upvalues: u3 (ref), p1 (copy), v4 (copy)
		if u3 then
			return
		end

		u3 = true
		p1(...)
		task.delay(v4, function() -- line: 10
			-- upvalues: u3 (ref)
			u3 = false
		end)
	end
end
