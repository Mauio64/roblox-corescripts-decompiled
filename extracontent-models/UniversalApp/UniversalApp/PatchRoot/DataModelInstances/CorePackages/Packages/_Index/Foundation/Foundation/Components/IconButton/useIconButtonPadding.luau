local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local IconSize = require(Foundation.Enums.IconSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function useIconButtonPadding(p1, b1: boolean) -- line: 11
	-- upvalues: useTokens (copy), React (copy), IconSize (copy)
	local v9 = useTokens()
	local v10 = React.useMemo(function() -- line: 14
		-- upvalues: b1 (copy), IconSize (copy), v9 (copy)
		if b1 then
			return {
				[IconSize.XSmall] = v9.Size.Size_150,
				[IconSize.Small] = v9.Size.Size_200,
				[IconSize.Medium] = v9.Size.Size_250,
				[IconSize.Large] = v9.Size.Size_350
			}
		end

		return {
			[IconSize.XSmall] = v9.Size.Size_50,
			[IconSize.Small] = v9.Size.Size_50,
			[IconSize.Medium] = v9.Size.Size_100,
			[IconSize.Large] = v9.Size.Size_150,
			[IconSize.XLarge] = v9.Size.Size_200,
			[IconSize.XXLarge] = v9.Size.Size_250
		}
	end, {
		v9,
		b1
	})[p1]

	if v10 == nil then
		error("Invalid icon button size: " .. p1)
	end

	return v10
end

return useIconButtonPadding
