local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local Foundation = require(AmpUpsellParent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local vpcPrologueStrings = require(AmpUpsell.Common.LocalizationStrings).vpcPrologueStrings

local function getBodyLocalizationKey(p1) -- line: 21
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
local function VPCPrologue(t1: {[any]: any}) -- line: 34
	-- upvalues: vpcPrologueStrings (copy), useLocalization (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local recourseData = t1.recourseData
	local v15 = if not recourseData then vpcPrologueStrings.bodyGeneric else if recourseData.enablePurchases ~= true then if recourseData.contentAgeRestriction == nil then if recourseData.friendManagementAction ~= "Unblock" then vpcPrologueStrings.bodyGeneric else vpcPrologueStrings.bodyUnblock else vpcPrologueStrings.bodyContentRestriction else vpcPrologueStrings.bodyPurchases
	local v16 = useLocalization({
		title = vpcPrologueStrings.title,
		body = v15,
		buttonAsk = vpcPrologueStrings.buttonAsk,
		buttonCancel = vpcPrologueStrings.buttonCancel
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Small
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v16.title
		}),
		Content = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, {
			Text = React.createElement(Dialog.Text, {
				Text = v16.body
			})
		}),
		Buttons = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = v16.buttonAsk,
					variant = ButtonVariant.Emphasis,
					onActivated = t1.onConfirm
				},
				{
					text = v16.buttonCancel,
					variant = ButtonVariant.Standard,
					onActivated = t1.onCancel
				}
			}
		})
	})
end

return VPCPrologue
