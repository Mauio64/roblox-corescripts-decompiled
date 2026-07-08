require(script.Parent.VotesStoreTypes)

return {
	calculateRating = function(n1: number, n2: number) -- line: 11
		local v3 = n1 + n2

		if v3 == 0 then
			return 0
		end

		return (math.floor(n1 / v3 * 100))
	end,
	getRatingDisplayText = function(p1) -- line: 25
		if not p1 then
			return "--"
		end

		if (p1.upVotes or 0) + (p1.downVotes or 0) <= 0 or not p1.rating then
			return "--"
		end

		return tostring(p1.rating) .. "%"
	end
}
