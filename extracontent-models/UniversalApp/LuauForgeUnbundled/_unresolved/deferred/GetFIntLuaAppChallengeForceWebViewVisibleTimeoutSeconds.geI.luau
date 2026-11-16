game:DefineFastInt("LuaAppChallengeForceWebViewVisibleTimeoutSeconds", 30)

return function()
	local fastInt = game:GetFastInt("LuaAppChallengeForceWebViewVisibleTimeoutSeconds")
	return fastInt <= 0 and 30 or fastInt
end
