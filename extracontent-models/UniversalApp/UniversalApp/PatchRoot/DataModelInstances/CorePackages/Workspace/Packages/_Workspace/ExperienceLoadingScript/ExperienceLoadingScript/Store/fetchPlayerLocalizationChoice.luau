local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local createNetworking = require(ExperienceLoadingScript.createNetworking)
local buildPlayerLocalizationChoiceUrl = require(script.Parent.buildPlayerLocalizationChoiceUrl)

local function fetchPlayerLocalizationChoice(s1: string) -- line: 6
	-- upvalues: buildPlayerLocalizationChoiceUrl (copy), createNetworking (copy)
	local v6 = buildPlayerLocalizationChoiceUrl(s1)

	return createNetworking(v6, "GET")
end

return fetchPlayerLocalizationChoice
