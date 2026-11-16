local parent = script:FindFirstAncestor("EditProfile").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Text = Foundation.Text
local View = Foundation.View
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local function EditProfileHeaderBar(props)
	local v = useTokens()
	local createElement = React.createElement
	local v2 = {
		tag = "row flex-between align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge",
		padding = { top = UDim.new(0, v.Margin.Large) }
	}
	local v3 = {
		HeaderBar = React.createElement(View, {
			tag = "row align-y-center size-0-1800 auto-x gap-small"
		}, {
			BackButton = React.createElement(IconButton, {
				icon = IconName.ChevronLargeLeft,
				size = IconSize.Medium,
				variant = ButtonVariant.Utility,
				onActivated = props.onClose,
				isCircular = true,
				LayoutOrder = 1
			}),
			HeaderText = React.createElement(Text, {
				tag = "text-heading-small auto-xy",
				Text = props.headerText,
				LayoutOrder = 2
			})
		}),
		SaveButton = 0
	}
	local saveButton

	if props.onSave then
		saveButton = React.createElement(IconButton, {
			icon = IconName.CheckLarge,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = props.onSave,
			isDisabled = props.isLoading or props.isDisabled == true,
			isCircular = true
		})
	end

	v3.SaveButton = saveButton
	return createElement(View, v2, v3)
end

return EditProfileHeaderBar
