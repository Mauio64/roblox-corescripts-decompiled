local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local Constants = require(script.Parent.Parent.Constants)
local FoundationText = Foundation.Text
local FFlagAXMigrateBuilderIcons = require(Parent.AvatarExperienceFlags).FFlagAXMigrateBuilderIcons

local function ClearCategoryButton(t1: {[any]: any}) -- line: 33
	-- upvalues: useTokens (copy), React (copy), Icon (copy), FFlagAXMigrateBuilderIcons (copy), Constants (copy), IconSize (copy), FoundationText (copy)
	local v12 = useTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size or UDim2.fromOffset(v12.Size.Size_2500, v12.Size.Size_2500),
		LayoutOrder = t1.LayoutOrder,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}, { React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, -v12.Padding.XSmall)
		}),
		Icon = React.createElement(Icon, {
			name = if not FFlagAXMigrateBuilderIcons then Constants.Icons.Reset else Constants.Icons.Reset.name,
			variant = if not FFlagAXMigrateBuilderIcons then nil else Constants.Icons.Reset.variant,
			size = IconSize.Medium,
			style = {
				Transparency = 0,
				Color3 = v12.Color.Content.Muted.Color3
			}
		}),
		Text = if not t1.text then nil else React.createElement(FoundationText, {
			TextWrapped = true,
			Size = t1.textStyles and t1.textStyles.Size or UDim2.fromScale(1, 0),
			Text = t1.text,
			AutomaticSize = Enum.AutomaticSize.Y,
			fontStyle = t1.textStyles and t1.textStyles.fontStyle or v12.Typography.CaptionMedium,
			padding = UDim.new(0, v12.Padding.Small)
		})
	}) })
end

return ClearCategoryButton
