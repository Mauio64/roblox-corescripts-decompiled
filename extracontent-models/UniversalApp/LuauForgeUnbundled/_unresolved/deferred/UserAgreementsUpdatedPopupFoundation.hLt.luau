local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local dialog = Foundation.Dialog
local checkbox = Foundation.Checkbox
local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/Responsive").useDeviceInsets

local userAgreementsList = require("@luauforge/bundled/fOd").UserAgreementsList

local function UserAgreementsUpdatedPopupFoundation(props)
	local v5 = useTokens()
	local v6 = useDeviceInsets()
	local v7 = props.isWideView == nil or props.isWideView
	local onPromotionalEmailsChanged = props.onPromotionalEmailsChanged

	local v8 = React.useMemo(function()
		return { top = math.round(v5.Padding.XLarge), right = 0, bottom = 0, left = 0 }
	end, { v5 })

	if v7 then
		local createElement = React.createElement
		local root = dialog.Root
		local v9 = { size = dialogSize.Medium, ref = props.containerRef }

		local children = {
			Title = React.createElement(dialog.Title, { text = props.titleText }),
			Content = 0,
			Actions = 0
		}

		local createElement2 = React.createElement
		local content = dialog.Content

		local v11 = {
			Message = React.createElement(dialog.Text, {
				LayoutOrder = 1,
				Text = props.messageText
			}),
			AgreementsList = React.createElement(userAgreementsList, {
				LayoutOrder = 2,
				agreements = props.agreements,
				margin = v8,
				useChevronArrow = true,
				useBoldTitle = true
			}),
			PromotionalEmails = 0
		}

		local v12 = if props.isPromotionalEmailsShown and onPromotionalEmailsChanged then React.createElement(checkbox, {
			LayoutOrder = 3,
			label = props.promotionalEmailsText or "",
			isChecked = props.isPromotionalEmailsChecked,
			onActivated = onPromotionalEmailsChanged
		}) else nil
		v11.PromotionalEmails = v12
		children.Content = createElement2(content, { LayoutOrder = 2 }, v11)

		children.Actions = React.createElement(dialog.Actions, {
			LayoutOrder = 3,
			actions = {
				{
					text = props.agreeButtonText,
					variant = buttonVariant.Emphasis,
					onActivated = props.onAgree,
					ref = props.agreeButtonRef
				}
			}
		})
		return createElement(root, v9, children)
	else
		local v9 = math.max(v5.Padding.XXLarge, v6.top)
		local v10 = math.max(v5.Padding.XLarge, v6.bottom)

		local createElement = React.createElement
		local v12 = { tag = "col size-full bg-surface-0", ref = props.containerRef }

		local createElement2 = React.createElement
		local v14 = {
			LayoutOrder = 1,
			tag = "col fill gap-xlarge size-full-0 auto-y padding-x-xlarge",
			padding = { top = UDim.new(0, v9) },
			testId = "UserAgreementsUpdatedPopupFoundation.Body"
		}

		local v15 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.titleText,
				tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"
			}),
			Message = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.messageText,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
			}),
			AgreementsList = React.createElement(userAgreementsList, {
				LayoutOrder = 3,
				agreements = props.agreements,
				margin = v8,
				useChevronArrow = true,
				useBoldTitle = true
			}),
			PromotionalEmails = 0
		}

		local v16 = if props.isPromotionalEmailsShown and onPromotionalEmailsChanged then React.createElement(checkbox, {
			LayoutOrder = 4,
			label = props.promotionalEmailsText or "",
			isChecked = props.isPromotionalEmailsChecked,
			onActivated = onPromotionalEmailsChanged
		}) else nil
		v15.PromotionalEmails = v16
		return createElement(view, v12, {
			Body = createElement2(view, v14, v15),
			Actions = React.createElement(view, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y padding-x-xlarge padding-top-large",
				padding = { bottom = UDim.new(0, v10) },
				testId = "UserAgreementsUpdatedPopupFoundation.Actions"
			}, {
				Agree = React.createElement(button, {
					text = props.agreeButtonText,
					variant = buttonVariant.Emphasis,
					size = inputSize.Medium,
					width = UDim.new(1, 0),
					fillBehavior = fillBehavior.Fill,
					onActivated = props.onAgree,
					ref = props.agreeButtonRef
				})
			})
		})
	end
end

return UserAgreementsUpdatedPopupFoundation
