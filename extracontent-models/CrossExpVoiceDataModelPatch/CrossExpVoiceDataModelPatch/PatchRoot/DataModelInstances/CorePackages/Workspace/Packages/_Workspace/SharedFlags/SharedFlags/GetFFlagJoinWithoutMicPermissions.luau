game:DefineFastFlag("JoinWithoutMicPermissions3", false)

local v = true

return function(flag: boolean?)
	if flag ~= nil then
		v = flag
	end

	return game:GetFastFlag("JoinWithoutMicPermissions3") and v
end
