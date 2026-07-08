return function(t1: {[any]: any}?) -- line: 8
	if not t1 then
		return false
	end

	return t1.userPresenceType == "InGame" and (t1.universeId ~= nil and t1.universeId ~= "")
end
