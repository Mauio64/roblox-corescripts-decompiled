local Parent = script:FindFirstAncestor("GameTile").Parent
local useAbbreviatedNumberLocalization = require(Parent.Localization).Hooks.useAbbreviatedNumberLocalization

local function usePlayerCountText(n1: number?) -- line: 5
	-- upvalues: useAbbreviatedNumberLocalization (copy)
	local v5 = useAbbreviatedNumberLocalization(n1)

	if v5 == nil or n1 == -1 then
		return "--"
	end

	return v5
end

return usePlayerCountText
