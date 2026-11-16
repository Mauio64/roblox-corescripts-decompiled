return function(p)
	if p == nil or p.errors == nil or not (p.errors[1] and p.errors[1].fieldData) then
		return ""
	end

	return p.errors[1].fieldData
end
