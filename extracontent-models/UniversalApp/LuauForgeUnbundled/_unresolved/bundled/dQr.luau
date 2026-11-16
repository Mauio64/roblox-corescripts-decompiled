local v5 = {}

return {
	add = function(p2, p3)
		local v6 = {}
		local v7 = v5[p2] or {}
		table.insert(v7, { token = v6, handlers = p3 })
		v5[p2] = v7

		return function()
			local v8 = v5[p2]

			if v8 == nil then
				return
			end

			for k, v9 in v8 do
				if v9.token == v6 then
					table.remove(v8, k)
					break
				end
			end

			if #v8 == 0 then
				v5[p2] = nil
			end
		end
	end,
	get = function(p2)
		local v6 = if p2 then v5[p2] else nil

		if v6 == nil then
			return nil
		end

		for i = #v6, 1, -1 do
			if v6[i].handlers.isFocused() then
				return v6[i].handlers
			end
		end

		return v6[#v6].handlers
	end
}
