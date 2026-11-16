local BuildExperience = script:FindFirstAncestor("BuildExperience")

local v = game:DefineFastFlag("AppThemeHalloween2026BuildBackground", false)

if v then
	local SharedFlags = require(BuildExperience.Parent.SharedFlags)
	return SharedFlags.FFlagAppThemeHalloween2026HomeBackground
end

return v
