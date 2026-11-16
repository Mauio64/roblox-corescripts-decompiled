return function(p, p2, p3): boolean
	if p and p2 and p3 and p3 ~= "" and p[p3] and p2[p3] and p[p3] == p2[p3] then
		return true
	end

	return false
end
