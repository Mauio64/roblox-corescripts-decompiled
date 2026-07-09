game:DefineFastInt("LuaAppAccountSecurityPromptPollingIntervalSeconds", 600)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppAccountSecurityPromptPollingIntervalSeconds")

	if FastInt <= 0 then
		FastInt = 600
	end

	return FastInt
end
