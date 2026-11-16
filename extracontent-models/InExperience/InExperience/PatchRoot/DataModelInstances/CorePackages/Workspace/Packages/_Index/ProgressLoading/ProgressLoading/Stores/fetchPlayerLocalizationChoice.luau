local ProgressLoading = script:FindFirstAncestor("ProgressLoading")

local createNetworking = require(ProgressLoading.createNetworking)
local buildPlayerLocalizationChoiceUrl = require(script.Parent.buildPlayerLocalizationChoiceUrl)

local function fetchPlayerLocalizationChoice(p: string)
	return createNetworking(buildPlayerLocalizationChoiceUrl(p), "GET")
end

return fetchPlayerLocalizationChoice
