local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local LocalizationStrings = require(AmpUpsell.Common.LocalizationStrings)
local vpcPrologueStrings = LocalizationStrings.vpcPrologueStrings
require(AmpUpsell.Common.Types)

local GetFFlagEnableReusableVPCPrologue = require(AmpUpsell.Flags.GetFFlagEnableReusableVPCPrologue)

local function getBodyLocalizationKey(recourseData) -- 2 equivalent calls inferred from this helper
	if not recourseData then
		return vpcPrologueStrings.bodyGeneric
	end

	if recourseData.enablePurchases == true then
		return vpcPrologueStrings.bodyPurchases
	end

	if recourseData.contentAgeRestriction ~= nil then
		return vpcPrologueStrings.bodyContentRestriction
	end

	if recourseData.friendManagementAction == "Unblock" then
		return vpcPrologueStrings.bodyUnblock
	end

	return vpcPrologueStrings.bodyGeneric
end

local function ConfigurableVPCPrologue(props)
	local config = props.config or {}
	local v = useLocalization({
		title = vpcPrologueStrings.title,
		body = getBodyLocalizationKey(props.recourseData), -- inferred equivalent call
		buttonAsk = vpcPrologueStrings.buttonAsk,
		buttonCancel = vpcPrologueStrings.buttonCancel
	})

	local actions2 = {
		{
			text = config.confirmText or v.buttonAsk,
			variant = ButtonVariant.Emphasis,
			onActivated = props.onConfirm
		}
	}

	if not config.hideCancel then
		table.insert(actions2, config.cancelFirst and 1 or 2, {
			text = config.cancelText or v.buttonCancel,
			variant = ButtonVariant.Standard,
			onActivated = props.onCancel
		})
	end

	local v2 = not config.omitLayoutOrder

	local createElement = React.createElement
	local root = Dialog.Root
	local size

	if config.dialogSize == "Medium" then
		size = DialogSize.Medium
	else
		size = DialogSize.Small
	end

	local v3 = {
		size = size,
		hasBackdrop = config.hasBackdrop,
		closeOnClickOutside = config.closeOnClickOutside,
		onClose = 0
	}
	local onClose

	if config.onClose then
		onClose = config.onClose
	elseif config.onCloseCancels then
		onClose = props.onCancel
	end

	v3.onClose = onClose
	local children = {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = v2 and 1 or nil,
			text = config.titleText or v.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = v2 and 2 or nil
		}, {
			Text = config.bodyContent or React.createElement(Dialog.Text, {
				Text = config.bodyText or v.body
			})
		}),
		Buttons = 0
	}

	local createElement2 = React.createElement
	local actions = Dialog.Actions
	local v4 = {
		LayoutOrder = v2 and 3 or nil,
		orientation = 0,
		actions = 0
	}
	local orientation

	if config.actionOrientation == "Vertical" then
		orientation = Orientation.Vertical
	elseif config.actionOrientation == "Horizontal" then
		orientation = Orientation.Horizontal
	end

	v4.orientation = orientation

	v4.actions = actions2
	children.Buttons = createElement2(actions, v4)
	return createElement(root, v3, children)
end

local function LegacyVPCPrologue(props)
	local bodyLocalizationKey = getBodyLocalizationKey(props.recourseData) -- inferred equivalent call
	local v = useLocalization({
		title = vpcPrologueStrings.title,
		body = bodyLocalizationKey,
		buttonAsk = vpcPrologueStrings.buttonAsk,
		buttonCancel = vpcPrologueStrings.buttonCancel
	})

	return React.createElement(Dialog.Root, { size = DialogSize.Small }, {
		Title = React.createElement(Dialog.Title, { LayoutOrder = 1, text = v.title }),
		Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
			Text = React.createElement(Dialog.Text, { Text = v.body })
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v.buttonAsk,
					variant = ButtonVariant.Emphasis,
					onActivated = props.onConfirm
				},
				{
					text = v.buttonCancel,
					variant = ButtonVariant.Standard,
					onActivated = props.onCancel
				}
			}
		})
	})
end

local function VPCPrologue(p)
	local createElement = React.createElement
	local v

	if GetFFlagEnableReusableVPCPrologue() then
		v = ConfigurableVPCPrologue
	else
		v = LegacyVPCPrologue
	end

	return createElement(v, p)
end

return VPCPrologue
