game:DefineFastInt("LuaAppCredentialsProtocolTimeout", 20)

return function()
	local fastInt = game:GetFastInt("LuaAppCredentialsProtocolTimeout")

	if fastInt <= 20 then
		return 20
	end

	return fastInt
end
