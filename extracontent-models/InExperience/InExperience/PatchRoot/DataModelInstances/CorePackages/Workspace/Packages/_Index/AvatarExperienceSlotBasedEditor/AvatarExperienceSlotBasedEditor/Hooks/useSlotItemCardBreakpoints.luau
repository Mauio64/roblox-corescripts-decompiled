local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons

local function getItemWidth(x: number, visibleItemCount: number, itemGap: number) -- 1 equivalent call inferred from this helper
	return (math.floor((x - (visibleItemCount - 1) * itemGap) / visibleItemCount))
end

local function getItemCardWidthParameters(small: number, p: string, p2: string) -- 1 equivalent call inferred from this helper
	if p == Responsive.BreakpointConfig.Enum.Medium or p2 == Responsive.BreakpointConfig.Enum.Portrait then
		return { visibleItemCount = 6, itemGap = small }
	end

	return nil
end

return function(vector2: Vector2?)
	local v = useTokens()
	local v2 = Responsive.useResponsive()
	local v3 = Responsive.useOrientation()
	local small = v.Gap.Small
	local size_1600 = v.Size.Size_1600
	local size_2100 = v.Size.Size_2100

	local medium = v.Padding.Medium
	local size_1000 = v.Size.Size_1000
	local v4 = v3 == Responsive.BreakpointConfig.Enum.Portrait
	local v5

	if v4 then
		v5 = v.Typography.CaptionSmall
	else
		v5 = v.Typography.CaptionMedium
	end

	local v6 = v5.FontSize + v.Gap.Small
	local v7

	if v3 == Responsive.BreakpointConfig.Enum.Portrait then
		v7 = size_1600
	else
		v7 = size_2100
	end

	local slotCardTotalHeight = v7 + v6 + medium * 2
	local navigationFrameHeight = slotCardTotalHeight + size_1000

	local clearAllButtonStyles = {
		text = { Size = UDim2.fromScale(1, 0), fontStyle = v.Typography.CaptionMedium }
	}
	local iconFrameStyles

	if v4 then
		iconFrameStyles = {
			Size = UDim2.fromOffset(v.Size.Size_500, v.Size.Size_500),
			iconSize = IconSize.XSmall
		}
	else
		iconFrameStyles = { Size = 0, iconSize = 0 }
		local v8

		if FFlagAXMigrateBuilderIcons then
			v8 = v.Size.Size_600
		else
			v8 = v.Size.Size_800
		end

		local v9

		if FFlagAXMigrateBuilderIcons then
			v9 = v.Size.Size_600
		else
			v9 = v.Size.Size_800
		end

		iconFrameStyles.Size = UDim2.fromOffset(v8, v9)

		iconFrameStyles.iconSize = IconSize.Small
	end

	local slotItemCardThumbnailStyles = { iconFrameStyles = iconFrameStyles }

	local scrollingFramePadding = {
		buttonPadding = v.Padding.Medium,
		contentPadding = UDim.new(0, v.Padding.Medium)
	}

	if vector2 ~= nil then
		local x = vector2.X
		local itemCardWidthParameters = getItemCardWidthParameters(small, v2, v3) -- inferred equivalent call

		if itemCardWidthParameters then
			v7 = math.min(
				math.max(
					getItemWidth(x, itemCardWidthParameters.visibleItemCount, itemCardWidthParameters.itemGap), -- inferred equivalent call
					size_1600
				),
				size_2100
			)

			if size_1600 <= v7 and v7 < size_2100 then
				local iconFrameStyles2

				if v4 then
					iconFrameStyles2 = {
						Size = UDim2.fromOffset(v.Size.Size_500, v.Size.Size_500),
						iconSize = IconSize.XSmall
					}
				else
					iconFrameStyles2 = { Size = 0, iconSize = 0 }
					local v8

					if FFlagAXMigrateBuilderIcons then
						v8 = v.Size.Size_600
					else
						v8 = v.Size.Size_800
					end

					local v9

					if FFlagAXMigrateBuilderIcons then
						v9 = v.Size.Size_600
					else
						v9 = v.Size.Size_800
					end

					iconFrameStyles2.Size = UDim2.fromOffset(v8, v9)

					iconFrameStyles2.iconSize = IconSize.Small
				end

				slotItemCardThumbnailStyles.iconFrameStyles = iconFrameStyles2

				scrollingFramePadding = {
					buttonPadding = v.Padding.Small,
					contentPadding = UDim.new(0, v.Padding.Small)
				}

				clearAllButtonStyles.text.Size = UDim2.fromScale(0.8, 0)
				clearAllButtonStyles.text.fontStyle = v.Typography.CaptionSmall
			end

			slotCardTotalHeight = v7 + v6 + medium * 2
			navigationFrameHeight = slotCardTotalHeight + size_1000
		end
	end

	return {
		navHeight = size_1000,
		itemCardSize = UDim2.fromOffset(v7, v7),
		clearAllButtonStyles = clearAllButtonStyles,
		navigationFrameHeight = navigationFrameHeight,
		slotItemCardThumbnailStyles = slotItemCardThumbnailStyles,
		scrollingFramePadding = scrollingFramePadding,
		enableSnapToSelectedSlot = v3 == Responsive.BreakpointConfig.Enum.Landscape,
		slotCardTotalHeight = slotCardTotalHeight
	}
end
