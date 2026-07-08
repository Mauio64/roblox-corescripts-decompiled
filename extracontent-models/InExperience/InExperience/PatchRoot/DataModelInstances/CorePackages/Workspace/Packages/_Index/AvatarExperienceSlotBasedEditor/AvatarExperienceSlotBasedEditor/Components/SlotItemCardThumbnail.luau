local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens
local ItemCardThumbnail = require(Parent.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons

local function SlotItemCardThumbnail(t1: {[any]: any}) -- line: 40
	-- upvalues: useTokens (copy), FFlagAXCustomizeMakeupSupport (copy), FFlagAXMigrateBuilderIcons (copy), Foundation (copy), React (copy), ItemCardThumbnail (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Icon (copy), IconSize (copy)
	local v14 = useTokens()
	local v15 = if not FFlagAXCustomizeMakeupSupport then nil else if not t1.icon then Foundation.Enums.IconName.PlusLarge else if not FFlagAXMigrateBuilderIcons then t1.icon else t1.icon.name
	local v16 = if not FFlagAXCustomizeMakeupSupport or not FFlagAXMigrateBuilderIcons then nil else if not t1.icon then Foundation.Enums.IconVariant.Regular else t1.icon.variant

	if t1.url then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			Size = UDim2.fromScale(1, 1)
		}, {
			Thumbnail = React.createElement(ItemCardThumbnail, {
				url = t1.url
			}),
			Overlay = t1.enableThumbnailOverlay and React.createElement("Frame", {
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v14.Color.Surface.Surface_200.Color3,
				BackgroundTransparency = v14.Color.Common.Shadow.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Radius.Medium else v14.Radius.Medium)
				})
			})
		})
	end

	return React.createElement(React.Fragment, nil, {
		AddIconFrame = if not t1.icon or t1.ignoredUrl then nil else React.createElement("Frame", {
			ZIndex = 2,
			Size = t1.iconFrameStyles and t1.iconFrameStyles.Size or UDim2.fromOffset(30, 30),
			Position = if not FFlagAXMigrateBuilderIcons then UDim2.new(0.5, 3, 0.5, 3) else UDim2.new(0.5, 4, 0.5, 4),
			BackgroundColor3 = v14.Color.Surface.Surface_200.Color3,
			BackgroundTransparency = v14.Color.Surface.Surface_200.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			AddIcon = React.createElement(Icon, {
				name = not FFlagAXMigrateBuilderIcons and "icons/common/plus_heavy_small" or Foundation.Enums.IconName.PlusLarge,
				size = t1.iconFrameStyles and t1.iconFrameStyles.iconSize or IconSize.Small,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			})
		}),
		SlotIcon = (FFlagAXCustomizeMakeupSupport or t1.icon) and React.createElement(Icon, {
			name = if not FFlagAXCustomizeMakeupSupport then if not FFlagAXMigrateBuilderIcons then t1.icon else t1.icon.name else v15,
			variant = if not FFlagAXCustomizeMakeupSupport then if not FFlagAXMigrateBuilderIcons then nil else t1.icon.variant else v16,
			size = if not FFlagAXMigrateBuilderIcons then IconSize.Large else v14.Size.Size_800,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v14.Color.Shift.Shift_400
		})
	})
end

return SlotItemCardThumbnail
