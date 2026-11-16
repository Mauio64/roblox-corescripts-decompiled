local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local calculateCardLayout = require(PeopleReactView.Utils.calculateCardLayout)

local function useCardLayoutValues()
	local v = useTokens()

	local v2, v3 = React.useBinding(0)
	local v4, v5 = React.useBinding(0)
	local v6, v7 = React.useBinding(0)

	return v2, v4, v6, (React.useCallback(function(p: number, p2: number, p3: number)
		local v8, v9 = calculateCardLayout(p, p2, p3)
		v7(v9)
		v3(v8)
		v5(v8 + v.Size.Size_1400)
		return v8
	end, { v.Size.Size_1400 }))
end

return useCardLayoutValues
