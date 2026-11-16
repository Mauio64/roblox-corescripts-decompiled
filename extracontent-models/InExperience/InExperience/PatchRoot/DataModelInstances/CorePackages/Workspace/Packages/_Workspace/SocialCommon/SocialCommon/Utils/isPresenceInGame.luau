return function(p): boolean
	return not not p and p.userPresenceType == "InGame" and p.universeId ~= nil and p.universeId ~= ""
end
