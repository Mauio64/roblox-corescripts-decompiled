game:DefineFastInt("LuaAppCredentialsProtocolAvailableTimeout", 2)

return function()
	local fastInt = game:GetFastInt("LuaAppCredentialsProtocolAvailableTimeout")

	if fastInt <= 0 then
		return 2
	end

	return fastInt
end
