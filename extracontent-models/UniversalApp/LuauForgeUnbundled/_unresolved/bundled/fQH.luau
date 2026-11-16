game:DefineFastInt("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRollout", 0)
game:DefineFastFlag("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRolloutEnabledForAll", false)

return function(p2): boolean
	if game:GetFastFlag("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRolloutEnabledForAll") then
		return true
	end

	local fastInt = game:GetFastInt("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRollout")

	if fastInt <= 0 then
		return false
	end

	if p2 and p2 ~= "" then
		return (p2 + 45) % 100 < fastInt
	end

	return false
end
