local v5 = {}

return {
	add = function(p2)
		v5[p2] = true
	end,
	remove = function(p2)
		v5[p2] = nil
	end,
	has = function(p2): boolean
		return v5[p2] == true
	end,
	clear = function()
		v5 = {}
	end
}
