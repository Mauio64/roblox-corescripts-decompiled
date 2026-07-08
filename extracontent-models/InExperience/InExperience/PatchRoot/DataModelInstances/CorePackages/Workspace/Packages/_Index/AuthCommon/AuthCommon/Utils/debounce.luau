return function(p1, n1: number?) -- line: 1
	local n2 = 0

	return function(...) -- line: 3
		-- upvalues: n2 (ref), n1 (copy), p1 (copy)
		local t1 = { ... }
		local v5 = time()

		n2 = v5
		task.delay(n1, function() -- line: 7
			-- upvalues: n2 (ref), v5 (copy), p1 (copy), t1 (copy)
			if n2 == v5 then
				p1(unpack(t1))
			end
		end)
	end
end
