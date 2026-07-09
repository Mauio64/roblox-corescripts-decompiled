game:DefineFastInt("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRollout", 0)
game:DefineFastFlag("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRolloutEnabledForAll", false)

return function(p1) -- line: 5
	if game:GetFastFlag("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRolloutEnabledForAll") then
		return true
	end

	local FastInt = game:GetFastInt("LuaAppUseStaticCdnUrlForChallengeHybridWebViewRollout")

	if FastInt <= 0 then
		return false
	end

	if not p1 or p1 == "" then
		return false
	end

	return FastInt > (p1 + 45) % 100
end
