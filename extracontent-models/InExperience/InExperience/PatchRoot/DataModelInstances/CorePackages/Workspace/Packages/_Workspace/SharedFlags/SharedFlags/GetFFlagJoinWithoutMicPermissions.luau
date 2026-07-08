game:DefineFastFlag("JoinWithoutMicPermissions3", false)

local u1 = true

return function(b1: boolean?) -- line: 14
	-- upvalues: u1 (ref)
	if b1 ~= nil then
		u1 = b1
	end

	return game:GetFastFlag("JoinWithoutMicPermissions3") and u1
end
