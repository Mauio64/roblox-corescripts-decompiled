local fmtArgs = require(script.Parent.fmtArgs)

return function(p, p2)
	if p.n ~= p2.n then
		return false, "number of args in " .. fmtArgs(p2) .. " does not match number of predicates"
	end

	for i = 1, p2.n do
		if not p[i](p2[i]) then
			return false, fmtArgs(p2) .. " does not match predicates at position " .. i
		end
	end

	return true
end
