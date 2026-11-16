local function chain(...)
	local v = { ... }
	local count = #v
	local v2 = 1
	return function()
		while v2 <= count do
			local v3 = { v[v2]() }

			if v3[1] ~= nil then
				return table.unpack(v3)
			end

			v2 += 1
		end

		return nil
	end
end

return chain
