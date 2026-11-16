game:DefineFastFlag("InGameLargerRobuxUpsellIXP", false)
game:DefineFastFlag("InGameLargerRobuxUpsellIXPRolledOut", false)
game:DefineFastFlag("InGameLargerRobuxUpsellEnabled", false)
game:DefineFastString("InGameLargerRobuxUpsellIXPLayerParam", "isInExperiment")

local function isRolledOut()
	return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
		or game:GetFastFlag("InGameLargerRobuxUpsellIXPRolledOut")
end

return {
	isEnabled = function()
		return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
			or game:GetFastFlag("InGameLargerRobuxUpsellIXP")
	end,
	isEnabledForAll = function()
		return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
	end,
	isUserEnrolled = function(options)
		if game:GetFastFlag("InGameLargerRobuxUpsellEnabled") then
			return true
		end

		if not (game:GetFastFlag("InGameLargerRobuxUpsellEnabled") or game:GetFastFlag("InGameLargerRobuxUpsellIXP")) then
			return false
		end

		local v5 = options or {}

		local fastString = game:GetFastString("InGameLargerRobuxUpsellIXPLayerParam")

		if v5[fastString] == nil then
			return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
				or game:GetFastFlag("InGameLargerRobuxUpsellIXPRolledOut")
		end

		return v5[fastString]
	end
}
