local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

require(parent.InExperienceOffers)

local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function OfferTermsDialog(p)
	local terms = p.terms

	return React.createElement(
		Dialog.Root,
		{ size = DialogSize.Medium, hasBackdrop = true, disablePortal = false, onClose = p.onClose },
		{
			Title = React.createElement(Dialog.Title, { text = terms.title, LayoutOrder = 1 }),
			Content = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				BodyText = React.createElement(Dialog.Text, { Text = terms.body })
			}),
			Actions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = terms.buttonText,
						variant = ButtonVariant.Emphasis,
						onActivated = p.onClose
					}
				}
			})
		}
	)
end

return OfferTermsDialog
