local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local useTokens = require(Foundation.Providers.Style.useTokens)
local v

if Flags.FoundationPopoverPluginOverlayMeasurement and Flags.FoundationPluginShadowSize then
	v = Constants.PLUGIN_SHADOW_SIZE
else
	v = Constants.SHADOW_SIZE
end

local function useArrowPosition(object, p, p2, p3: number, p4: number, instance)
	local v2 = useTokens()
	local v3 = React.useMemo(function()
		if p2 == Radius.XSmall then
			return v2.Size.Size_50
		end

		if p2 == Radius.Small then
			return v2.Size.Size_100
		end

		if p2 == Radius.Medium then
			return v2.Size.Size_200
		end

		return if p2 == Radius.Large then v2.Size.Size_300 else 0
	end, { p2, v2 })

	return object:map(function(udim: UDim2)
		local offset = udim.X.Offset
		local offset2 = udim.Y.Offset

		local v4 = v3

		if p2 == Radius.Circle then
			v4 = math.min(offset, offset2) / 2
		end

		local v5 = v4 + p4
		local v6 = p == PopoverSide.Top or p == PopoverSide.Bottom
		local offset3 = if v6 then offset else offset2
		local v7

		if instance and typeof(instance) == "Instance" then
			local absoluteSize = instance.AbsoluteSize
			local v8 = if v6 then absoluteSize.X else absoluteSize.Y
			local v9

			if p3 == 0 then
				v9 = 0
			elseif p3 == 0.5 then
				v9 = (offset3 - v8) / 2
			else
				v9 = offset3 - v8
			end

			local v10 = math.max(0, v9)
			local v11 = math.min(offset3, v9 + v8)

			if v10 <= v11 then
				v7 = (v10 + v11) / 2
			elseif offset3 < v9 then
				v7 = offset3 - p4
			else
				v7 = p4
			end
		else
			v7 = offset3 * p3
		end

		local v8 = offset3 - v5
		local v9

		if v5 <= v8 then
			v9 = math.clamp(v7, v5, v8)
		else
			v9 = offset3 / 2
		end

		if v6 then
			return UDim2.fromOffset(v + v9, v + (p ~= PopoverSide.Top and 0 or offset2))
		end

		return UDim2.fromOffset(v + (p ~= PopoverSide.Left and 0 or offset), v + v9)
	end)
end

return useArrowPosition
