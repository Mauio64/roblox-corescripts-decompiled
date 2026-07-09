game:DefineFastFlag("InGameLargerRobuxUpsellIXP", false)
game:DefineFastFlag("InGameLargerRobuxUpsellIXPRolledOut", false)
game:DefineFastFlag("InGameLargerRobuxUpsellEnabled", false)
game:DefineFastString("InGameLargerRobuxUpsellIXPLayerParam", "isInExperiment")

local function isRolledOut() -- line: 20
	return game:GetFastFlag("InGameLargerRobuxUpsellEnabled") or game:GetFastFlag("InGameLargerRobuxUpsellIXPRolledOut")
end

return {
	isEnabled = function() -- line: 24
		return game:GetFastFlag("InGameLargerRobuxUpsellEnabled") or game:GetFastFlag("InGameLargerRobuxUpsellIXP")
	end,
	isEnabledForAll = function() -- line: 16
		return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
	end,
	isUserEnrolled = function(p1) -- line: 28
		if game:GetFastFlag("InGameLargerRobuxUpsellEnabled") then
			return true
		end

		if not game:GetFastFlag("InGameLargerRobuxUpsellEnabled") and not game:GetFastFlag("InGameLargerRobuxUpsellIXP") then
			return false
		end

		local v3 = p1 or {}
		local FastString = game:GetFastString("InGameLargerRobuxUpsellIXPLayerParam")

		if v3[FastString] == nil then
			return game:GetFastFlag("InGameLargerRobuxUpsellEnabled") or game:GetFastFlag("InGameLargerRobuxUpsellIXPRolledOut")
		end

		return v3[FastString]
	end
}
