local v5 = {}

return {
	register = function(p2, p3)
		v5[p2] = p3
	end,
	resolve = function(p2)
		return v5[p2]
	end,
	destroy = function(p2)
		local v6 = v5[p2]

		if v6 then
			v5[p2] = nil
			v6:Destroy()
		end
	end,
	clear = function()
		local v6 = v5
		v5 = {}

		for k, v7 in v6 do
			v7:Destroy()
		end
	end
}
