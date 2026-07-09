local CorePackages = game:GetService("CorePackages")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers

game:DefineFastFlag("GamepassRobuxUpsellIXPV2", false)
game:DefineFastFlag("GamepassRobuxUpsellIXPRolledOutV2", false)
game:DefineFastFlag("GamepassRobuxUpsellEnabledV2", false)

local function isRolledOut() -- line: 22
	return game:GetFastFlag("GamepassRobuxUpsellEnabledV2") or game:GetFastFlag("GamepassRobuxUpsellIXPRolledOutV2")
end

return {
	isEnabled = function() -- line: 26
		return game:GetFastFlag("GamepassRobuxUpsellEnabledV2") or game:GetFastFlag("GamepassRobuxUpsellIXPV2")
	end,
	isEnabledForAll = function() -- line: 18
		return game:GetFastFlag("GamepassRobuxUpsellEnabledV2")
	end,
	isUserEnrolled = function(p1) -- line: 30
		-- upvalues: AppUserLayers (copy)
		if game:GetFastFlag("GamepassRobuxUpsellEnabledV2") then
			return true
		end

		if not game:GetFastFlag("GamepassRobuxUpsellEnabledV2") and not game:GetFastFlag("GamepassRobuxUpsellIXPV2") then
			return false
		end

		local v5 = p1[AppUserLayers.GamepassRobuxUpsellLayer] or {}

		if not v5.isInExperiment then
			if game:GetFastFlag("GamepassRobuxUpsellEnabledV2") or game:GetFastFlag("GamepassRobuxUpsellIXPRolledOutV2") then
				return true
			end

			return false
		end

		return v5.isInExperiment ~= 0
	end
}
