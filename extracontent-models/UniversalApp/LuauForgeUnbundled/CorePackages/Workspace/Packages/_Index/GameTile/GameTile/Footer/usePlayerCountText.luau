local useAbbreviatedNumberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useAbbreviatedNumberLocalization

local function usePlayerCountText(p2)
	local v5 = useAbbreviatedNumberLocalization(p2)

	if v5 == nil or p2 == -1 then
		return "--"
	end

	return v5
end

return usePlayerCountText
