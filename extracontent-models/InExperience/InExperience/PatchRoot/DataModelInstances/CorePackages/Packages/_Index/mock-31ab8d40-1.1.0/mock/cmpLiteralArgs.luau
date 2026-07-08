local fmtArgs = require(script.Parent.fmtArgs)

return function(p1, p2) -- line: 4
	-- upvalues: fmtArgs (copy)
	if p1.n ~= p2.n then
		return false, "number of literals in " .. fmtArgs(p1) .. " does not match number of args in " .. fmtArgs(p2)
	end

	for i = 1, p1.n do
		if p1[i] ~= p2[i] then
			return false, "expected " .. fmtArgs(p1) .. ", got " .. fmtArgs(p2)
		end
	end

	return true
end
