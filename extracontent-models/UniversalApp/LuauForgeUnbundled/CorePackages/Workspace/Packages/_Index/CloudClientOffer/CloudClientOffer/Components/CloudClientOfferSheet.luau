local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/React")

local CloudClientOfferSheetText = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Components/CloudClientOfferSheetText")
require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/createCloudClientOffer")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local function CloudClientOfferSheet(props)
	local v5 = CloudClientOfferSheetText[props.offerKind]

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
		Body = React.createElement(text, {
			LayoutOrder = 1,
			Text = v5.body,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
		})
	}

	for k, feature in v5.features do
		children[`Feature{k}`] = React.createElement(text, {
			LayoutOrder = 1 + k,
			Text = feature,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
		})
	end

	return React.createElement(
		sheet.Root,
		{
			preferCenterSheet = true,
			onClose = props.onDismiss,
			testId = "cloud-client-offer-sheet"
		},
		{
			Header = React.createElement(sheet.Header, { hasCloseAffordance = true }, {
				Title = React.createElement(text, {
					Text = v5.title,
					tag = "auto-xy text-heading-medium text-align-x-left content-emphasis"
				})
			}),
			Content = React.createElement(sheet.Content, nil, {
				Layout = React.createElement(
					view,
					{ tag = "col gap-medium size-full-0 auto-y" },
					children
				)
			}),
			Actions = React.createElement(sheet.Actions, nil, {
				Layout = React.createElement(view, {
					tag = "col gap-small size-full-0 auto-y"
				}, {
					Accept = React.createElement(button, {
						LayoutOrder = 1,
						text = v5.accept,
						variant = buttonVariant.Emphasis,
						width = UDim.new(1, 0),
						onActivated = props.onAccept,
						testId = "cloud-client-offer-sheet-try-now"
					}),
					Decline = React.createElement(button, {
						LayoutOrder = 2,
						text = v5.decline,
						variant = buttonVariant.Utility,
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
