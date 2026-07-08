game:DefineFastInt("LuaAppCredentialsProtocolAvailableTimeout", 2)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppCredentialsProtocolAvailableTimeout")

	if FastInt <= 0 then
		return 2
	end

	return FastInt
end
