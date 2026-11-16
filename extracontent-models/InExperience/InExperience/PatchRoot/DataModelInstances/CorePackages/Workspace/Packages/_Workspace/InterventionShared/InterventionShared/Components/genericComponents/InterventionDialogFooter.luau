local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local React = require(parent.React)

local InlineAppealLink = require(InterventionShared.Components.genericComponents.InlineAppealLink)

local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Text = Foundation.Text
local View = Foundation.View

local function InterventionDialogFooter(props)
	local createElement = React.createElement

	local v = {
		AppealLink = props.isAppealable and React.createElement(InlineAppealLink, {
			onActivated = props.onAppealActivated,
			LayoutOrder = 1
		}),
		Cta = React.createElement(Button, {
			variant = ButtonVariant.Emphasis,
			size = ButtonSize.Medium,
			text = props.ctaText,
			onActivated = props.onCtaActivated,
			width = UDim.new(1, 0),
			testId = "intervention-dialog-footer-cta",
			LayoutOrder = 2
		}),
		DsaMessage = 0
	}

	local dsaMessage = props.dsaMessage

	if dsaMessage then
		if props.dsaMessage == "" then
			dsaMessage = false
		else
			dsaMessage = React.createElement(Text, {
				Text = props.dsaMessage,
				tag = "auto-xy text-caption-small text-wrap text-align-x-left content-default",
				testId = "intervention-dialog-footer-dsa-message",
				LayoutOrder = 3
			})
		end
	end

	v.DsaMessage = dsaMessage
	return createElement(
		View,
		{
			tag = "col no-flex gap-medium size-full-0 auto-y",
			testId = "intervention-dialog-footer",
			LayoutOrder = 3
		},
		v
	)
end

return React.memo(InterventionDialogFooter)
