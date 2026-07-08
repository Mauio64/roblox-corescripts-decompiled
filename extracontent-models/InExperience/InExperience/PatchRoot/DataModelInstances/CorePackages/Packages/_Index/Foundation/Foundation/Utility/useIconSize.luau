local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local IconSize = require(Foundation.Enums.IconSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function isNumber(p1) -- line: 11
	return typeof(p1) == "number" or typeof(p1) == "table" and typeof(p1:getValue()) == "number"
end
local function useIconSize(p2, b1: boolean, b2: boolean?) -- line: 15
	-- upvalues: useTokens (copy), IconSize (copy)
	local v10 = useTokens()
	local v11 = if not b1 then {
		[IconSize.XSmall] = v10.Size.Size_200,
		[IconSize.Small] = v10.Size.Size_400,
		[IconSize.Medium] = v10.Size.Size_900,
		[IconSize.Large] = v10.Size.Size_1200,
		[IconSize.XLarge] = v10.Size.Size_2400,
		[IconSize.XXLarge] = 24 * v10.Size.Size_200
	} else {
		[IconSize.XSmall] = if not b2 then v10.Size.Size_300 else v10.Size.Size_400,
		[IconSize.Small] = if not b2 then v10.Size.Size_400 else v10.Size.Size_500,
		[IconSize.Medium] = if not b2 then v10.Size.Size_500 else v10.Size.Size_600,
		[IconSize.Large] = if not b2 then v10.Size.Size_600 else v10.Size.Size_700,
		[IconSize.XLarge] = if not b2 then v10.Size.Size_700 else v10.Size.Size_800,
		[IconSize.XXLarge] = if not b2 then v10.Size.Size_800 else v10.Size.Size_900
	}
	local v12 = nil

	if b1 and (typeof(p2) == "number" or typeof(p2) == "table" and typeof(p2:getValue()) == "number") then
		v12 = p2
	elseif typeof(p2) ~= "number" and (typeof(p2) ~= "table" or typeof(p2:getValue()) ~= "number") then
		v12 = v11[p2]
	end

	if v12 == nil then
		error("Invalid icon size: " .. tostring(p2))
	end

	if typeof(v12) == "table" then
		return (v12:map(function(p3) -- line: 52
			return UDim2.fromOffset(p3, p3)
		end))
	end

	return (UDim2.fromOffset(v12, v12))
end

return useIconSize
