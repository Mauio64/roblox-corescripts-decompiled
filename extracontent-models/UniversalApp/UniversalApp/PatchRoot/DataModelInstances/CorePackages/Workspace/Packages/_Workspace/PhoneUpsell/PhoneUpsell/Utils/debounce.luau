return function(p1, p2) -- line: 2
	local n1 = 0

	return function(...) -- line: 4
		-- upvalues: n1 (ref), p2 (copy), p1 (copy)
		local t1 = { ... }
		local v5 = time()

		n1 = v5
		delay(p2, function() -- line: 8
			-- upvalues: n1 (ref), v5 (copy), p1 (copy), t1 (copy)
			if n1 == v5 then
				p1(unpack(t1))
			end
		end)
	end
end
