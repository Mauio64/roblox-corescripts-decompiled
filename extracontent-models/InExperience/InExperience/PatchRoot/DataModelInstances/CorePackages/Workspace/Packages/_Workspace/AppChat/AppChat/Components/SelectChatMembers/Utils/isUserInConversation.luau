return function(p, p2): boolean
	for _, participant in pairs(p2.participants) do
		if p == participant then
			return true
		end
	end

	return false
end
