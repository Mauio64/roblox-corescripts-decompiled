local function is(p, p2): boolean
	if p == p2 and (p ~= 0 or 1 / p == 1 / p2) then
		return true
	elseif p == p then
		return false
	else
		return p2 ~= p2
	end
end

return is
