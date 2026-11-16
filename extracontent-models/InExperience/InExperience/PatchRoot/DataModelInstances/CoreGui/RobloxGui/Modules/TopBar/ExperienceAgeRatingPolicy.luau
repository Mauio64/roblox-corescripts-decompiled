local CorePackages = game:GetService("CorePackages")

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagExperienceAgeRatingBadge = InExperienceTopBar.Flags.FFlagExperienceAgeRatingBadge
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating

return {
	isEligible = function(flag: boolean?, flag2: boolean, flag3: boolean, flag4: boolean)
		local v = FFlagExperienceAgeRatingBadge and FFlagShowGameAgeRating

		if v then
			if flag == true then
				return flag2 and flag3 and not flag4
			end

			return false
		end

		return v
	end,
	keepOutAreaId = "experience-age-rating"
}
