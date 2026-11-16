game:DefineFastInt("LuaAppAccountSecurityPromptPollingIntervalSecondsVisible", 15)

return function()
	local fastInt = game:GetFastInt("LuaAppAccountSecurityPromptPollingIntervalSecondsVisible")
	return fastInt <= 0 and 15 or fastInt
end
