local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local RoactUtils = require(VirtualEvents.Parent.RoactUtils)
local LuaSocialLibrariesDeps = require(VirtualEvents.Parent.LuaSocialLibrariesDeps)
local useLocalization = require(VirtualEvents.Parent.Localization).Hooks.useLocalization
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function useExperienceSubtitle(s1: string) -- line: 9
	-- upvalues: useSelector (copy), getDeepValue (copy), useLocalization (copy)
	local v9 = useSelector(function(p1) -- line: 10
		-- upvalues: getDeepValue (copy), s1 (copy)
		local v13 = getDeepValue(p1, "GameVotes." .. s1 .. ".upVotes")
		local v14 = getDeepValue(p1, "GameVotes." .. s1 .. ".downVotes")

		if not v13 or not v14 then
			return nil
		end

		return (math.round(100 * v13 / (v13 + v14)))
	end)

	if v9 ~= v9 or not v9 then
		local v10 = useSelector(function(p2) -- line: 24
			-- upvalues: s1 (copy)
			return p2.AgeRecommendations and p2.AgeRecommendations[s1]
		end)
		local v11 = v10 and (v10.summary and v10.summary.ageRecommendation)

		return v11 and v11.displayNameWithHeaderShort
	end

	return useLocalization({
		ratingPercentage = {
			"Feature.VirtualEvents.Label.Rating",
			rating = tostring(v9)
		}
	}).ratingPercentage
end

return useExperienceSubtitle
