return function(p2)
	if p2 and p2.InviteUser ~= 0 then
		return p2.InviteUser
	end

	return nil
end
