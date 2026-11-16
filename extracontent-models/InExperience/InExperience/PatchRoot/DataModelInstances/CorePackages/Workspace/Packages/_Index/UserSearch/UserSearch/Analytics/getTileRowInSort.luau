return function(p: number?, p2: number?, p3: number?)
	if p and p2 and p3 and p3 ~= 0 then
		return p2 + math.ceil(p / p3) - 1
	end

	return nil
end
