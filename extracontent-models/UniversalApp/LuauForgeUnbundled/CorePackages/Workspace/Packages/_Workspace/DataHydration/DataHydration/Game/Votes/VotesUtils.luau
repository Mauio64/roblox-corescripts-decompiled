local fFlagSduiSupportRatingNoPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagSduiSupportRatingNoPercent

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/VotesStoreTypes")

return {
	calculateRating = function(p2, p3)
		local v5 = p2 + p3

		if v5 == 0 then
			return 0
		end

		return (math.floor(p2 / v5 * 100))
	end,
	getRatingDisplayText = function(data, p2)
		if not data or ((data.upVotes or 0) + (data.downVotes or 0) <= 0 or not data.rating) then
			return "--"
		end

		if fFlagSduiSupportRatingNoPercent and p2 then
			return (tostring(data.rating))
		end

		return tostring(data.rating) .. "%"
	end
}
