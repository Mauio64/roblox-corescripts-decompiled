return {
	deprecate = function(p1, p2, p3) -- line: 4
		return function(...) -- line: 5
			-- upvalues: p2 (copy), p3 (copy), p1 (copy)
			if p2 then
				warn(("[http] %s deprecated in version %s. See documentation at http://requests.paric.xyz/"):format(p3, p2 or "Function"))
			else
				warn(("[http] %s deprecated. See documentation at http://requests.paric.xyz/"):format(p3 or "Function"))
			end

			return p1(...)
		end
	end
}
