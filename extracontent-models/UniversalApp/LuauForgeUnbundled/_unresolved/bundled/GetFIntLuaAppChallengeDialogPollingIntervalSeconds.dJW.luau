game:DefineFastInt("LuaAppChallengeDialogPollingIntervalSeconds", 15)

return function()
	local fastInt = game:GetFastInt("LuaAppChallengeDialogPollingIntervalSeconds")
	return fastInt <= 0 and 15 or fastInt
end
