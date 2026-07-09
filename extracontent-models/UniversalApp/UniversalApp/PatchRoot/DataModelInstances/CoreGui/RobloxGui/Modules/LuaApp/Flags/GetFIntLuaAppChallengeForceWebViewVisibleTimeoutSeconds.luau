game:DefineFastInt("LuaAppChallengeForceWebViewVisibleTimeoutSeconds", 30)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppChallengeForceWebViewVisibleTimeoutSeconds")

	if FastInt <= 0 then
		FastInt = 30
	end

	return FastInt
end
