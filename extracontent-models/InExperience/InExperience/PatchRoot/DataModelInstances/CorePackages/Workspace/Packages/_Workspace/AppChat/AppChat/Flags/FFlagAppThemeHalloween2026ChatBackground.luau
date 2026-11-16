local parent = script:FindFirstAncestor("AppChat").Parent

local v = game:DefineFastFlag("AppThemeHalloween2026ChatBackground", false)

if v then
	local SharedFlags = require(parent.SharedFlags)
	return SharedFlags.FFlagAppThemeHalloween2026HomeBackground
end

return v
