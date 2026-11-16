game:DefineFastInt("LuaAppCredentialsProtocolAvailableTimeout", 2)

return function()
	local fastInt = game:GetFastInt("LuaAppCredentialsProtocolAvailableTimeout")
	return if fastInt <= 0 then 2 else fastInt
end
