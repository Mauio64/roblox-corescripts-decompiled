local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local function ShopErrorDialog(props)
	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true
	})

	return React.createElement(Dialog.Root, {
		ref = ref,
		size = DialogSize.Medium,
		hasBackdrop = true,
		disablePortal = false,
		onClose = props.onClose
	}, {
		Title = React.createElement(Dialog.Title, { text = props.title, LayoutOrder = 1 }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			BodyText = React.createElement(Dialog.Text, { Text = props.body })
		}),
		Actions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = props.actionText,
					variant = ButtonVariant.Emphasis,
					onActivated = props.onAction
				}
			}
		})
	})
end

return ShopErrorDialog
