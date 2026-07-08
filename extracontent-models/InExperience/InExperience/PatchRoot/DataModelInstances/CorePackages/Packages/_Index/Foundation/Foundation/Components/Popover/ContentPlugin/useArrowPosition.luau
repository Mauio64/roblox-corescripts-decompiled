local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Constants = require(Foundation.Constants)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local useTokens = require(Foundation.Providers.Style.useTokens)
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function useArrowPosition(p1, p2, p3, n1: number, n2: number, p4) -- line: 16
	-- upvalues: useTokens (copy), React (copy), Radius (copy), PopoverSide (copy), SHADOW_SIZE (copy)
	local v16 = useTokens()
	local v17 = React.useMemo(function() -- line: 25
		-- upvalues: p3 (copy), Radius (copy), v16 (copy)
		if p3 == Radius.XSmall then
			return v16.Size.Size_50
		end

		if p3 == Radius.Small then
			return v16.Size.Size_100
		end

		if p3 == Radius.Medium then
			return v16.Size.Size_200
		end

		if p3 == Radius.Large then
			return v16.Size.Size_300
		end

		return 0
	end, {
		p3,
		v16
	})

	return p1:map(function(uDim2: UDim2) -- line: 39
		-- upvalues: v17 (copy), p3 (copy), Radius (copy), n2 (copy), p2 (copy), PopoverSide (copy), p4 (copy), n1 (copy), SHADOW_SIZE (copy)
		local XOffset = uDim2.X.Offset
		local YOffset = uDim2.Y.Offset
		local v21 = v17

		if p3 == Radius.Circle then
			v21 = math.min(XOffset, YOffset) / 2
		end

		local v22 = v21 + n2
		local v23 = p2 == PopoverSide.Top or p2 == PopoverSide.Bottom
		local v24 = if not v23 then YOffset else XOffset
		local v30

		if p4 and typeof(p4) == "Instance" then
			local AbsoluteSize = p4.AbsoluteSize
			local v26 = if not v23 then AbsoluteSize.Y else AbsoluteSize.X
			local v27 = if n1 ~= 0 then if n1 ~= 0.5 then v24 - v26 else (v24 - v26) / 2 else 0
			local v28 = math.max(0, v27)
			local v29 = math.min(v24, v27 + v26)

			v30 = if not (v28 <= v29) then if not (v24 < v27) then n2 else v24 - n2 else (v28 + v29) / 2
		else
			v30 = v24 * n1
		end

		local v31 = v24 - v22
		local v32 = if not (v22 <= v31) then v24 / 2 else math.clamp(v30, v22, v31)

		if v23 then
			return UDim2.fromOffset(SHADOW_SIZE + v32, SHADOW_SIZE + (p2 ~= PopoverSide.Top and 0 or YOffset))
		end

		return UDim2.fromOffset(SHADOW_SIZE + (p2 ~= PopoverSide.Left and 0 or XOffset), SHADOW_SIZE + v32)
	end)
end

return useArrowPosition
