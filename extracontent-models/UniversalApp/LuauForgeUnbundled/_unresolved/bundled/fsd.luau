game:DefineFastInt("LuaAppAccountSecurityPromptRollout", 0)
game:DefineFastFlag("LuaAppAccountSecurityPromptRolloutEnabledForAll", false)

return function(p2): boolean
	if game:GetFastFlag("LuaAppAccountSecurityPromptRolloutEnabledForAll") then
		return true
	end

	local fastInt = game:GetFastInt("LuaAppAccountSecurityPromptRollout")

	if fastInt <= 0 then
		return false
	end

	if p2 and p2 ~= "" then
		return (p2 + 37) % 100 < fastInt
	end

	return false
end
