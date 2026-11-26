game:DefineFastInt("LuaAppAccountSecurityPromptPollingIntervalSeconds", 600)

return function()
	local fastInt = game:GetFastInt("LuaAppAccountSecurityPromptPollingIntervalSeconds")
	return fastInt <= 0 and 600 or fastInt
end
