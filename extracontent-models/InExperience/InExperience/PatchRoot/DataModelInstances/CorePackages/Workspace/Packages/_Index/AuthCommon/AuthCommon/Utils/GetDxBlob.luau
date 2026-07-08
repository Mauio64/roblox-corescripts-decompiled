return function(p1) -- line: 1
	if p1 ~= nil and (p1.errors ~= nil and p1.errors[1] and p1.errors[1].fieldData) then
		return p1.errors[1].fieldData
	end

	return ""
end
