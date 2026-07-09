game:DefineFastInt("LuaAppChallengeDialogPollingIntervalSeconds", 15)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppChallengeDialogPollingIntervalSeconds")

	if FastInt <= 0 then
		FastInt = 15
	end

	return FastInt
end
