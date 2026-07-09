return function(n1: number?, n2: number?, n3: number?) -- line: 1
	if not n1 or (not n2 or not n3 or n3 == 0) then
		return nil
	end

	return n2 + math.ceil(n1 / n3) - 1
end
