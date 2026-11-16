local PeopleReactView = script:FindFirstAncestor("PeopleReactView")

local Constants = require(PeopleReactView.Constants)

return function(p: number, p2: number, p3: number)
	local v = math.clamp(
		math.floor(p2 / p),
		Constants.PEOPLEPAGE.PEOPLE_CARDS.MIN_CARD_COLUMNS,
		Constants.PEOPLEPAGE.PEOPLE_CARDS.MAX_CARD_COLUMNS
	)

	local v2 = math.ceil(p3 * (v - 1) / v)
	return math.floor(p2 / v) - v2, v
end
