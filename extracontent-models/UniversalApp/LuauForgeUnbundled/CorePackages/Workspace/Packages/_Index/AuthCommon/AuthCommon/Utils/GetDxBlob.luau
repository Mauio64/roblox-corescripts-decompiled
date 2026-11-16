return function(p2)
	if p2 == nil or p2.errors == nil or not (p2.errors[1] and p2.errors[1].fieldData) then
		return ""
	end

	return p2.errors[1].fieldData
end
