local getUserProfileFromId = require(script.Parent.getUserProfileFromId)

return function(p, p2)
	local userProfileFromId = getUserProfileFromId(p, p2)

	if userProfileFromId.names then
		return userProfileFromId.names.username
	end

	return nil
end
