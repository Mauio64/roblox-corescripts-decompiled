local function hasOwnProperty(t1: {[any]: any}, p1) -- line: 7
	return t1[p1] ~= nil
end

return hasOwnProperty
