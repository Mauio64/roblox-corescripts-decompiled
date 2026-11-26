return function(p2, p3): boolean
	for k, participant in pairs(p3.participants) do
		if p2 == participant then
			return true
		end
	end

	return false
end
