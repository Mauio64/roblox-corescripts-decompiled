local parent = script:FindFirstAncestor("DataHydration").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiSupportRatingNoPercent = SharedFlags.FFlagSduiSupportRatingNoPercent

require(script.Parent.VotesStoreTypes)
local VotesUtils = {}

function VotesUtils.calculateRating(p: number, p2: number)
	local v = p + p2

	if v == 0 then
		return 0
	end

	return (math.floor(p / v * 100))
end

function VotesUtils.getRatingDisplayText(data, flag: boolean?)
	if not data or ((data.upVotes or 0) + (data.downVotes or 0) <= 0 or not data.rating) then
		return "--"
	end

	if FFlagSduiSupportRatingNoPercent and flag then
		return (tostring(data.rating))
	end

	return tostring(data.rating) .. "%"
end

return VotesUtils
