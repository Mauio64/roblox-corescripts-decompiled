local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Constants = require(script.Parent.Parent.Constants)
local Text = Foundation.Text

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons

local function ClearCategoryButton(props)
	local v = useTokens()

	local createElement = React.createElement
	local v2 = {
		Size = props.Size or UDim2.fromOffset(v.Size.Size_2500, v.Size.Size_2500),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}

	local createElement2 = React.createElement
	local v3 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local v4 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, -v.Padding.XSmall)
		}),
		Icon = 0,
		Text = 0
	}

	local createElement3 = React.createElement
	local name

	if FFlagAXMigrateBuilderIcons then
		name = Constants.Icons.Reset.name
	else
		name = Constants.Icons.Reset
	end

	local variant

	if FFlagAXMigrateBuilderIcons then
		variant = Constants.Icons.Reset.variant
	end

	v4.Icon = createElement3(Icon, {
		name = name,
		variant = variant,
		size = IconSize.Medium,
		style = { Color3 = v.Color.Content.Muted.Color3, Transparency = 0 }
	})
	local text

	if props.text then
		text = React.createElement(Text, {
			Size = props.textStyles and props.textStyles.Size or UDim2.fromScale(1, 0),
			Text = props.text,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = props.textStyles and props.textStyles.fontStyle or v.Typography.CaptionMedium,
			padding = UDim.new(0, v.Padding.Small)
		})
	end

	v4.Text = text
	return createElement("Frame", v2, { createElement2("Frame", v3, v4) })
end

return ClearCategoryButton
