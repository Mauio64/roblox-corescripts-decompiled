local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").Hooks.useTokens

local function useCompactTileHeight()
	local v5 = useTokens()

	return (React.useMemo(function()
		local size_1400 = v5.Size.Size_1400
		local medium = v5.Padding.Medium
		local small = v5.Gap.Small

		local fontSize = v5.Typography.TitleSmall.FontSize
		local fontSize2 = v5.Typography.LabelSmall.FontSize
		local fontSize3 = v5.Typography.BodySmall.FontSize

		local size_800 = v5.Size.Size_800

		local v6 = fontSize + fontSize2 + fontSize3

		return medium + size_1400 + small + v6 + small + size_800 + medium
	end, { v5 }))
end

return useCompactTileHeight
