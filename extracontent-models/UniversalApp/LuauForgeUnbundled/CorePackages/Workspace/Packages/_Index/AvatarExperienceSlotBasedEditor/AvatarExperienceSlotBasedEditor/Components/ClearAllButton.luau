local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")
local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Constants")
local text = Foundation.Text

local fFlagAXMigrateBuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXMigrateBuilderIcons

local function ClearCategoryButton(props)
	local v5 = useTokens()

	local createElement = React.createElement
	local v7 = {
		Size = props.Size or UDim2.fromOffset(v5.Size.Size_2500, v5.Size.Size_2500),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}

	local createElement2 = React.createElement
	local v10 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local v11 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, -v5.Padding.XSmall)
		}),
		Icon = 0,
		Text = 0
	}

	local createElement3 = React.createElement

	local v14 = if fFlagAXMigrateBuilderIcons then Constants.Icons.Reset.name else Constants.Icons.Reset

	local v15 = if fFlagAXMigrateBuilderIcons then Constants.Icons.Reset.variant else nil
	v11.Icon = createElement3(icon, {
		name = v14,
		variant = v15,
		size = iconSize.Medium,
		style = { Color3 = v5.Color.Content.Muted.Color3, Transparency = 0 }
	})

	local v16 = if props.text then React.createElement(text, {
		Size = props.textStyles and props.textStyles.Size or UDim2.fromScale(1, 0),
		Text = props.text,
		TextWrapped = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		fontStyle = props.textStyles and props.textStyles.fontStyle or v5.Typography.CaptionMedium,
		padding = UDim.new(0, v5.Padding.Small)
	}) else nil
	v11.Text = v16
	return createElement("Frame", v7, { createElement2("Frame", v10, v11) })
end

return ClearCategoryButton
