game:DefineFastInt("LuaAppChallengeHybridWebViewTimeoutSeconds", 5)

return function()
	local fastInt = game:GetFastInt("LuaAppChallengeHybridWebViewTimeoutSeconds")
	return fastInt <= 0 and 5 or fastInt
end
