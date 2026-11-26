local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")

local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local itemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceUIKit").ItemCardComponents.ItemCardThumbnail

local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons

local function SlotItemCardThumbnail(props)
	local v5 = useTokens()
	local v6

	if props.icon then
		v6 = if fFlagAXMigrateBuilderIcons then props.icon.name else props.icon
	else
		v6 = Foundation.Enums.IconName.PlusLarge
	end

	local v7

	if fFlagAXMigrateBuilderIcons then
		v7 = if props.icon then props.icon.variant else Foundation.Enums.IconVariant.Regular
	end

	if props.url then
		return React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3 },
			{
				Thumbnail = React.createElement(itemCardThumbnail, { url = props.url }),
				Overlay = props.enableThumbnailOverlay and React.createElement(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundColor3 = v5.Color.Surface.Surface_200.Color3,
						BackgroundTransparency = v5.Color.Common.Shadow.Transparency,
						ZIndex = 2
					},
					{
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v5.Radius.Medium)
						})
					}
				)
			}
		)
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v10

	if props.icon and not props.ignoredUrl then
		local createElement2 = React.createElement
		local v12 = {
			Size = props.iconFrameStyles and props.iconFrameStyles.Size or UDim2.fromOffset(30, 30),
			Position = 0,
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			ZIndex = 2
		}

		local v13 = if fFlagAXMigrateBuilderIcons then UDim2.new(0.5, 4, 0.5, 4) else UDim2.new(0.5, 3, 0.5, 3)
		v12.Position = v13

		v12.BackgroundColor3 = v5.Color.Surface.Surface_200.Color3
		v12.BackgroundTransparency = v5.Color.Surface.Surface_200.Transparency
		v10 = createElement2("Frame", v12, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			AddIcon = React.createElement(icon, {
				name = not fFlagAXMigrateBuilderIcons and "icons/common/plus_heavy_small" or Foundation.Enums.IconName.PlusLarge,
				size = props.iconFrameStyles and props.iconFrameStyles.iconSize or iconSize.Small,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		})
	end

	local createElement2 = React.createElement

	local v13 = if fFlagAXMigrateBuilderIcons then v5.Size.Size_800 else iconSize.Large
	return createElement(fragment, nil, {
		AddIconFrame = v10,
		SlotIcon = createElement2(icon, {
			name = v6,
			variant = v7,
			size = v13,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v5.Color.Shift.Shift_400
		})
	})
end

return SlotItemCardThumbnail
