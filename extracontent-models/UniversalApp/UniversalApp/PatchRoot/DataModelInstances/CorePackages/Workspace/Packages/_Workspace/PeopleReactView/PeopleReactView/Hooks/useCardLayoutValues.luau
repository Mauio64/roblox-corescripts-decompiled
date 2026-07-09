local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local useTokens = require(PeopleReactViewParent.Foundation).Hooks.useTokens
local Constants = require(PeopleReactView.Constants)

local function useCardLayoutValues() -- line: 11
	-- upvalues: useTokens (copy), React (copy), Constants (copy)
	local v7 = useTokens()
	local v8, v9 = React.useBinding(0)
	local v10, v11 = React.useBinding(0)
	local v12, v13 = React.useBinding(0)

	return v8, v10, v12, (React.useCallback(function(n1: number, n2: number, n3: number) -- line: 19
		-- upvalues: Constants (copy), v13 (copy), v9 (copy), v11 (copy), v7 (copy)
		local v17 = math.clamp(math.floor(n2 / n1), Constants.PEOPLEPAGE.PEOPLE_CARDS.MIN_CARD_COLUMNS, Constants.PEOPLEPAGE.PEOPLE_CARDS.MAX_CARD_COLUMNS)
		local v18 = math.ceil(n3 * (v17 - 1) / v17)
		local v19 = math.floor(n2 / v17) - v18

		v13(v17)
		v9(v19)
		v11(v19 + v7.Size.Size_1400)
	end, { v7.Size.Size_1400 }))
end

return useCardLayoutValues
