game:DefineFastInt("LuaAppChallengeDialogEventReceiverRetryIntervalSeconds", 1)

return function() -- line: 6
	local FastInt = game:GetFastInt("LuaAppChallengeDialogEventReceiverRetryIntervalSeconds")

	if FastInt <= 0 then
		FastInt = 1
	end

	return FastInt
end
