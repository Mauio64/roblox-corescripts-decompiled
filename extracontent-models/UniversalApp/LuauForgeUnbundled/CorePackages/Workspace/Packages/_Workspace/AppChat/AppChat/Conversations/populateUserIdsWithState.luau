local populateListFromIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/SocialLibraries").populate.populateListFromIds
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

return function(p2, p3)
	return populateListFromIds(p3, getDeepValue(p2, "Users") or {})
end
