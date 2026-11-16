game:DefineFastFlag("JoinWithoutMicPermissions3", false)

local v5 = true

return function(p2)
	if p2 ~= nil then
		v5 = p2
	end

	return game:GetFastFlag("JoinWithoutMicPermissions3") and v5
end
