return function(p1) -- line: 1
	if p1 and p1.InviteUser ~= 0 then
		return p1.InviteUser
	end

	return nil
end
