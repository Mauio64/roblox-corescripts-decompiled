local v5 = {}

return {
	register = function(p2)
		table.insert(v5, p2)

		return function()
			local index = table.find(v5, p2)

			if index then
				table.remove(v5, index)
			end
		end
	end,
	consume = function(): boolean
		local v6 = v5[#v5]

		if not v6 then
			return false
		end

		v6()
		return true
	end
}
