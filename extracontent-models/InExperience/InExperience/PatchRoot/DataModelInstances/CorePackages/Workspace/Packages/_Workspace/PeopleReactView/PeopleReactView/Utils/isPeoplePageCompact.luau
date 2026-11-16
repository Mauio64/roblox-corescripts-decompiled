local PeopleReactView = script:FindFirstAncestor("PeopleReactView")

local Constants = require(PeopleReactView.Constants)

return function(p: number): boolean
	return p > 0 and math.round(p) < Constants.PEOPLEPAGE.STACKED_ROW_MAX_WINDOW_WIDTH
end
