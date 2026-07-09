game:DefineFastInt("LuaAppAccountSecurityPromptRollout", 0)
game:DefineFastFlag("LuaAppAccountSecurityPromptRolloutEnabledForAll", false)

return function(p1) -- line: 5
	if game:GetFastFlag("LuaAppAccountSecurityPromptRolloutEnabledForAll") then
		return true
	end

	local FastInt = game:GetFastInt("LuaAppAccountSecurityPromptRollout")

	if FastInt <= 0 then
		return false
	end

	if not p1 or p1 == "" then
		return false
	end

	return FastInt > (p1 + 37) % 100
end
