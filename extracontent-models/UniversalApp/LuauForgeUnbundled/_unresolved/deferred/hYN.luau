local CorePackages = game:GetService("CorePackages")

local Foundation = require(CorePackages.Packages.Foundation)
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local text = Foundation.Text
local view = Foundation.View

local React = require(CorePackages.Packages.React)

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/bundled/hYO")
local constants = module.Constants
local getReminderVariantBodyKey = module.getReminderVariantBodyKey

local function ReminderOfNormsPopup(props)
	local v5 = useLocalization({
		policyViolation = `{constants.LocalizationKeyPrefix}.{props.policyViolation}`
	})

	local v6 = useLocalization({
		sharedBody = {
			constants.LocalizationKeys.SharedBody,
			policy_violation = v5.policyViolation
		},
		variantBody = getReminderVariantBodyKey(props.contentVariant),
		reminderTitle = constants.LocalizationKeys.ReminderTitle,
		buttonText = constants.LocalizationKeys.ButtonText
	})

	local createElement = React.createElement
	local root = dialog.Root
	local v7 = {
		size = dialogSize.Small,
		hasBackdrop = true,
		closeOnClickOutside = true,
		onClose = props.onDismiss
	}
	local children = {
		DialogTitle = React.createElement(dialog.Title, {
			LayoutOrder = 1,
			text = v6.reminderTitle
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement

	local v12 = {
		SharedBody = React.createElement(text, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
			Text = v6.sharedBody
		}),
		VariantBody = 0
	}

	local v13 = v6.variantBody

	if v13 then
		if v6.variantBody == "" then
			v13 = false
		else
			v13 = React.createElement(text, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left",
				Text = v6.variantBody
			})
		end
	end

	v12.VariantBody = v13
	children.DialogContent = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(view, { tag = "col gap-medium size-full-0 auto-y" }, v12)
	})

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				variant = buttonVariant.Emphasis,
				text = v6.buttonText,
				onActivated = props.onClose
			}
		}
	})
	return createElement(root, v7, children)
end

return React.memo(ReminderOfNormsPopup)
