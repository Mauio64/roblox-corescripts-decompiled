local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport

local function getItemWidth(n1: number, n2: number, n3: number) -- line: 24
	return (math.floor((n1 - (n2 - 1) * n3) / n2))
end
local function getItemCardWidthParameters(n4: number, s1: string, s2: string) -- line: 30
	-- upvalues: Responsive (copy)
	if s1 == Responsive.BreakpointConfig.Enum.Medium or s2 == Responsive.BreakpointConfig.Enum.Portrait then
		return {
			visibleItemCount = 6,
			itemGap = n4
		}
	end

	return nil
end

return function(vector2: Vector2?) -- line: 51
	-- upvalues: useTokens (copy), Responsive (copy), FFlagAXCustomizeMakeupSupport (copy), IconSize (copy), FFlagAXMigrateBuilderIcons (copy)
	local v18 = useTokens()
	local v19 = Responsive.useResponsive()
	local v20 = Responsive.useOrientation()
	local Small = v18.Gap.Small
	local Size_1600 = v18.Size.Size_1600
	local Size_2100 = v18.Size.Size_2100
	local Medium = v18.Padding.Medium
	local Size_1000 = v18.Size.Size_1000
	local v26 = v20 == Responsive.BreakpointConfig.Enum.Portrait
	local v27 = ((if not not FFlagAXCustomizeMakeupSupport and not v26 then v18.Typography.CaptionMedium else v18.Typography.CaptionSmall)).FontSize + v18.Gap.Small
	local v28 = if v20 ~= Responsive.BreakpointConfig.Enum.Portrait then Size_2100 else Size_1600
	local v29 = v28 + v27 + Medium * 2
	local v30 = v29 + Size_1000
	local t1 = {
		text = {
			Size = UDim2.fromScale(1, 0),
			fontStyle = v18.Typography.CaptionMedium
		}
	}
	local t2 = {
		iconFrameStyles = if not v26 then {
			Size = UDim2.fromOffset(if not FFlagAXMigrateBuilderIcons then v18.Size.Size_800 else v18.Size.Size_600, if not FFlagAXMigrateBuilderIcons then v18.Size.Size_800 else v18.Size.Size_600),
			iconSize = IconSize.Small
		} else {
			Size = UDim2.fromOffset(v18.Size.Size_500, v18.Size.Size_500),
			iconSize = IconSize.XSmall
		}
	}
	local t3 = {
		buttonPadding = v18.Padding.Medium,
		contentPadding = UDim.new(0, v18.Padding.Medium)
	}

	if vector2 ~= nil then
		local vector2X = vector2.X
		local v35 = if v19 ~= Responsive.BreakpointConfig.Enum.Medium and v20 ~= Responsive.BreakpointConfig.Enum.Portrait then nil else {
			visibleItemCount = 6,
			itemGap = Small
		}

		if v35 then
			local visibleItemCount = v35.visibleItemCount
			local itemGap = v35.itemGap

			v28 = math.min(math.max(math.floor((vector2X - (visibleItemCount - 1) * itemGap) / visibleItemCount), Size_1600), Size_2100)

			if Size_1600 <= v28 and v28 < Size_2100 then
				t2.iconFrameStyles = if not v26 then {
					Size = UDim2.fromOffset(if not FFlagAXMigrateBuilderIcons then v18.Size.Size_800 else v18.Size.Size_600, if not FFlagAXMigrateBuilderIcons then v18.Size.Size_800 else v18.Size.Size_600),
					iconSize = IconSize.Small
				} else {
					Size = UDim2.fromOffset(v18.Size.Size_500, v18.Size.Size_500),
					iconSize = IconSize.XSmall
				}
				t3 = {
					buttonPadding = v18.Padding.Small,
					contentPadding = UDim.new(0, v18.Padding.Small)
				}
				t1.text.Size = UDim2.fromScale(0.8, 0)
				t1.text.fontStyle = v18.Typography.CaptionSmall
			end

			v29 = v28 + v27 + Medium * 2
			v30 = v29 + Size_1000
		end
	end

	return {
		navHeight = Size_1000,
		itemCardSize = UDim2.fromOffset(v28, v28),
		clearAllButtonStyles = t1,
		navigationFrameHeight = v30,
		slotItemCardThumbnailStyles = t2,
		scrollingFramePadding = t3,
		enableSnapToSelectedSlot = v20 == Responsive.BreakpointConfig.Enum.Landscape,
		slotCardTotalHeight = v29
	}
end
