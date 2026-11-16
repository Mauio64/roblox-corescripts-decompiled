return function(value: string, p: number, p2: number?)
	if p2 and p2 <= 0 then
		return ""
	end

	local v

	if p2 then
		v = p + p2 - 1 or nil
	end

	return (string.sub(value, p, v))
end
