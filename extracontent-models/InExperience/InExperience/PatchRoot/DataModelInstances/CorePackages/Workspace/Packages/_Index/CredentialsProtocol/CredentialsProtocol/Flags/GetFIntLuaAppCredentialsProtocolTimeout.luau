game:DefineFastInt("LuaAppCredentialsProtocolTimeout", 20)

return function()
	local fastInt = game:GetFastInt("LuaAppCredentialsProtocolTimeout")
	return if fastInt <= 20 then 20 else fastInt
end
