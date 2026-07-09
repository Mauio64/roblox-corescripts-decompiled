return function(p1, p2) -- line: 7
	local n1 = 0

	for _, child in pairs(p1:GetChildren()) do
		if not p2 or child:IsA(p2) then
			n1 += 1
		end
	end

	return n1
end
