local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceUIKit = require(parent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons

local function SlotItemCardThumbnail(props)
	local v = useTokens()
	local name

	if props.icon then
		if FFlagAXMigrateBuilderIcons then
			name = props.icon.name
		else
			name = props.icon
		end
	else
		name = Foundation.Enums.IconName.PlusLarge
	end

	local variant

	if FFlagAXMigrateBuilderIcons then
		if props.icon then
			variant = props.icon.variant
		else
			variant = Foundation.Enums.IconVariant.Regular
		end
	end

	if props.url then
		return React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 3
		}, {
			Thumbnail = React.createElement(ItemCardThumbnail, { url = props.url }),
			Overlay = props.enableThumbnailOverlay and React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = v.Color.Surface.Surface_200.Color3,
					BackgroundTransparency = v.Color.Common.Shadow.Transparency,
					ZIndex = 2
				},
				{
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v.Radius.Medium)
					})
				}
			)
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local addIconFrame

	if props.icon and not props.ignoredUrl then
		local createElement2 = React.createElement
		local v2 = {
			Size = props.iconFrameStyles and props.iconFrameStyles.Size or UDim2.fromOffset(30, 30),
			Position = 0,
			BackgroundColor3 = 0,
			BackgroundTransparency = 0,
			ZIndex = 2
		}
		local position

		if FFlagAXMigrateBuilderIcons then
			position = UDim2.new(0.5, 4, 0.5, 4)
		else
			position = UDim2.new(0.5, 3, 0.5, 3)
		end

		v2.Position = position

		v2.BackgroundColor3 = v.Color.Surface.Surface_200.Color3
		v2.BackgroundTransparency = v.Color.Surface.Surface_200.Transparency
		addIconFrame = createElement2("Frame", v2, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			AddIcon = React.createElement(Icon, {
				name = not FFlagAXMigrateBuilderIcons and "icons/common/plus_heavy_small" or Foundation.Enums.IconName.PlusLarge,
				size = props.iconFrameStyles and props.iconFrameStyles.iconSize or IconSize.Small,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		})
	end

	local createElement2 = React.createElement
	local size

	if FFlagAXMigrateBuilderIcons then
		size = v.Size.Size_800
	else
		size = IconSize.Large
	end

	return createElement(fragment, nil, {
		AddIconFrame = addIconFrame,
		SlotIcon = createElement2(Icon, {
			name = name,
			variant = variant,
			size = size,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v.Color.Shift.Shift_400
		})
	})
end

return SlotItemCardThumbnail
