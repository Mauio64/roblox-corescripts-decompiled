local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RoactUtils")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/LuaSocialLibrariesDeps")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization").Hooks.useLocalization
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useExperienceSubtitle(p2)
	local v5 = useSelector(function(p3)
		local deepValue = getDeepValue(p3, "GameVotes." .. p2 .. ".upVotes")
		local deepValue2 = getDeepValue(p3, "GameVotes." .. p2 .. ".downVotes")

		if deepValue and deepValue2 then
			return (math.round(100 * deepValue / (deepValue + deepValue2)))
		end

		return nil
	end)

	if v5 == v5 and v5 then
		return useLocalization({
			ratingPercentage = {
				"Feature.VirtualEvents.Label.Rating",
				rating = tostring(v5)
			}
		}).ratingPercentage
	end

	local v6 = useSelector(function(p3)
		return p3.AgeRecommendations and p3.AgeRecommendations[p2]
	end)

	local ageRecommendation = v6 and v6.summary and v6.summary.ageRecommendation
	return ageRecommendation and ageRecommendation.displayNameWithHeaderShort
end

return useExperienceSubtitle
