local v5 = nil

return {
	register = function(p2)
		v5 = p2
		return function()
			if v5 == p2 then
				v5 = nil
			end
		end
	end,
	get = function()
		return v5
	end
}
