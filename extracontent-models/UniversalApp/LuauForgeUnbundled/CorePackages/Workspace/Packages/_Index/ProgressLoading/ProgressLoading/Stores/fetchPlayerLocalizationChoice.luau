local createNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/createNetworking")
local buildPlayerLocalizationChoiceUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/Stores/buildPlayerLocalizationChoiceUrl")

local function fetchPlayerLocalizationChoice(p2)
	return createNetworking(buildPlayerLocalizationChoiceUrl(p2), "GET")
end

return fetchPlayerLocalizationChoice
