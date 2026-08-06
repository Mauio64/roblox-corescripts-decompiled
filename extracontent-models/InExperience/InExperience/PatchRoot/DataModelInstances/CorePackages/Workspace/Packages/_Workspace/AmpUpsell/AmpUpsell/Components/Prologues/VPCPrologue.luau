local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local Foundation = require(AmpUpsellParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local vpcPrologueStrings = require(AmpUpsell.Common.LocalizationStrings).vpcPrologueStrings

require(AmpUpsell.Common.Types)

local GetFFlagEnableReusableVPCPrologue = require(AmpUpsell.Flags.GetFFlagEnableReusableVPCPrologue)

local function getBodyLocalizationKey(p1) -- line: 27
	-- upvalues: vpcPrologueStrings (copy)
	if p1 then
		if p1.enablePurchases == true then
			return vpcPrologueStrings.bodyPurchases
		end

		if p1.contentAgeRestriction ~= nil then
			return vpcPrologueStrings.bodyContentRestriction
		end

		if p1.friendManagementAction == "Unblock" then
			return vpcPrologueStrings.bodyUnblock
		end
	end

	return vpcPrologueStrings.bodyGeneric
end
local function ConfigurableVPCPrologue(t1: {[any]: any}) -- line: 40
	-- upvalues: useLocalization (copy), vpcPrologueStrings (copy), ButtonVariant (copy), React (copy), Dialog (copy), DialogSize (copy), EnumsOrientation (copy)
	local v18 = t1.config or {}
	local v19 = useLocalization
	local t2 = {
		title = vpcPrologueStrings.title
	}
	local recourseData = t1.recourseData

	t2.body = if not recourseData then vpcPrologueStrings.bodyGeneric else if recourseData.enablePurchases ~= true then if recourseData.contentAgeRestriction == nil then if recourseData.friendManagementAction ~= "Unblock" then vpcPrologueStrings.bodyGeneric else vpcPrologueStrings.bodyUnblock else vpcPrologueStrings.bodyContentRestriction else vpcPrologueStrings.bodyPurchases
	t2.buttonAsk = vpcPrologueStrings.buttonAsk
	t2.buttonCancel = vpcPrologueStrings.buttonCancel

	local v22 = v19(t2)
	local t3 = {{
		text = v18.confirmText or v22.buttonAsk,
		variant = ButtonVariant.Emphasis,
		onActivated = t1.onConfirm
	}}

	if not v18.hideCancel then
		table.insert(t3, not v18.cancelFirst and 2 or 1, {
			text = v18.cancelText or v22.buttonCancel,
			variant = ButtonVariant.Standard,
			onActivated = t1.onCancel
		})
	end

	local v24 = not v18.omitLayoutOrder

	return React.createElement(Dialog.Root, {
		size = if v18.dialogSize ~= "Medium" then DialogSize.Small else DialogSize.Medium,
		hasBackdrop = v18.hasBackdrop,
		closeOnClickOutside = v18.closeOnClickOutside,
		onClose = if not v18.onClose then if not v18.onCloseCancels then nil else t1.onCancel else v18.onClose
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = if not v24 then nil else 1,
			text = v18.titleText or v22.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = if not v24 then nil else 2
		}, {
			Text = v18.bodyContent or React.createElement(Dialog.Text, {
				Text = v18.bodyText or v22.body
			})
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = if not v24 then nil else 3,
			orientation = if v18.actionOrientation ~= "Vertical" then if v18.actionOrientation ~= "Horizontal" then nil else EnumsOrientation.Horizontal else EnumsOrientation.Vertical,
			actions = t3
		})
	})
end
local function LegacyVPCPrologue(t4: {[any]: any}) -- line: 94
	-- upvalues: vpcPrologueStrings (copy), useLocalization (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local recourseData = t4.recourseData
	local v27 = if not recourseData then vpcPrologueStrings.bodyGeneric else if recourseData.enablePurchases ~= true then if recourseData.contentAgeRestriction == nil then if recourseData.friendManagementAction ~= "Unblock" then vpcPrologueStrings.bodyGeneric else vpcPrologueStrings.bodyUnblock else vpcPrologueStrings.bodyContentRestriction else vpcPrologueStrings.bodyPurchases
	local v28 = useLocalization({
		title = vpcPrologueStrings.title,
		body = v27,
		buttonAsk = vpcPrologueStrings.buttonAsk,
		buttonCancel = vpcPrologueStrings.buttonCancel
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v28.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Text = React.createElement(Dialog.Text, {
				Text = v28.body
			})
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v28.buttonAsk,
					variant = ButtonVariant.Emphasis,
					onActivated = t4.onConfirm
				},
				{
					text = v28.buttonCancel,
					variant = ButtonVariant.Standard,
					onActivated = t4.onCancel
				}
			}
		})
	})
end
local function VPCPrologue(t5: {[any]: any}) -- line: 131
	-- upvalues: React (copy), GetFFlagEnableReusableVPCPrologue (copy), ConfigurableVPCPrologue (copy), LegacyVPCPrologue (copy)
	return React.createElement(if not GetFFlagEnableReusableVPCPrologue() then LegacyVPCPrologue else ConfigurableVPCPrologue, t5)
end

return VPCPrologue
