game:DefineFastInt("LuaAppChallengeHybridWebViewTimeoutSeconds", 5)

return function() -- line: 5
	local FastInt = game:GetFastInt("LuaAppChallengeHybridWebViewTimeoutSeconds")

	if FastInt <= 0 then
		FastInt = 5
	end

	return FastInt
end
