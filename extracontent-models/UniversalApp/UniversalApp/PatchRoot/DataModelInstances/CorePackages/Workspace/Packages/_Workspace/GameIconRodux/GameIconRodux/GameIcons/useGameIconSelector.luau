local GameIconRodux = script:FindFirstAncestor("GameIconRodux")
local GameIconReducer = require(GameIconRodux.GameIcons.GameIconReducer)
local GameIconRoduxParent = GameIconRodux.Parent
local useSelector = require(GameIconRoduxParent.RoactUtils).Hooks.RoactRodux.useSelector

local function useGameIconSelector(p1) -- line: 7
	-- upvalues: useSelector (copy), GameIconReducer (copy)
	return (useSelector(function(p2) -- line: 8
		-- upvalues: GameIconReducer (copy), p1 (copy)
		return p2[GameIconReducer.key][p1]
	end))
end

return useGameIconSelector
