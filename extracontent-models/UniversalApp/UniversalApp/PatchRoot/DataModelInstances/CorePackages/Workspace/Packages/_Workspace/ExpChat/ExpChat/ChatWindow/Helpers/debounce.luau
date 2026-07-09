return function(p1, p2) -- line: 1
	local u3 = false

	return function(...) -- line: 4
		-- upvalues: u3 (ref), p1 (copy), p2 (copy)
		if u3 then
			return
		end

		u3 = true
		p1(...)
		task.delay(p2, function() -- line: 10
			-- upvalues: u3 (ref)
			u3 = false
		end)
	end
end
