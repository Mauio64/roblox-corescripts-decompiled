local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local FFlagAXMigrateBuilderIcons = require(Parent.AvatarExperienceFlags).FFlagAXMigrateBuilderIcons

local function getItemWidth(n1: number, n2: number, n3: number) -- line: 23
	return (math.floor((n1 - (n2 - 1) * n3) / n2))
end
local function getItemCardWidthParameters(n4: number, s1: string, s2: string) -- line: 29
	-- upvalues: Responsive (copy)
	if s1 == Responsive.BreakpointConfig.Enum.Medium or s2 == Responsive.BreakpointConfig.Enum.Portrait then
		return {
			visibleItemCount = 6,
			itemGap = n4
		}
	end

	return nil
end

return function(vector2: Vector2?) -- line: 50
	-- upvalues: useTokens (copy), Responsive (copy), IconSize (copy), FFlagAXMigrateBuilderIcons (copy)
	local v16 = useTokens()
	local v17 = Responsive.useResponsive()
	local v18 = Responsive.useOrientation()
	local Small = v16.Gap.Small
	local Size_1600 = v16.Size.Size_1600
	local Size_2100 = v16.Size.Size_2100
	local Medium = v16.Padding.Medium
	local Size_1000 = v16.Size.Size_1000
	local v24 = v18 == Responsive.BreakpointConfig.Enum.Portrait
	local v25 = ((if not v24 then v16.Typography.CaptionMedium else v16.Typography.CaptionSmall)).FontSize + v16.Gap.Small
	local v26 = if v18 ~= Responsive.BreakpointConfig.Enum.Portrait then Size_2100 else Size_1600
	local v27 = v26 + v25 + Medium * 2
	local v28 = v27 + Size_1000
	local t1 = {
		text = {
			Size = UDim2.fromScale(1, 0),
			fontStyle = v16.Typography.CaptionMedium
		}
	}
	local t2 = {
		iconFrameStyles = if not v24 then {
			Size = UDim2.fromOffset(if not FFlagAXMigrateBuilderIcons then v16.Size.Size_800 else v16.Size.Size_600, if not FFlagAXMigrateBuilderIcons then v16.Size.Size_800 else v16.Size.Size_600),
			iconSize = IconSize.Small
		} else {
			Size = UDim2.fromOffset(v16.Size.Size_500, v16.Size.Size_500),
			iconSize = IconSize.XSmall
		}
	}
	local t3 = {
		buttonPadding = v16.Padding.Medium,
		contentPadding = UDim.new(0, v16.Padding.Medium)
	}

	if vector2 ~= nil then
		local vector2X = vector2.X
		local v33 = if v17 ~= Responsive.BreakpointConfig.Enum.Medium and v18 ~= Responsive.BreakpointConfig.Enum.Portrait then nil else {
			visibleItemCount = 6,
			itemGap = Small
		}

		if v33 then
			local visibleItemCount = v33.visibleItemCount
			local itemGap = v33.itemGap

			v26 = math.min(math.max(math.floor((vector2X - (visibleItemCount - 1) * itemGap) / visibleItemCount), Size_1600), Size_2100)

			if Size_1600 <= v26 and v26 < Size_2100 then
				t2.iconFrameStyles = if not v24 then {
					Size = UDim2.fromOffset(if not FFlagAXMigrateBuilderIcons then v16.Size.Size_800 else v16.Size.Size_600, if not FFlagAXMigrateBuilderIcons then v16.Size.Size_800 else v16.Size.Size_600),
					iconSize = IconSize.Small
				} else {
					Size = UDim2.fromOffset(v16.Size.Size_500, v16.Size.Size_500),
					iconSize = IconSize.XSmall
				}
				t3 = {
					buttonPadding = v16.Padding.Small,
					contentPadding = UDim.new(0, v16.Padding.Small)
				}
				t1.text.Size = UDim2.fromScale(0.8, 0)
				t1.text.fontStyle = v16.Typography.CaptionSmall
			end

			v27 = v26 + v25 + Medium * 2
			v28 = v27 + Size_1000
		end
	end

	return {
		navHeight = Size_1000,
		itemCardSize = UDim2.fromOffset(v26, v26),
		clearAllButtonStyles = t1,
		navigationFrameHeight = v28,
		slotItemCardThumbnailStyles = t2,
		scrollingFramePadding = t3,
		enableSnapToSelectedSlot = v18 == Responsive.BreakpointConfig.Enum.Landscape,
		slotCardTotalHeight = v27
	}
end
