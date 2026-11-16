local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local LuaSocialLibrariesDeps = require(VirtualEvents.Parent.LuaSocialLibrariesDeps)
local Localization = require(VirtualEvents.Parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useExperienceSubtitle(p: string)
	local v = useSelector(function(p2)
		local deepValue = getDeepValue(p2, "GameVotes." .. p .. ".upVotes")
		local deepValue2 = getDeepValue(p2, "GameVotes." .. p .. ".downVotes")

		if deepValue and deepValue2 then
			return (math.round(100 * deepValue / (deepValue + deepValue2)))
		end

		return nil
	end)

	if v == v and v then
		return useLocalization({
			ratingPercentage = {
				"Feature.VirtualEvents.Label.Rating",
				rating = tostring(v)
			}
		}).ratingPercentage
	end

	local v2 = useSelector(function(p2)
		return p2.AgeRecommendations and p2.AgeRecommendations[p]
	end)

	local ageRecommendation = v2 and v2.summary and v2.summary.ageRecommendation
	return ageRecommendation and ageRecommendation.displayNameWithHeaderShort
end

return useExperienceSubtitle
