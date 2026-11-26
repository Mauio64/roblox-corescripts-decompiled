game:DefineFastInt("LuaAppChallengeDialogEventReceiverRetryIntervalSeconds", 1)

return function()
	local fastInt = game:GetFastInt("LuaAppChallengeDialogEventReceiverRetryIntervalSeconds")
	return fastInt <= 0 and 1 or fastInt
end
