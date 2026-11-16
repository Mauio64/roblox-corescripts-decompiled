local parent = script:FindFirstAncestor("GameTile").Parent
local Localization = require(parent.Localization)
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

local function usePlayerCountText(p: number?)
	local v = useAbbreviatedNumberLocalization(p)
	return if v == nil or p == -1 then "--" else v
end

return usePlayerCountText
