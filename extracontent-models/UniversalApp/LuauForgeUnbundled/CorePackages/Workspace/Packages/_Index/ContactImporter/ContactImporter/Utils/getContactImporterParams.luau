local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies").SocialLibraries.Dictionary.getDeepValue
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants").RODUX_KEY

return function(p2)
	return getDeepValue(p2, RODUX_KEY .. ".ShowContactImporterParams") or {}
end
