local getUserProfileFromId = require(script.Parent.getUserProfileFromId)

return function(p1, p2) -- line: 3
	-- upvalues: getUserProfileFromId (copy)
	local v4 = getUserProfileFromId(p1, p2)

	if v4.names then
		return v4.names.username
	end

	return nil
end
