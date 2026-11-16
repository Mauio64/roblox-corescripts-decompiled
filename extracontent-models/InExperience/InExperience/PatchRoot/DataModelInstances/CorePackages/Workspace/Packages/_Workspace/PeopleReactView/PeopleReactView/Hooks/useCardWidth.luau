local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)

local calculateCardLayout = require(PeopleReactView.Utils.calculateCardLayout)

local function useCardWidth()
	local v, v2 = React.useBinding(0)

	return v, (React.useCallback(function(p: number, p2: number, p3: number)
		local v3 = calculateCardLayout(p, p2, p3)
		v2(v3)
		return v3
	end, {}))
end

return useCardWidth
