local fmtArgs = require(script.Parent.fmtArgs)

return function(p, p2)
	if p.n ~= p2.n then
		return false, "number of literals in " .. fmtArgs(p) .. " does not match number of args in " .. fmtArgs(p2)
	end

	for i = 1, p.n do
		if p[i] ~= p2[i] then
			return false, "expected " .. fmtArgs(p) .. ", got " .. fmtArgs(p2)
		end
	end

	return true
end
