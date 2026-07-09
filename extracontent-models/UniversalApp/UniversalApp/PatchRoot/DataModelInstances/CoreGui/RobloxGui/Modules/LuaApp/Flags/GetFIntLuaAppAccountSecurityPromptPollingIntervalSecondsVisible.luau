game:DefineFastInt("LuaAppAccountSecurityPromptPollingIntervalSecondsVisible", 15)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppAccountSecurityPromptPollingIntervalSecondsVisible")

	if FastInt <= 0 then
		FastInt = 15
	end

	return FastInt
end
