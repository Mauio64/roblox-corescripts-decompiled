require("@luauforge/bundled/hIA")

local function getCrossPlayIsEnabled(p2)
	local crossPlaySettings = p2.CrossPlaySettings

	return crossPlaySettings.Status.isEnabled and crossPlaySettings.Status.isSystemPrivilegeEnabled or false
end

return getCrossPlayIsEnabled
