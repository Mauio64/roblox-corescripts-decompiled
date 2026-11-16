local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local text = Foundation.Text
local view = Foundation.View
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local function EditProfileHeaderBar(props)
	local v5 = useTokens()
	local createElement = React.createElement
	local v7 = {
		tag = "row flex-between align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		padding = { top = UDim.new(0, v5.Margin.Large) }
	}
	local v8 = {
		HeaderBar = React.createElement(
			view,
			{ tag = "row align-y-center size-0-1800 auto-x gap-small" },
			{
				BackButton = React.createElement(iconButton, {
					icon = iconName.ChevronLargeLeft,
					size = iconSize.Medium,
					variant = buttonVariant.Utility,
					onActivated = props.onClose,
					isCircular = true,
					LayoutOrder = 1
				}),
				HeaderText = React.createElement(text, {
					tag = "text-heading-small auto-xy",
					Text = props.headerText,
					LayoutOrder = 2
				})
			}
		),
		SaveButton = 0
	}

	local v9 = if props.onSave then React.createElement(iconButton, {
		icon = iconName.CheckLarge,
		size = iconSize.Medium,
		variant = buttonVariant.Utility,
		onActivated = props.onSave,
		isDisabled = props.isLoading or props.isDisabled == true,
		isCircular = true
	}) else nil
	v8.SaveButton = v9
	return createElement(view, v7, v8)
end

return EditProfileHeaderBar
