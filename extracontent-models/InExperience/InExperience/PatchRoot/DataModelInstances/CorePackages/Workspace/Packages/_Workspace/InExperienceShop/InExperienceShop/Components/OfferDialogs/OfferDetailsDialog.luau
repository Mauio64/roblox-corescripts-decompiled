local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local InExperienceOffers = require(parent.InExperienceOffers)
local useRemainingTimeText = InExperienceOffers.Hooks.useRemainingTimeText

local useOfferModalText = require(InExperienceShop.Hooks.useOfferModalText)

local Dialog = Foundation.Dialog
local View = Foundation.View
local Text = Foundation.Text
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function OfferDetailsDialog(props)
	local modal = props.modal
	local v = modal.termsAndConditions ~= nil

	local v2 = useRemainingTimeText(props.expirationTimeInUTC)
	local v3 = useOfferModalText(modal.body, v2)

	local createElement = React.createElement
	local root = Dialog.Root
	local v4 = {
		size = DialogSize.Medium,
		hasBackdrop = true,
		disablePortal = false,
		onClose = props.onClose
	}
	local children = {
		Title = React.createElement(Dialog.Title, { text = modal.title, LayoutOrder = 1 }),
		Content = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local createElement3 = React.createElement

	local v5 = {
		BodyText = React.createElement(Dialog.Text, { Text = v3.bodyText, LayoutOrder = 1 }),
		ViewTermsLink = 0
	}
	local viewTermsLink

	if v then
		viewTermsLink = React.createElement(Text, {
			tag = "auto-xy text-body-medium text-wrap text-align-x-left content-muted",
			Text = `<u>{v3.viewTermsText}</u>`,
			RichText = true,
			onActivated = props.onViewTerms,
			LayoutOrder = 2,
			testId = "OfferViewTermsLink"
		})
	end

	v5.ViewTermsLink = viewTermsLink
	children.Content = createElement2(content, { LayoutOrder = 2 }, {
		Body = createElement3(View, { tag = "col gap-small size-full-0 auto-y" }, v5)
	})

	children.Actions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		actions = {
			{
				text = modal.buttonText,
				variant = ButtonVariant.Emphasis,
				onActivated = props.onShopNow
			}
		}
	})
	return createElement(root, v4, children)
end

return OfferDetailsDialog
