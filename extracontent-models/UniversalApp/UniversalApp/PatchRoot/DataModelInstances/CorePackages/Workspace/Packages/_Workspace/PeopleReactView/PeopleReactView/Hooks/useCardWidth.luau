local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Constants = require(PeopleReactView.Constants)

local function useCardWidth() -- line: 8
	-- upvalues: React (copy), Constants (copy)
	local v6, v7 = React.useBinding(0)

	return v6, (React.useCallback(function(n1: number, n2: number, n3: number) -- line: 11
		-- upvalues: Constants (copy), v7 (copy)
		local v11 = math.clamp(math.floor(n2 / n1), Constants.PEOPLEPAGE.PEOPLE_CARDS.MIN_CARD_COLUMNS, Constants.PEOPLEPAGE.PEOPLE_CARDS.MAX_CARD_COLUMNS)
		local v12 = math.ceil(n3 * (v11 - 1) / v11)
		local v13 = math.floor(n2 / v11) - v12

		v7(v13)
	end, {}))
end

return useCardWidth
