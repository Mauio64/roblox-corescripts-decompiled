game:DefineFastFlag("InGameLargerRobuxUpsellIXP", false)
game:DefineFastFlag("InGameLargerRobuxUpsellIXPRolledOut", false)
game:DefineFastFlag("InGameLargerRobuxUpsellEnabled", false)
game:DefineFastString("InGameLargerRobuxUpsellIXPLayerParam", "isInExperiment")

local function isEnabledForAll() -- 3 equivalent calls inferred from this helper
	return game:GetFastFlag("InGameLargerRobuxUpsellEnabled")
end

local function isRolledOut() -- 1 equivalent call inferred from this helper
	return isEnabledForAll() or game:GetFastFlag("InGameLargerRobuxUpsellIXPRolledOut") -- inferred equivalent call
end

local function isEnabled() -- 1 equivalent call inferred from this helper
	return isEnabledForAll() or game:GetFastFlag("InGameLargerRobuxUpsellIXP") -- inferred equivalent call
end

return {
	isEnabled = isEnabled,
	isEnabledForAll = isEnabledForAll,
	isUserEnrolled = function(options)
		if isEnabledForAll() then -- inferred equivalent call
			return true
		end

		if not isEnabled() then -- inferred equivalent call
			return false
		end

		local v = options or {}

		local fastString = game:GetFastString("InGameLargerRobuxUpsellIXPLayerParam")

		if v[fastString] == nil then
			return isRolledOut() -- inferred equivalent call
		end

		return v[fastString]
	end
}
