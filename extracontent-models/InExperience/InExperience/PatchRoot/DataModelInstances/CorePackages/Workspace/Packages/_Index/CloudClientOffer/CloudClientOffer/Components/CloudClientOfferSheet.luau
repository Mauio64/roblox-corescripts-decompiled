local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CloudClientOfferSheetText = require(CloudClientOffer.Components.CloudClientOfferSheetText)
require(CloudClientOffer.createCloudClientOffer)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local function CloudClientOfferSheet(props)
	local v = CloudClientOfferSheetText[props.offerKind]

	local ref = React.useRef(props.onUnmount)
	ref.current = props.onUnmount
	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				current()
			end
		end
	end, {})

	local children = {
		Body = React.createElement(Text, {
			LayoutOrder = 1,
			Text = v.body,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	}

	for k, feature in v.features do
		children[`Feature{k}`] = React.createElement(Text, {
			LayoutOrder = 1 + k,
			Text = feature,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
		})
	end

	return React.createElement(
		Sheet.Root,
		{ preferCenterSheet = true, onClose = props.onDismiss, testId = "cloud-client-offer-sheet" },
		{
			Header = React.createElement(Sheet.Header, { hasCloseAffordance = true }, {
				Title = React.createElement(Text, {
					Text = v.title,
					tag = "auto-xy text-heading-medium text-align-x-left content-emphasis"
				})
			}),
			Content = React.createElement(Sheet.Content, nil, {
				Layout = React.createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, children)
			}),
			Actions = React.createElement(Sheet.Actions, nil, {
				Layout = React.createElement(View, { tag = "col gap-small size-full-0 auto-y" }, {
					Accept = React.createElement(Button, {
						LayoutOrder = 1,
						text = v.accept,
						variant = ButtonVariant.Emphasis,
						width = UDim.new(1, 0),
						onActivated = props.onAccept,
						testId = "cloud-client-offer-sheet-try-now"
					}),
					Decline = React.createElement(Button, {
						LayoutOrder = 2,
						text = v.decline,
						variant = ButtonVariant.Utility,
						width = UDim.new(1, 0),
						onActivated = props.onDecline,
						testId = "cloud-client-offer-sheet-join-without"
					})
				})
			})
		}
	)
end

return CloudClientOfferSheet
