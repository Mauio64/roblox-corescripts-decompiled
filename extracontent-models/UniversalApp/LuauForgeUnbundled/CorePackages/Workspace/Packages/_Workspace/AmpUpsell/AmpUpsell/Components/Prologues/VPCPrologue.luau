local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local vpcPrologueStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/LocalizationStrings").vpcPrologueStrings
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")

local GetFFlagEnableReusableVPCPrologue = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableReusableVPCPrologue")

local function getBodyLocalizationKey(data)
	if not data then
		return vpcPrologueStrings.bodyGeneric
	end

	if data.enablePurchases == true then
		return vpcPrologueStrings.bodyPurchases
	end

	if data.contentAgeRestriction ~= nil then
		return vpcPrologueStrings.bodyContentRestriction
	end

	if data.friendManagementAction == "Unblock" then
		return vpcPrologueStrings.bodyUnblock
	end

	return vpcPrologueStrings.bodyGeneric
end

local function ConfigurableVPCPrologue(props)
	local config = props.config or {}
	local v6 = {
		title = vpcPrologueStrings.title,
		body = 0,
		buttonAsk = 0,
		buttonCancel = 0
	}
	local recourseData = props.recourseData
	local v7

	if recourseData then
		if recourseData.enablePurchases == true then
			v7 = vpcPrologueStrings.bodyPurchases
		elseif recourseData.contentAgeRestriction == nil then
			if recourseData.friendManagementAction == "Unblock" then
				v7 = vpcPrologueStrings.bodyUnblock
			else
				v7 = vpcPrologueStrings.bodyGeneric
			end
		else
			v7 = vpcPrologueStrings.bodyContentRestriction
		end
	else
		v7 = vpcPrologueStrings.bodyGeneric
	end

	v6.body = v7
	v6.buttonAsk = vpcPrologueStrings.buttonAsk
	v6.buttonCancel = vpcPrologueStrings.buttonCancel
	local v8 = useLocalization(v6)

	local v9 = {
		{
			text = config.confirmText or v8.buttonAsk,
			variant = buttonVariant.Emphasis,
			onActivated = props.onConfirm
		}
	}

	if not config.hideCancel then
		table.insert(v9, config.cancelFirst and 1 or 2, {
			text = config.cancelText or v8.buttonCancel,
			variant = buttonVariant.Standard,
			onActivated = props.onCancel
		})
	end

	local v10 = not config.omitLayoutOrder

	local createElement = React.createElement
	local root = dialog.Root
	local v12 = if config.dialogSize == "Medium" then dialogSize.Medium else dialogSize.Small
	local v11 = {
		size = v12,
		hasBackdrop = config.hasBackdrop,
		closeOnClickOutside = config.closeOnClickOutside,
		onClose = 0
	}
	local v13

	if config.onClose then
		v13 = config.onClose
	elseif config.onCloseCancels then
		v13 = props.onCancel
	end

	v11.onClose = v13
	local children = {
		Title = React.createElement(dialog.Title, {
			LayoutOrder = v10 and 1 or nil,
			text = config.titleText or v8.title
		}),
		Content = React.createElement(dialog.Content, {
			LayoutOrder = v10 and 2 or nil
		}, {
			Text = config.bodyContent or React.createElement(dialog.Text, {
				Text = config.bodyText or v8.body
			})
		}),
		Buttons = 0
	}

	local createElement3 = React.createElement
	local actions = dialog.Actions
	local v15 = {
		LayoutOrder = v10 and 3 or nil,
		orientation = 0,
		actions = 0
	}
	local v16

	if config.actionOrientation == "Vertical" then
		v16 = orientation.Vertical
	elseif config.actionOrientation == "Horizontal" then
		v16 = orientation.Horizontal
	end

	v15.orientation = v16

	v15.actions = v9
	children.Buttons = createElement3(actions, v15)
	return createElement(root, v11, children)
end

local function LegacyVPCPrologue(props)
	local recourseData = props.recourseData
	local v5

	if recourseData then
		if recourseData.enablePurchases == true then
			v5 = vpcPrologueStrings.bodyPurchases
		elseif recourseData.contentAgeRestriction == nil then
			if recourseData.friendManagementAction == "Unblock" then
				v5 = vpcPrologueStrings.bodyUnblock
			else
				v5 = vpcPrologueStrings.bodyGeneric
			end
		else
			v5 = vpcPrologueStrings.bodyContentRestriction
		end
	else
		v5 = vpcPrologueStrings.bodyGeneric
	end

	local v6 = useLocalization({
		title = vpcPrologueStrings.title,
		body = v5,
		buttonAsk = vpcPrologueStrings.buttonAsk,
		buttonCancel = vpcPrologueStrings.buttonCancel
	})

	return React.createElement(dialog.Root, { size = dialogSize.Small }, {
		Title = React.createElement(dialog.Title, { LayoutOrder = 1, text = v6.title }),
		Content = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
			Text = React.createElement(dialog.Text, { Text = v6.body })
		}),
		Buttons = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v6.buttonAsk,
					variant = buttonVariant.Emphasis,
					onActivated = props.onConfirm
				},
				{
					text = v6.buttonCancel,
					variant = buttonVariant.Standard,
					onActivated = props.onCancel
				}
			}
		})
	})
end

local function VPCPrologue(p2)
	local createElement = React.createElement
	local v5 = if GetFFlagEnableReusableVPCPrologue() then ConfigurableVPCPrologue else LegacyVPCPrologue
	return createElement(v5, p2)
end

return VPCPrologue
