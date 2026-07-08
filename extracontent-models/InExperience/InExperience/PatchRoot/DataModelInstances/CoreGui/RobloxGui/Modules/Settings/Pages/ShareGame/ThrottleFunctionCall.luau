return function(p1, p2) -- line: 1
	local u3 = false

	return function(...) -- line: 3
		-- upvalues: u3 (ref), p1 (copy), p2 (copy)
		if u3 then
			return
		end

		u3 = true
		task.delay(p1, function() -- line: 8
			-- upvalues: u3 (ref)
			u3 = false
		end)

		return p2(...)
	end
end
