game:DefineFastInt("LuaAppChallengeDialogEventReceiverRetryTimes", 3)

return function() -- line: 6
	local FastInt = game:GetFastInt("LuaAppChallengeDialogEventReceiverRetryTimes")

	if FastInt < 0 then
		FastInt = 3
	end

	return FastInt
end
