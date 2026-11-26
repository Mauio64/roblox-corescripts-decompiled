local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Responsive")
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons

local function getItemWidth(p2, p3, p4)
	return (math.floor((p2 - (p3 - 1) * p4) / p3))
end

local function getItemCardWidthParameters(p2, p3, p4)
	if p3 == Responsive.BreakpointConfig.Enum.Medium or p4 == Responsive.BreakpointConfig.Enum.Portrait then
		return { visibleItemCount = 6, itemGap = p2 }
	end

	return nil
end

return function(p2)
	local v5 = useTokens()
	local v6 = Responsive.useResponsive()
	local v7 = Responsive.useOrientation()
	local small = v5.Gap.Small
	local size_1600 = v5.Size.Size_1600
	local size_2100 = v5.Size.Size_2100

	local medium = v5.Padding.Medium
	local size_1000 = v5.Size.Size_1000
	local v8 = v7 == Responsive.BreakpointConfig.Enum.Portrait

	local v10 = (if v8 then v5.Typography.CaptionSmall else v5.Typography.CaptionMedium).FontSize + v5.Gap.Small
	local v11 = if v7 == Responsive.BreakpointConfig.Enum.Portrait then size_1600 else size_2100

	local v12 = v11 + v10 + medium * 2
	local v13 = v12 + size_1000

	local v14 = {
		text = { Size = UDim2.fromScale(1, 0), fontStyle = v5.Typography.CaptionMedium }
	}
	local v16

	if v8 then
		v16 = {
			Size = UDim2.fromOffset(v5.Size.Size_500, v5.Size.Size_500),
			iconSize = iconSize.XSmall
		}
	else
		v16 = { Size = 0, iconSize = 0 }
		local fromOffset = UDim2.fromOffset
		local v17 = if fFlagAXMigrateBuilderIcons then v5.Size.Size_600 else v5.Size.Size_800
		local v18 = if fFlagAXMigrateBuilderIcons then v5.Size.Size_600 else v5.Size.Size_800
		v16.Size = fromOffset(v17, v18)

		v16.iconSize = iconSize.Small
	end

	local v15 = { iconFrameStyles = v16 }

	local v17 = {
		buttonPadding = v5.Padding.Medium,
		contentPadding = UDim.new(0, v5.Padding.Medium)
	}

	if p2 ~= nil then
		local x = p2.X
		local v18 = (v6 == Responsive.BreakpointConfig.Enum.Medium or v7 == Responsive.BreakpointConfig.Enum.Portrait)
			and { visibleItemCount = 6, itemGap = small }
			or nil

		if v18 then
			local visibleItemCount = v18.visibleItemCount
			local itemGap = v18.itemGap
			v11 = math.min(
				math.max(math.floor((x - (visibleItemCount - 1) * itemGap) / visibleItemCount), size_1600),
				size_2100
			)

			if size_1600 <= v11 and v11 < size_2100 then
				local v19

				if v8 then
					v19 = {
						Size = UDim2.fromOffset(v5.Size.Size_500, v5.Size.Size_500),
						iconSize = iconSize.XSmall
					}
				else
					v19 = { Size = 0, iconSize = 0 }
					local fromOffset = UDim2.fromOffset
					local v20 = if fFlagAXMigrateBuilderIcons then v5.Size.Size_600 else v5.Size.Size_800
					local v21 = if fFlagAXMigrateBuilderIcons then v5.Size.Size_600 else v5.Size.Size_800
					v19.Size = fromOffset(v20, v21)

					v19.iconSize = iconSize.Small
				end

				v15.iconFrameStyles = v19

				v17 = {
					buttonPadding = v5.Padding.Small,
					contentPadding = UDim.new(0, v5.Padding.Small)
				}

				v14.text.Size = UDim2.fromScale(0.8, 0)
				v14.text.fontStyle = v5.Typography.CaptionSmall
			end

			v12 = v11 + v10 + medium * 2
			v13 = v12 + size_1000
		end
	end

	return {
		navHeight = size_1000,
		itemCardSize = UDim2.fromOffset(v11, v11),
		clearAllButtonStyles = v14,
		navigationFrameHeight = v13,
		slotItemCardThumbnailStyles = v15,
		scrollingFramePadding = v17,
		enableSnapToSelectedSlot = v7 == Responsive.BreakpointConfig.Enum.Landscape,
		slotCardTotalHeight = v12
	}
end
