game:DefineFastInt("LuaAppCredentialsProtocolTimeout", 20)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppCredentialsProtocolTimeout")

	if FastInt <= 20 then
		return 20
	end

	return FastInt
end
