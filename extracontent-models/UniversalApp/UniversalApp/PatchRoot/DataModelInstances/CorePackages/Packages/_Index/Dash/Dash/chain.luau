local function chain(...) -- line: 14
	local t1 = { ... }
	local v3 = #t1
	local n1 = 1

	return function() -- line: 18
		-- upvalues: n1 (ref), v3 (copy), t1 (copy)
		while n1 <= v3 do
			local t2 = { t1[n1]() }

			if t2[1] ~= nil then
				return table.unpack(t2)
			end

			n1 += 1
		end

		return nil
	end
end

return chain
