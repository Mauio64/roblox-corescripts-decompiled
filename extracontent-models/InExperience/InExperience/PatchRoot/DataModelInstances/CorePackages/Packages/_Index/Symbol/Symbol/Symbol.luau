return {
	new = function(p: string?)
		local v = newproxy(true)

		local v2 = not p and "Symbol()" or ("Symbol(%s)"):format(p)

		getmetatable(v).__tostring = function()
			return v2
		end

		return v
	end
}
