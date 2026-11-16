game:DefineFastInt("LuaAppChallengeDialogEventReceiverRetryTimes", 3)

return function()
	local fastInt = game:GetFastInt("LuaAppChallengeDialogEventReceiverRetryTimes")
	return fastInt < 0 and 3 or fastInt
end
