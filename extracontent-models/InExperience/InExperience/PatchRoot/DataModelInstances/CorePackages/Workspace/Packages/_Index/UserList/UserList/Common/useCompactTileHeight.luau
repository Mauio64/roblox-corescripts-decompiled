local parent = script:FindFirstAncestor("UserList").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local function useCompactTileHeight()
	local v = useTokens()

	return (React.useMemo(function()
		local size_1400 = v.Size.Size_1400
		local medium = v.Padding.Medium
		local small = v.Gap.Small

		local fontSize = v.Typography.TitleSmall.FontSize
		local fontSize2 = v.Typography.LabelSmall.FontSize
		local fontSize3 = v.Typography.BodySmall.FontSize

		local size_800 = v.Size.Size_800

		local v2 = fontSize + fontSize2 + fontSize3

		return medium + size_1400 + small + v2 + small + size_800 + medium
	end, { v }))
end

return useCompactTileHeight
