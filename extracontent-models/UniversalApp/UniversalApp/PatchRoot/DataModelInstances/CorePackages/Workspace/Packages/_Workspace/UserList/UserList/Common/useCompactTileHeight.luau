local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function useCompactTileHeight() -- line: 21
	-- upvalues: useTokens (copy), React (copy)
	local v5 = useTokens()

	return (React.useMemo(function() -- line: 24
		-- upvalues: v5 (copy)
		local Size_1400 = v5.Size.Size_1400
		local Medium = v5.Padding.Medium
		local Small = v5.Gap.Small
		local FontSize = v5.Typography.TitleSmall.FontSize
		local FontSize2 = v5.Typography.LabelSmall.FontSize
		local FontSize3 = v5.Typography.BodySmall.FontSize
		local Size_800 = v5.Size.Size_800
		local v13 = FontSize + FontSize2 + FontSize3

		return Medium + Size_1400 + Small + v13 + Small + Size_800 + Medium
	end, { v5 }))
end

return useCompactTileHeight
